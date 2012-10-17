// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* A base class for control-type elements (buttons, etc). */
class Control extends FrameworkElement
{
  FrameworkProperty<bool> isEnabled;

  FrameworkElement template;

  Future templateApplied;
  final Completer _c;

  String get defaultControlTemplate => '';

  bool _visualTemplateApplied = false;    // flags if visual template applied
  bool _templateApplied = false;          // flags if a template was used during applyVisualTemplate();
  bool _templateBindingsApplied = false;  // flags if template bindings have been applied

//  final HashMap<FrameworkProperty, String> _allTemplateBindings;

  Control()
      :
        _c = new Completer()
//  : _allTemplateBindings = new HashMap<FrameworkProperty, String>()
  {
    templateApplied = _c.future;
    Browser.appendClass(rawElement, "control");
    _initControlProperties();
  }

  Control.register() : super.register(),
    _c = new Completer();
  makeMe() => null;

  void _initControlProperties(){
    isEnabled = new FrameworkProperty(this, "isEnabled", (bool value){
      if (value){
        if (rawElement.attributes.containsKey('disabled'))
          rawElement.attributes.remove('disabled');
      }else{
        rawElement.attributes['disabled'] = 'disabled';
      }
    }, true, converter:const StringToBooleanConverter());
  }

  void applyVisualTemplate(){
    if (_visualTemplateApplied)
      throw const BuckshotException('Attempted to apply visual template more than once.');

    if (templateApplied == null){
      templateApplied = _c.future;
    }

    assert(templateApplied != null);

    _visualTemplateApplied = true;

    if (!defaultControlTemplate.isEmpty()){
      Template
      .deserialize(defaultControlTemplate)
      .then((_) => _finishApplyVisualTemplate());
    }else{
      _finishApplyVisualTemplate();
    }
  }

  void _finishApplyVisualTemplate(){
    var t = getResource(this.templateName) as ControlTemplate;

    if (t == null){
      template = this;
      super.applyVisualTemplate();
      return;
    }

    _templateApplied = true;

    template = t.template.value;

    rawElement = template.rawElement;
    template.parent = this;
    _c.complete(true);
  }

  onLoaded(){
    //returning if we have already done this, or if no template was actually used for this control
    if (_templateBindingsApplied || !_templateApplied) return;
    _templateBindingsApplied = true;

    _bindTemplateBindings();

    finishOnLoaded();
  }

  finishOnLoaded(){
    template.onAddedToDOM();
  }

  onUnLoaded(){
    //returning if we have already done this, or if no template was actually used for this control
    if (!_templateApplied) return;

    template.isLoaded = false;
  }

  void _bindTemplateBindings(){
    void _getAllTemplateBindings(HashMap<FrameworkProperty, String> list, FrameworkElement element){

      element
        ._templateBindings
        .forEach((k, v){
          list[k] = v;
        });

      if (element is! IFrameworkContainer) return;

      if (element.containerContent is List){
        element.containerContent.forEach((FrameworkElement child) => _getAllTemplateBindings(list, child));
      }else if (element.containerContent is FrameworkElement){
        _getAllTemplateBindings(list, element.containerContent);
      }
    }

    var tb = new HashMap<FrameworkProperty, String>();

    _getAllTemplateBindings(tb, template);

    tb.forEach((FrameworkProperty k, String v){
      getPropertyByName(v)
        .then((prop){
          if (prop == null){
            throw const BuckshotException('Attempted binding to null property in'
                ' Control.');
          }

          new Binding(prop, k);
        });
    });
  }

  /// Gets a standardized name for assignment to the [ControlTemplate] 'controlType' property.
  String get templateName => 'template_${hashCode()}';
}
