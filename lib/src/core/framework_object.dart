part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents and element that can participate in the framework's
* [Binding] and [FrameworkProperty] model. */
class FrameworkObject extends BuckshotObject implements PresenterElement
{
  bool _firstLoad = true;
  bool isLoaded = false;

  /** Parent object of this object. */
  FrameworkObject parent;

  /// Represents a name identifier for the element.
  /// Assigning a name to an element
  /// allows it to be found and bound to by other elements.
  FrameworkProperty<String> name;

  /// Represents the data context assigned to the FrameworkElement.
  /// Declarative xml binding can be used to bind to data context.
  FrameworkProperty<dynamic> dataContext;

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
    //TODO visual template needs to apply before this?
    presenter.initElement(this);
    applyVisualTemplate();
    initProperties();
    initEvents();
    registerEvent('attachedpropertychanged', attachedPropertyChanged);
    registerEvent('loaded', loaded);
    registerEvent('unloaded', unloaded);
  }

  FrameworkObject.register() : super.register();
  makeMe() => null;

  @override void initEvents(){}

  @override void initProperties(){
    name = new FrameworkProperty(
      this,
      "name",
      propertyChangedCallback:(String value){

//        if (name.previousValue != null){
//          throw new BuckshotException('Attempted to assign name "${value}"'
//          ' to element that already has a name "${name.previousValue}"'
//          ' assigned.');
//        }
//
//        if (value != null){
//          namedElements[value] = this;
//          if (rawElement != null) rawElement.attributes["ID"] = value;
//        }

      });

    dataContext = new FrameworkProperty(this, "dataContext");
  }

  @deprecated void addToLayoutTree(FrameworkObject parentElement){

    parentElement.rawElement.elements.add(rawElement);

    parent = parentElement;

    if (!parentElement.isLoaded) return;

    onAddedToDOM();
  }

  @deprecated void onAddedToDOM(){
    //parent is in the DOM so we should call loaded event and check for children

    updateDataContext();

    isLoaded = true;

    if (parent != null){
      parent.updateLayout();
    }

    onLoaded();



    if (this is! FrameworkContainer) return;

    final containerContent = (this as FrameworkContainer).containerContent;

    if (containerContent is Collection){
      containerContent
        .forEach((FrameworkElement child)
          {
            child.parent = this;
            child.onAddedToDOM();
          });
    }else if (containerContent is FrameworkElement){
      containerContent.onAddedToDOM();
    }
  }

  /** Called when the object is loaded into a [presenter] view. */
  void onLoaded(){
    isLoaded = true;
    updateDataContext();

    if (_firstLoad){
      onFirstLoad();
      _firstLoad = false;
    }

    updateLayout();

    loaded.invoke(this, new EventArgs());
  }

  /** Called when the object is unloaded from a [presenter] view. */
  void onUnloaded(){
    isLoaded = false;
    unloaded.invoke(this, new EventArgs());
  }
  void onFirstLoad(){}

  bool _dataContextUpdated = false;
  void updateDataContext(){
    if (_dataContextUpdated) return;
    _dataContextUpdated = true;

    //log('updating data context', element: this, logLevel: Level.WARNING);
    //TODO: Support multiple datacontext updates

    final dcs = _resolveAllDataContexts();

    if (dcs.isEmpty) return;

    //log('data contexts: ${dcs}', element: this);

    _wireEventBindings(dcs);

    final dc = dcs[0];

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
          if (dc.value is! BuckshotObject) {
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
              if (dcv != null && dcv is BuckshotObject &&
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

  @deprecated void removeFromLayoutTree(){
    if (rawElement != null){
      rawElement.remove();
    }

    //db('Removed from Layout Tree', this);
    final p = parent;

    parent = null;

    if (p == null || !p.isLoaded) return;

    _onRemoveFromDOM();
  }

  @deprecated _onRemoveFromDOM(){
    isLoaded = false;

    onUnloaded();
    unloaded.invoke(this, new EventArgs());

    //db('Removed from DOM', this);

    if (this is! FrameworkContainer) return;

    final cc = this as FrameworkContainer;

    if (cc.containerContent is List){
      cc.containerContent.forEach((FrameworkElement child) => child._onRemoveFromDOM());
    }else if (cc.containerContent is FrameworkElement){
      cc.containerContent._onRemoveFromDOM();
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

    if (dataContext != null && dataContext.value != null) list.add(dataContext);

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
    createElement();
  }

  /**
   *  Called by the framework to allow an element to construct it's
   *  HTML representation and assign to [rawElement].
   */
  createElement(){}

  /// Called by the framework to request that an element update it's
  /// visual layout.
  void updateLayout(){}

  /**
   * Returns the base type of the FrameworkObject in a String.  If the name
   * property of the object is set, then it is included as well.
   */
  String toString(){
    if (name == null || name.value == null){
      return super.toString();
    }

    return '${super.toString()}[${name.value}]';
  }
}