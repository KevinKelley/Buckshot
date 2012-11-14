part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/**
* Base class for event-driven [FrameworkElement] actions.
*/
abstract class ActionBase extends FrameworkObject
{

  FrameworkProperty<String> event;

  /// A [String] representing the name of the target element to be operated
  /// on by the action.
  FrameworkProperty<String> target;
  FrameworkProperty<FrameworkObject> _source;

  FrameworkObject _target;
  FrameworkObject get source => _source.value;
  FrameworkObject get targetElement => _target;

  final HashMap <String, EventHandlerReference> _ref =
      new HashMap<String, EventHandlerReference>();

  ActionBase();
  ActionBase.register() : super.register();
  @override makeMe() => null;

  @override void initProperties(){
    super.initProperties();
    target = new FrameworkProperty(this, 'target');

    event = new FrameworkProperty(this, 'event');
//    ,
//      propertyChangedCallback: (String e){
//        // set the event against the source element if it is available,
//        // otherwise we wait until the source is available and set the
//        // event then.
//        if (_source.value != null){
//          _setEvent(e);
//        }else{
//          var ref;
//          ref = _source.propertyChanging + (_, PropertyChangingEventArgs args) {
//            _setEvent(e);
//            _source.propertyChanging - ref;
//          };
//        }
//      });

    _source = new FrameworkProperty(this, '_source',
        propertyChangedCallback: (value){
          assert(value != null);
          assert(event.value != null);
          _setEvent(event.value);
        });

  }

  _setEvent(String eventName){
    var ee = eventName.toLowerCase();

    //only allow one registration per event
    if (_ref.containsKey(ee)) return;

    var _source = _source.value;

    if (_source == null && _source is! FrameworkObject){
      throw const BuckshotException('action source is null or'
          ' is not a FrameworkElement');
    }

    if (!reflectionEnabled){
      if (_source._bindableEvents.containsKey(ee)){
        assert(_source._bindableEvents[ee] != null);
        _ref[ee] = _source._bindableEvents[ee] + (_, __) => onEventTrigger();
      }
    }else{
      // TODO Implement reflection lookup on event bindings.
      throw const NotImplementedException('Needs mirror-based impl');
    }
  }

  void onEventTrigger();

  /// Helper method used to set the target for the given action.
  /// Should
//  void resolveTarget(){
//    var tgt = targetName.value;
//    if (tgt == null){
//      if (source.name.value != null)
//      {
//        targetName.value = source.name.value;
//      }
//
//      _target = source;
//    }else{
//      var el = namedElements[targetName.value];
//
//      if (el == null) {
//        throw const BuckshotException('action Target was not found.');
//      }
//
//      _target = el;
//    }
//  }
}
