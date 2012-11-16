part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Event-driven action that sets the property of a given element with a given value.
*/
class SetProperty extends ActionBase
{
  FrameworkProperty property;
  FrameworkProperty value;


  SetProperty();
  SetProperty.register() : super.register();
  makeMe() => new SetProperty();

  @override void initProperties(){
    super.initProperties();
    property = new FrameworkProperty(this, 'property');
    value = new FrameworkProperty(this, 'value');
  }

  @override void onEventTrigger(){
    //TODO throw?
//    print('triggered: target: $target, property: $property, value: $value');
    if (property.value == null || value.value == null) return;

    var el = target.value != null
        ? namedElements[target.value]
        : _source.value;
//    print('>>> $el');
    if (el == null) return; //TODO throw?

    el
      .getPropertyByName(property.value)
      .then((prop){
        if (prop == null) return;

        prop.value = value.value;
      });
  }
}