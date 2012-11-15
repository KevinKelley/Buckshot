part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents and element that can participate in the framework's
* [Binding] and [FrameworkProperty] model. */
abstract class FrameworkObject
  extends HashableObject
  implements PlatformElement
{
  StyleTemplate _style;

  final HashMap<FrameworkProperty, String> templateBindings =
      new HashMap<FrameworkProperty, String>();

  final HashMap<String, dynamic> stateBag = new HashMap<String, dynamic>();
  final Set<FrameworkProperty> _frameworkProperties =
      new Set<FrameworkProperty>();
  final HashMap<String, FrameworkEvent> _bindableEvents =
      new HashMap<String, FrameworkEvent>();
  final HashMap<String, EventHandler> _eventHandlers =
      new HashMap<String, EventHandler>();
  bool _firstLoad = true;
  bool isLoaded = false;

  /** Parent object of this object. */
  FrameworkObject parent;

  /// Represents a name identifier for the element.
  /// Assigning a name to an element
  /// allows it to be found and bound to by other elements.
  FrameworkProperty<String> name;

  /// A general-purpose object container.
  FrameworkProperty<dynamic> tag;

  /// Represents the data context assigned to the FrameworkElement.
  /// Declarative xml binding can be used to bind to data context.
  FrameworkProperty<dynamic> dataContext;

  /**
   * Represents the [StyleTemplate] value that is currently applied to the
   * FrameworkObject.
   */
  FrameworkProperty<StyleTemplate> style;

  /**
   * Represents a collection of [ActionBase] actions applied to this object.
   */
  FrameworkProperty<ObservableList<ActionBase>> actions;

  /// Represents a map of [Binding]s that will be bound just before
  /// the element renders to the DOM.
  final HashMap<FrameworkProperty, BindingData> lateBindings =
      new HashMap<FrameworkProperty, BindingData>();

  final Map<String, FrameworkEvent> _eventBindings =
      new Map<String, FrameworkEvent>();

  /// Fires when the FrameworkElement is inserted into the DOM.
  final FrameworkEvent<EventArgs> loaded = new FrameworkEvent<EventArgs>();
  /// Fires when the FrameworkElement is removed from the DOM.
  final FrameworkEvent<EventArgs> unloaded = new FrameworkEvent<EventArgs>();

  /// A meta-data tag that represents the container context of an element,
  /// if it has one.
  ///
  /// ### To set the container context of an element:
  ///     stateBag[CONTAINER_CONTEXT] = {propertyNameOfElementContainerContext};
  static const String CONTAINER_CONTEXT = "CONTAINER_CONTEXT";

  //allows container elements to subscribe/unsubscribe to attached property
  //changes of children.
  final FrameworkEvent<AttachedPropertyChangedEventArgs>
          attachedPropertyChanged =
          new FrameworkEvent<AttachedPropertyChangedEventArgs>();

  FrameworkObject() {
    applyVisualTemplate();
    if (platform != null){
      platform.initElement(this);
    }
    initProperties();
    initEvents();
    assert(dataContext != null);
    registerEvent('attachedpropertychanged', attachedPropertyChanged);
    registerEvent('loaded', loaded);
    registerEvent('unloaded', unloaded);

    if (this is FrameworkResource) return;
    _style = new StyleTemplate();
  }

  FrameworkObject.register();
  makeMe();

  /// Gets a boolean value indicating whether the given object
  /// is a container or not.
  bool get isContainer => this is FrameworkContainer;

  /**
   * Registers an event for later lookup during template event binding.
   * Returns immediately if reflection is enabled.
   *
   * This will go away once Dart supports reflection on all platforms.
   */
  void registerEvent(String name, FrameworkEvent event){
    if (reflectionEnabled) return;
    _bindableEvents[name.toLowerCase()] = event;
  }

  /**
   * Registers an event handler to the framework.
   *
   * This will go away once Dart supports reflection on all platforms.
   * Returns immediately if reflection is enabled.
   */
  void registerEventHandler(String name, EventHandler func){
    if (reflectionEnabled) return;
    _eventHandlers[name.toLowerCase()] = func;
  }

  /**
   * Returns true if the given [eventName] is present.
   */
  bool hasEvent(String eventName)
  {
    if (!reflectionEnabled){
      return _bindableEvents.containsKey(eventName.toLowerCase());
    }

    bool hasEventInternal(classMirror){
      final result = classMirror
          .variables
          .keys
          .some((k){
            if (k.startsWith('_')) return false;
            //TODO: provide a better checking here (= is FrameworkEvent)
            return '${eventName}' == k.toLowerCase();
          });

      if (result) return result;

      if (classMirror.superclass.simpleName != 'BuckshotObject'){
        return hasEventInternal(classMirror.superclass);
      }

      return false;
    }

    return hasEventInternal(buckshot.reflectMe(this).type);
  }

  /**
   * Returns a boolean value indicting whether the object contains
   * a [FrameworkProperty] by the given friendly [propertyName].
   */
  bool hasProperty(String propertyName){
    bool hasPropertyInternal(classMirror){
      final result = classMirror
          .variables
          .getKeys()
          .some((k){
            if (k.startsWith('_')) return false;
            //TODO: provide a better checking here (= is FrameworkProperty)
            return '${propertyName}property' == k.toLowerCase();
          });

      if (result) return result;

      if (classMirror.superclass.simpleName != 'BuckshotObject'){
        return hasPropertyInternal(classMirror.superclass);
      }

      return false;
    }

    if (reflectionEnabled){
      return hasPropertyInternal(buckshot.reflectMe(this).type);
    }else{
      final pLower = propertyName.toLowerCase();
      return _frameworkProperties.some((FrameworkProperty p) =>
              p.propertyName.toLowerCase() == pLower);
    }
  }


  Future<FrameworkProperty> getEventByName(String eventName){
    if (!reflectionEnabled){
      final c = new Completer();

      if (_bindableEvents.containsKey(eventName.toLowerCase())){
        c.complete(_bindableEvents[eventName.toLowerCase()]);
      }else{
        c.complete(null);
      }

      return c.future;
    }


    Future<FrameworkProperty> getEventNameInternal(String eventNameLowered,
        classMirror){
      final c = new Completer();

      var eventName = '';

      classMirror
      .variables
      .getKeys()
      .some((k){
        if (eventNameLowered == k.toLowerCase()){
          eventName = k;
          return true;
        }
        return false;
      });

      if (eventName == ''){
        if (classMirror.superclass.simpleName != 'BuckshotObject')
  //          && classMirror.superclass.simpleName != 'Object')
        {
          getEventNameInternal(eventNameLowered, classMirror.superclass)
            .then((result) => c.complete(result));
        }else{
          c.complete(null);
        }

      }else{
        buckshot.reflectMe(this)
          .getField(eventName)
          .then((im){
            c.complete(im.reflectee);
          });
      }

      return c.future;
    }

    return getEventNameInternal(eventName.toLowerCase(),
        buckshot.reflectMe(this).type);
  }

  //TODO: Move a generalized version of this into Miriam
  /**
   *  A [Future] that returns a [FrameworkProperty] matching the given
   * [propertyName].
   *
   * Case Insensitive.
   */
  Future<FrameworkProperty> getPropertyByName(String propertyName){
    Future<FrameworkProperty> getPropertyNameInternal(String propertyName,
        classMirror){
      final c = new Completer();

      if (this is DataTemplate){
        c.complete((this as DataTemplate).getProperty(propertyName));
        return c.future;
      }

      var name = '';

      classMirror
      .variables
      .getKeys()
      .some((k){
        if ('${propertyName}property' == k.toLowerCase()){
          name = k;
          return true;
        }
        return false;
      });


      if (name == ''){
        if (classMirror.superclass.simpleName != 'BuckshotObject')
  //          && classMirror.superclass.simpleName != 'Object')
        {
          getPropertyNameInternal(propertyName, classMirror.superclass)
            .then((result) => c.complete(result));
        }else{
          c.complete(null);
        }

      }else{
        buckshot.reflectMe(this)
          .getField(name)
          .then((im){
            c.complete(im.reflectee);
          });
      }

      return c.future;
    }

    if (reflectionEnabled){
      return getPropertyNameInternal(propertyName.toLowerCase(),
          buckshot.reflectMe(this).type);
    }else{
      final cc = new Completer();
      final result = _frameworkProperties.filter((FrameworkProperty p) =>
              p.propertyName.toLowerCase() == propertyName.toLowerCase());

      if (result.length == 0)
        {
          cc.complete(null);
        }else{
          cc.complete(result.iterator().next());
        }

      return cc.future;
    }
  }

  FrameworkProperty _getPropertyByName(String propertyName){
    throw const NotImplementedException('Convert to async .getPropertyName()'
        ' instead.');
  }


  /**
   * Returns a [Future][FrameworkProperty] from a
   * dot-notation [propertyNameChain].
   *
   * Property name queries are case in-sensitive.
   *
   * ## Examples ##
   * * "background" - returns the 'background' FrameworkProperty of
   *  the root [BuckshotObject].
   * * "content.background" - returns the 'background' FrameworkProperty of
   * the [BuckshotObject] assigned to the 'content' property.
   *
   * As long as a property in the dot chain is a [BuckshotObject] then
   * resolveProperty() will continue along until the last dot property is
   * resolved, and then return it via a [Future].
   */
  Future<FrameworkProperty> resolveProperty(String propertyNameChain){
    return FrameworkObject
              ._resolvePropertyInternal(this,
                  propertyNameChain.trim().split('.'));
  }

  /**
   * Returns a [Future][FrameworkProperty] from the first property mentioned
   * in a dot-notation [propertyNameChain].
   *
   * Property name queries are case in-sensitive.
   *
   * ## Examples ##
   * * "background" - returns the 'background' FrameworkProperty of
   *  the root [BuckshotObject].
   * * "content.background" - returns the 'content' FrameworkProperty.
   */
  Future<FrameworkProperty> resolveFirstProperty(String propertyNameChain){
    return FrameworkObject._resolvePropertyInternal(
      this,
      [propertyNameChain.trim().split('.')[0]]
      );
  }

  static Future<FrameworkProperty> _resolvePropertyInternal(
                                    FrameworkObject currentObject,
                                    List<String> propertyChain){
    final c = new Completer();

    currentObject.getPropertyByName(propertyChain[0]).then((prop){
      // couldn't resolve current property name to a property
      if (prop == null){
        new Logger('buckshot.property')
          ..warning('Property resolution failed on $currentObject, chain:'
              ' ${propertyChain}');
        c.complete(null);
      }else{
        // More properties in the chain, but cannot resolve further.
        if (prop.value is! FrameworkObject && propertyChain.length > 1){
          new Logger('buckshot.property')
            ..warning('Property resolution failed on $currentObject. Value:'
                ' ${prop.value}, chain: ${propertyChain}');
          c.complete(null);
        }else{
          // return the property if there are no further names to resolve or
          // the property is not a BuckshotObject
          if (prop.value is! FrameworkObject || propertyChain.length == 1){
            c.complete(prop);
          }else{
            // recurse down to the next BuckshotObject and property name
            _resolvePropertyInternal(prop.value,
                propertyChain.getRange(1, propertyChain.length - 1))
            .then((result) => c.complete(result));
          }
        }
      }
    });

    return c.future;
  }

  String get safeName => '${toString()}${hashCode}';

  /**
   * Called by the framework during object initialization to initialize any
   * [FrameworkEvent]s.
   *
   * Override this method to initalize events, but don't forget to allow
   * any superclass initialization to occur:
   *
   *     void initEvents(){
   *       super.initEvents();
   *       // Init your events here.
   *     }
   */
  void initEvents(){
    new Logger('buckshot.object')
    ..finest('initializing events for $this');
  }

  /**
   * Called by the farmework during object initialization to initialize any
   * [FrameworkProperty] fields for the element.
   *
   * Override this method to initialize [FrameworkProperty]s, but don't forget
   * to allow any superclass initializatino to occur:
   *
   *     void initProperties(){
   *       super.initProperties();
   *       // Init your properties here.
   *     }
   */
  void initProperties(){
    tag = new FrameworkProperty(this, 'tag');

    name = new FrameworkProperty(
      this,
      "name",
      propertyChangedCallback:(String value){

        if (name.previousValue != null){
          throw new BuckshotException('Attempted to assign name "${value}"'
          ' to element that already has a name "${name.previousValue}"'
          ' assigned.');
        }

        if (value != null){
          namedElements[value] = this;
          //if (rawElement != null) rawElement.attributes["ID"] = value;
        }
      });

    dataContext = new FrameworkProperty(this, "dataContext");

    actions = new FrameworkProperty(this, 'actions',
      propertyChangedCallback: (ObservableList<ActionBase> aList){
        if (actions != null){
          throw const BuckshotException('FrameworkElement.actionsProperty'
              ' collection can only be assigned once.');
        }

        aList.listChanged + (_, ListChangedEventArgs args){
          if (args.oldItems.length > 0) {
            throw const BuckshotException('Actions cannot be removed once'
                ' added to the collection.');
          }

          //assign this element as the source to any new actions
          args.newItems.forEach((ActionBase action){
            action._source.value = this;
          });
        };
      },
    defaultValue: new ObservableList<ActionBase>());

    if (this is FrameworkResource)
    {
      // Prevents stack overflow since resources don't need style property
      // anyway.
      style = new FrameworkProperty(this, 'style');
      return;
    }

    style = new FrameworkProperty(
        this,
        "style",
        propertyChangedCallback: (StyleTemplate value){
          if (value == null){
            //setting non-null style to null
            _style._unregisterElement(this);
            style.previousValue = _style;
            _style = new StyleTemplate();
            style.value = _style;
          }else{
            //replacing style with style
            if (_style != null) _style._unregisterElement(this);
            value._registerElement(this);
            _style = value;
          }
        },
        defaultValue: new StyleTemplate());

    new Logger('buckshot.object')
    ..finest('initializing properties for $this');
  }

  /** Called when the object is loaded into a [platform] view. */
  @override void onLoaded(){
    updateDataContext();
    if (_firstLoad){
      onFirstLoad();
      _firstLoad = false;
    }
    isLoaded = true;
    updateLayout();
    loaded.invoke(this, new EventArgs());
    new Logger('buckshot.object')..finest('loaded $this');
  }

  /** Called when the object is unloaded from a [platform] view. */
  @override void onUnloaded(){
    isLoaded = false;
    unloaded.invoke(this, new EventArgs());
    new Logger('buckshot.object')..finest('unloaded $this');
  }
  @override void onFirstLoad(){
    new Logger('buckshot.object')..finest('first load of $this');
  }

  bool _dataContextUpdated = false;
  void updateDataContext(){
    if (_dataContextUpdated) return;
    _dataContextUpdated = true;

    //log('updating data context $this', element: this, logLevel: Level.WARNING);
    //TODO: Support multiple datacontext updates

    final dcs = _resolveAllDataContexts();

    //log('data contexts: ${dcs}', element: this);

    if (dcs.isEmpty) return;

    _wireEventBindings(dcs);

    final dc = dcs[0];

    //log('>>> $lateBindings', element: this);

    if (lateBindings.isEmpty) return;
    _wireLateBindings(dc);
  }

  void _wireLateBindings(dc){
    //log('wiring late bindings', element: this);
    //binding each property in the lateBindings collection
    //to the data context
    lateBindings
      .forEach((FrameworkProperty p, BindingData bd){
        //log('working on ${p.propertyName}', element: this);
        if (bd.dataContextPath == ""){
          //log('late binding $dc to $p', element:this);
          new Binding(dc, p);
        }else{
          if (dc.value is! FrameworkObject) {
            throw new BuckshotException("Datacontext binding attempted to"
              " resolve properties '${bd.dataContextPath}'"
              " on non-BuckshotObject type.");
          }

          //TODO keep a reference to these so they can be removed if the
          // datacontext changes
          if (bd.converter != null){
            dc.value.resolveProperty(bd.dataContextPath)
            .then((prop){
                new Binding(prop,
                    p, bindingMode:bd.bindingMode, converter:bd.converter);
            });
          }else{
            dc.value.resolveProperty(bd.dataContextPath)
            .then((prop){
                new Binding(prop, p, bindingMode:bd.bindingMode);
            });
          }
        }
      });
  }

  void _wireEventBindings(List dataContexts){
    if (_eventBindings.isEmpty) return;
    if (!reflectionEnabled){
      _eventBindings
        .forEach((String handler, FrameworkEvent event){
          handler = handler.toLowerCase();

          if (_globalEventHandlers.containsKey(handler)){
            // handler found in global registry
            event.register(_globalEventHandlers[handler]);
          }else{
            // work through each dataContext and try to find a matching
            // handler

            for(final dc in dataContexts){
              final dcv = dc.value;
              if (dcv != null && dcv is FrameworkObject &&
                  dcv._eventHandlers.containsKey(handler)){
                event.register(dcv._eventHandlers[handler]);
                break;
              }
            }
          }
        });

      return;
    }

    if (dataContexts.isEmpty){
      // global event handler
      final lm = buckshot.mirrorSystem.isolate.rootLibrary;
      _eventBindings
        .forEach((String handler, FrameworkEvent event){
          if (lm.functions.containsKey(handler)){

            //invoke the handler when the event fires
            event + (sender, args){
              lm.invoke(handler, [buckshot.reflectMe(sender),
                                  buckshot.reflectMe(args)]);
            };
          }
      });
    }else{
      _eventBindings
        .forEach((String handler, FrameworkEvent event){
          for(final dc in dataContexts){
            if (dc.value == null) continue;

            final im = buckshot.reflectMe(dc.value);

            if (im.type.methods.containsKey(handler)){

              //invoke the handler when the event fires
              event + (sender, args){
                im.invoke(handler, [buckshot.reflectMe(sender),
                                    buckshot.reflectMe(args)]);
              };

              break;
            }
          }
      });
    }
  }

  /// Returns the first non-null [dataContext] [FrameworkProperty]
  /// in the this [FrameworkElement]'s heirarchy.
  ///
  /// Returns null if no non-null [dataContext] can be found.
  FrameworkProperty resolveDataContext(){
    if (dataContext.value != null) return dataContext;
    if (parent == null) return null;
    return parent.resolveDataContext();
  }

  List<FrameworkProperty> _resolveAllDataContexts(){
    var list = new List<FrameworkProperty>();

    if (dataContext.value != null) list.add(dataContext);

    if (parent == null) return list;

    list.addAll(parent._resolveAllDataContexts());

    return list;
  }

  /**
   * Override to apply a construct a custom visual template and assign
   * to [rawElement].
   *
   * This is an advanced operation and should not be used unless the
   * the implementor knows what they are doing. This function is typically
   * used by the [Control] class to construct control templates at runtime.
   */
  void applyVisualTemplate() {
    //the base method just calls CreateElement
    //sub-classes (like Control) will use this to apply
    //a visual template
    createPrimitive();
  }

  /**
   *  Called by the framework to allow an element to construct it's
   *  primitive model.
   *
   *  Override this method to create a primitive for a visual element.
   */
  void createPrimitive(){}

  /**
   * Called by the framework to request that an element update it's
   * visual layout.
   *
   * Override this method to update the layout of a visual element.
   */
  void updateLayout(){}

  /**
   * Returns the base type of the FrameworkObject in a String.  If the name
   * property of the object is set, then it is included as well.
   */
  String toString(){
    if (name == null || name.value == null){
      return _simpleName();
    }

    return '${_simpleName()}[${name.value}]';
  }

  // runtimeType is not working in dart2js
  String _simpleName() => super
                            .toString()
                            .replaceFirst("Instance of '", '')
                            .replaceFirst("'", '');
}