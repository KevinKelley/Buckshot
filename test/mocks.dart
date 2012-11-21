library mocks;
import 'package:buckshot/buckshot.dart';

/**
 * A mock object for use in unit testing.
 */
class TestObject extends FrameworkObject implements FrameworkContainer
{
  final FrameworkEvent<EventArgs> click = new FrameworkEvent<EventArgs>();
  final ObservableList<FrameworkObject> children =
      new ObservableList<FrameworkObject>();

  FrameworkProperty<String> data;
  FrameworkProperty<Fruit> fruit;
  static AttachedFrameworkProperty fooProperty;

  TestObject.register() : super.register(){
    registerEvent('click', click);
    registerAttachedProperty('testobject.foo', TestObject.setFoo);
  }
  TestObject(){
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = children;
  }
  @override makeMe() => new TestObject();

  @override void initProperties(){
    super.initProperties();

    data = new FrameworkProperty(this, 'data');

    fruit = new FrameworkProperty(this, 'fruit',
        defaultValue: Fruit.apple,
        converter: const StringToFruitConverter());
  }

  @override get containerContent => children;

  static void setFoo(FrameworkObject element, value){
    //assert(value is String || value is DockLocation);

    if (element == null) return;

    //value = const StringToLocationConverter().convert(value);

    if (TestObject.fooProperty == null) {
      TestObject.fooProperty = new AttachedFrameworkProperty("foo",
        (FrameworkObject e, String fooInfo){});
    }

    AttachedFrameworkProperty.setValue(element, fooProperty, value);
  }

  static String getFoo(FrameworkObject element){
    if (element == null) return '[empty]';

    final value = AttachedFrameworkProperty.getValue(element, fooProperty);

    if (TestObject.fooProperty == null || value == null) {
      TestObject.setFoo(element, '[empty]');
    }

    return AttachedFrameworkProperty.getValue(element, fooProperty);
  }
}

/**
 * Enum for unit testing.
 */
class Fruit
{
  final String _str;

  const Fruit(this._str);

  static const apple = const Fruit('apple');
  static const peach = const Fruit('peach');
  static const pear = const Fruit('pear');
  static const orange = const Fruit('orange');

  String toString() => _str;
}

/**
 * String to Fruit value converter.
 */
class StringToFruitConverter implements ValueConverter
{
  const StringToFruitConverter();

  @override convert(value, {parameter}){
    if (value is! String) return value;

    switch(value){
      case 'apple': return Fruit.apple;
      case 'peach': return Fruit.peach;
      case 'pear': return Fruit.pear;
      case 'orange': return Fruit.orange;
      default: throw 'not found';
    }
  }
}