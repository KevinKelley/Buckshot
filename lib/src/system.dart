part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
 * Represents the globally available instance of the buckshot utility class.
 */
@deprecated final buckshot = new _buckshot();

const String _defaultRootID = "#BuckshotHost";

final Map<String, dynamic> _mirrorCache = new Map<String, dynamic>();

/// Central registry of named [FrameworkObject] elements.
final HashMap<String, FrameworkObject> namedElements =
  new HashMap<String, FrameworkObject>();

final HashMap<String, Function> _objectRegistry =
  new HashMap<String, Function>();

/**
 * Registers an object to the framework.
 *
 * This function is only used when reflection is not supported. It will be
 * removed once reflection is supported on all Dart platforms.
 */
void registerElement(FrameworkObject o){
  if (reflectionEnabled) return;
  _objectRegistry['${o.namespace}::${o.toString().toLowerCase()}'] = o.makeMe;
  hierarchicalLoggingEnabled = true;
  new Logger('buckshot.registration')
    ..config('Element (${o}) registered to framework as'
      ' "${o.namespace}::${o.toString().toLowerCase()}".');
}

/**
 * Registers an attached property [setterFunction] to the framework.
 *
 * This function is only used when reflection is not supported. It will be
 * removed once reflection is supported on all Dart platforms.
 */
void registerAttachedProperty(String property, setterFunction){
  hierarchicalLoggingEnabled = true;
  if (reflectionEnabled) return;

  _objectRegistry[property] = setterFunction;
  new Logger('buckshot.registration')
    ..config('Attached property (${property}) registered to framework.');
}

void _registerCoreElements(){
//resources
  registerElement(new Template.register());
  registerElement(new ResourceCollection.register());
  registerElement(new Color.register());
  registerElement(new LinearGradientBrush.register());
  registerElement(new GradientStop.register());
  registerElement(new SolidColorBrush.register());
  registerElement(new RadialGradientBrush.register());
  registerElement(new Setter.register());
  registerElement(new StyleTemplate.register());
  registerElement(new Var.register());
//actions
  registerElement(new SetProperty.register());
  registerElement(new ToggleProperty.register());
}

bool _frameworkInitialized = false;
Future initFramework(){
  if (_frameworkInitialized) return new Future.immediate(true);
  _frameworkInitialized = true;

  hierarchicalLoggingEnabled = true;
  Logger.root.level = Level.WARNING;
  Logger.root.on.record.add((LogRecord record){
    final event = '[${record.loggerName}] ${record.message}';
    _logEvents.add(event);
    print(event);
  });

  if (!reflectionEnabled){
    _registerCoreElements();
  }

  // Initializes the system object name.
  //buckshot.name.value = '__sys__';

//  if (!Polly.browserOK){
//    _log.warning('Buckshot Warning: Browser may not be compatible with Buckshot'
//    ' framework.');
//  }

  new Logger('buckshot.system')
    ..info('Reflection ${reflectionEnabled ? "enabled.": "disabled."}');

  return _loadTheme()
          .chain((_){
            new Logger('buckshot.system')..info('Framework initialized.');
            return new Future.immediate(true);
          });
}

bool _themeLoaded = false;
Future _loadTheme(){
  if (_themeLoaded) return new Future.immediate(false);
  _themeLoaded = true;

//  if (document.body.attributes.containsKey('data-buckshot-theme')){
//    _log.info('loading custom theme (${document.body.attributes['data-buckshot-theme']})');
//    return Template.deserialize(document.body.attributes['data-buckshot-theme']);
//  }else{
    new Logger('buckshot.system')..info('loading default theme');
    return Templates.deserialize(defaultTheme);
//  }
}

/**
 * Returns the object of a given [name] by searching through all
 * available in-scope libraries.
*
 * Case insensitive.
*
 * Returns null if not found.
 */
getObjectByName(String name, List<XmlNamespace> namespaces){
  final lowerName = name.toLowerCase();

  if (!reflectionEnabled){
    new Logger('buckshot.register.getObjectByName')
      .warning('looking up: $lowerName $namespaces');
    return _getObjectNoReflection(lowerName, namespaces);
  }else{
    if (_mirrorCache.containsKey(lowerName)){
      new Logger('buckshot.object_by_name')
        ..info('Returning cached object ($lowerName) from mirrorCache.');
      return _mirrorCache[lowerName];
    }

    var result;

    buckshot
    .mirrorSystem
    .libraries
    .forEach((String lName, libMirror){
      libMirror
      .classes
      .forEach((String cName, classMirror){
        if (classMirror.simpleName.toLowerCase() == lowerName){
          result = classMirror;
        }
      });
    });

    if (result != null){
      //cache result;
      new Logger('buckshot.object_by_name')
        ..info('Caching mirror object ($lowerName)');
      _mirrorCache[lowerName] = result;
    }

    return result;
  }
}

