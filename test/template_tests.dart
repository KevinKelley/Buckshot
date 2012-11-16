library template_tests_buckshot;

import 'dart:html';
import 'package:buckshot/buckshot.dart';
import 'package:unittest/unittest.dart';
import 'mocks.dart';

void run(){
  registerElement(new TestObject.register());

  group('Template', (){
    test('event bindings wire up from template', (){
      final vm = new TestViewModel();

      Template
      .deserialize("<testobject on.click='click_handler' content='click me' />")
      .then(expectAsync1((TestObject t){
        Expect.isTrue(t is TestObject, 't is button');

        t.dataContext.value = vm;

        // fire the click event
        t.click.invoke(t, null);

        Expect.equals(42, vm.testProperty.value);
      }));
    });
//    test('registry lookup not found throws', (){
//      String t = "<bar></bar>";
//
//      final test = Template.deserialize(t);
//
//      Expect.throws((){
//        test.then(expectAsync1((tt){
//          print('$tt');
//        }));
//      });
//
//    });

    test('core elements', (){
      String t = '''
          <testobject>
            <testobject />
          </testobject>
          ''';

      Template.deserialize(t)
      .then(expectAsync1((result){
        Expect.isTrue(result is TestObject);
        Expect.equals(7, result.children.length);

        Expect.isTrue(result.children[0] is TestObject, "TestObject");
      }));
    });
    test('simple properties', (){
      String testString = "Hello World";
      String t = '<testobject data="$testString"></TextBlock>';
      Template.deserialize(t)
      .then(expectAsync1((result){
        Expect.equals(testString, (result as TestObject).data.value);
      }));
    });
    test('enum properties', (){
      String t = '<testobject fruit="orange" />';

      Template
      .deserialize(t)
      .then(expectAsync1((result){
        Expect.equals(Fruit.orange, result.fruit.value);
      }));
    });
    test('attached properties', (){
      String t = '''
          <testobject testobject.foo='bar' />
          ''';

      Template
      .deserialize(t)
      .then(expectAsync1((result){
        Expect.equals('bar', TestObject.getFoo(result));
      }));
    });
//    test('child element of non-container throws', (){
//      String t = "<Slider><TextBlock></TextBlock></Slider>";
//
//      Expect.throws(
//          () {
//            Template.deserialize(t)
//            .then(expectAsync1((result){
//              Expect.isNull(result);
//            }));
//          },
//          (err) => (err is PresentationProviderException)
//      );
//    });
//    test('invalid property node throws', (){
//      String t = "<Slider><fooProperty>bar</fooProperty></Slider>";
//
//      Expect.throws(
//          (){
//            Template.deserialize(t)
//            .then(expectAsync1((result){
//              Expect.isNull(result);
//            }));
//          },
//          (err) => (err is PresentationProviderException)
//      );
//    });
//    test('text in non-container throws', (){
//      String t = "<Slider>hello world</Slider>";
//
//      Expect.throws(
//          ()=> Template.deserialize(t),
//          (err) => (err is PresentationProviderException));
//    });
//    test('text node in list container throws', (){
//      String t = "<Stack>hello world</Stack>";
//
//      Expect.throws(
//          ()=> Template.deserialize(t),
//          (err) => (err is PresentationProviderException));
//    });
    test('simple property node assigns correctly', (){
      String t = "<testobject><data>42</data></testobject>";

      Template
      .deserialize(t)
      .then(expectAsync1((result){
        Expect.equals('42', result.data.value);
      }));
    });
    test('enum property node assigns correctly', (){
      String t = "<testobject><fruit>orange</fruit></testobject>";

      Template.deserialize(t)
      .then(expectAsync1((result){
        Expect.equals(Fruit.orange, (result as TestObject).fruit.value);
      }));
    });
    test('attached property node assigns correctly', (){
      final t = "<testobject><testobject.foo>bar</testobject.foo></testobject>";
      Template
      .deserialize(t)
      .then(expectAsync1((result){
        Expect.equals('bar', TestObject.getFoo(result));
      }));
    });
  });
}


class TestViewModel extends ViewModelBase
{
  FrameworkProperty testProperty;

  TestViewModel(){

    if (!reflectionEnabled){
      registerEventHandler('click_handler', click_handler);
    }

    testProperty = new FrameworkProperty(this, 'test');
  }

  void click_handler(sender, args){
    testProperty.value = 42;
  }
}

