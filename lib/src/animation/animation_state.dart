part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class AnimationState extends TemplateObject
{
  FrameworkProperty<String> target;
  FrameworkProperty<String> property;
  FrameworkProperty<dynamic> value;

  AnimationState();

  AnimationState.register() : super.register();
  makeMe() => new AnimationState();

  @override void initEvents(){
    super.initEvents();
  }

  @override void initProperties(){
    super.initProperties();

    target = new FrameworkProperty(this, 'target');

    property = new FrameworkProperty(this, 'property');

    value = new FrameworkProperty(this, 'value');
  }
}
