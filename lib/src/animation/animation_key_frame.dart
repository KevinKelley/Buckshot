part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class AnimationKeyFrame extends FrameworkObject
{
  FrameworkProperty<num> time;
  FrameworkProperty<List<AnimationState>> states;
  num _percentage; //represents a conversion of time to a percentage along a time span
 // int _ordinal; //represents the ordinal order of the keyframe in an animation sequence

  //TODO add support for easing with 'animation-timing-function'

  AnimationKeyFrame(){
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = states;
  }

  AnimationKeyFrame.register() : super.register();
  makeMe() => new AnimationKeyFrame();

  @override void initProperties(){
    super.initProperties();

    time = new FrameworkProperty(this, 'time',
        converter:const StringToNumericConverter());

    states = new FrameworkProperty(this, 'states',
        defaultValue:new List<AnimationState>());
  }

  @override void initEvents(){

  }
}
