library framework_object_tests_buckshot;

import 'package:buckshot/buckshot.dart';
import 'package:unittest/unittest.dart';
import 'mocks.dart';

run(){
  group('FrameworkObject', (){
    // Tests that assignment to the name property of a FrameworkObject
    // properly registers it with namedElements
    test('name registration', (){
      var b = new TestObject();
      b.name.value = "hello";

      Expect.isTrue(namedElements.containsKey("hello"));
    });

  });
}