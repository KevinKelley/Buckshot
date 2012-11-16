library framework_properties_tests_buckshot;

import 'dart:html';
import 'package:buckshot/buckshot.dart';
import 'package:unittest/unittest.dart';
import 'mocks.dart';

run(){
  group('FrameworkProperty', (){
    test('resolve 1st level property"', (){
      TestObject b = new TestObject();
      b.data.value = 'foo';

      b.resolveProperty("data")
      .then(expectAsync1((result){
        Expect.isTrue(result.value is String);
        Expect.equals('foo', result.data.value);
      }));
    });
    test('resolve nth level property', (){
      Expect.fail('not implemented');
    });
    test('resolve returns null on property not found', (){
      TestObject b = new TestObject();

      b.resolveProperty("foo")
      .then(expectAsync1((result){
        Expect.isNull(result);
      }));
    });
    test('resolve returns null on orphan properties', (){
      TestObject b = new TestObject();
      b.data.value = '42';

      b.resolveProperty("data.foo")
      .then(expectAsync1((result){
        Expect.isNull(result);
      }));
    });
    test('resolve is case in-sensitive', (){
      TestObject b = new TestObject();
      b.data.value = '42';

      b.resolveProperty("DaTA")
      .then(expectAsync1((result){
        Expect.isTrue(result.value is String);
        Expect.equals('42', result.data.value);
      }));
    });
  });
}