FrameworkObject _getObjectNoReflection(String name,
                                       List<XmlNamespace> namespaces){
  if (namespaces == null){
    // Attempts a friendly lookup on the first item found matching the name,
    // ignoring namespaces.
    Function found;
    final lookup = '::$name';
    _objectRegistry.forEach((String s, Function f){
      new Logger('buckshot.register.getObjectByName')
        .warning('...no namespaces. looking up: $name');
      if (found != null) return;
      if (!s.endsWith(lookup)) return;
      found = f;
    });

    return found != null ? found() : null;
  }

  // Attempts a namespace-constrained lookup
  for(final XmlNamespace n in namespaces){
    final lookup = '${n.uri}::$name';
    if (_objectRegistry.containsKey(lookup)){
      return _objectRegistry[lookup]();
    }
  }

  return null;
}

/**
 * Register global event handlers here when reflection is not enabled.  Global
 * handlers are necessary in some cases, such as when content is generated
 * within a databound CollectinoPresenter template.
 */
void registerGlobalEventHandler(String handlerName, EventHandler handler){
  if (reflectionEnabled) return;
  _globalEventHandlers[handlerName.toLowerCase()] = handler;
}

/**
 * Sets a [View] to the current [Platform] for rendering. Returns a future
 * which completes when the view is ready (fully deserialized and constructed).
 *
 * ## Deprecated ##
 * Use...
 *
 *     platform.render(view);
 *
 * ...instead.
 */
@deprecated Future<FrameworkObject> setView(View view) => platform.render(view);


/**
 * Creates a binding between [from] and [to], with optional [bindingMode]
 * and [converter] parameters.
 *
 * Typically bindings are set via template declarations, but in some cases
 * it may be necessary to declare a binding in code.
 *
 * To remove the binding, call .unregister() on the returned [Binding] object.
 */
Binding bind(FrameworkProperty from, FrameworkProperty to,
             {BindingMode bindingMode : BindingMode.OneWay,
              ValueConverter converter :const _DefaultConverter()}){
  return new Binding(from, to, bindingMode:bindingMode, converter:converter);
}

/**
 * Returns a resource object with the given [resourceKey].
 *
 * If the optional [converter] is supplied, then the value returned is
 * first passed through converter.convert();
 */
getResource(String resourceKey, {ValueConverter converter: null}){
  assert(_resourceRegistry != null);
  if (!_resourceRegistry.containsKey(resourceKey)) return null;
  var res = _resourceRegistry[resourceKey];

  if (res.stateBag.containsKey(FrameworkResource.RESOURCE_PROPERTY)){
    // resource property defined so return it's value
    res = res.stateBag[FrameworkResource.RESOURCE_PROPERTY].value;
  }

  return converter == null ? res : converter.convert(res);
}

/**
 * Registers a [FrameworkResource] to the framework.
 *
 * Will be deprecated when mirror-based reflection is supported on all
 * platforms.
 */
void registerResource(FrameworkResource resource){
  _resourceRegistry[resource.key.value.trim()] = resource;
}

/**
 * Sets the value of a given [FrameworkProperty] [property] to a given [value].
 *
 * This function is deprecated. Assign to property.value directly.
 */
@deprecated void setValue(FrameworkProperty property, dynamic value){
  new Logger('buckshot.property')
    ..warning('Using deprecated setValue() API.');
  property.value = value;
}

/**
 * Gets the current value of a given [FrameworkProperty] object.
 *
 * This function is deprecated.  Use property.value getter to get the latest
 * value.
 */
@deprecated getValue(FrameworkProperty property){
  assert(property != null);
  new Logger('buckshot.property')
    ..warning('Using deprecated getValue() API.');
  return property.value;
}

Future _functionToFuture(Function f){
  Completer c = new Completer();

  void doIt(foo) => c.complete(f());

  try{
    new Timer(0, doIt);
  }on Exception catch (e){
    c.completeException(e);
  }

  return c.future;
}

// Holds a registry of resources.
final HashMap<String, FrameworkResource> _resourceRegistry =
  new HashMap<String, FrameworkResource>();

// Holds a registry of global event handlers when reflection is not
// enabled.
final HashMap<String, EventHandler> _globalEventHandlers =
  new HashMap<String, EventHandler>();




