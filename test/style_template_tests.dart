library style_template_tests_buckshot;

import 'package:buckshot/buckshot.dart';
import 'package:unittest/unittest.dart';
import 'mocks.dart';

run(){
  group('StyleTemplate', (){
    test('New setter property', (){
      StyleTemplate st = new StyleTemplate();

      Expect.equals(0, st.setters.value.length);

      st.setProperty("background", new SolidColorBrush.fromPredefined(Colors.Red));

      Expect.equals(1, st.setters.value.length);
      Expect.isNotNull(st.getProperty('background'));
    });
    test('Existing setter property', (){
      final st = new StyleTemplate();

      st.setProperty("foo", "bar");
      Expect.equals("bar", st.getProperty('foo'));

      st.setProperty("foo", "apple");
      Expect.equals("apple", st.getProperty('foo'));
    });
    test('Set style to FrameworkElement', (){
      final st = new StyleTemplate();
      st.setProperty("data", '42');

      var b = new TestObject();
      b.data.value = '0';
      Expect.equals('0', b.data.value);

      b.style.value = st;
      Expect.equals('42', b.data.value);
    });
    test('null to Element non-null style', (){
      StyleTemplate st = new StyleTemplate();
      st.setProperty("data", 'red');

      var b = new TestObject();
      b.data.value = 'blue';
      Expect.equals('blue', b.data.value);

      b.style.value = st;
      Expect.equals('red', b.data.value);
      Expect.isTrue(st.registeredElements.some((e) => e == b));

      b.style.value = null;
      Expect.isFalse(st.registeredElements.some((e) => e == b));

      //style is actually reset to a blank style
      Expect.isNotNull(b.style.value);

    });
    test('replace Style', (){
      StyleTemplate st = new StyleTemplate();
      st.setProperty("data", 'red');

      StyleTemplate st2 = new StyleTemplate();
      st2.setProperty("data", 'green');

      var b = new TestObject();
      b.data.value = 'blue';
      Expect.equals('blue', b.data.value);

      b.style.value = st;
      Expect.equals('red', b.data.value);
      Expect.isTrue(st.registeredElements.some((e) => e == b));

      b.style.value = st2;
      Expect.isFalse(st.registeredElements.some((e) => e == b));
      Expect.isTrue(st2.registeredElements.some((e) => e == b));
      Expect.equals('green', b.data.value);
    });
    test('.mergeWith no fail on null list', (){
      StyleTemplate st = new StyleTemplate();
      st.mergeWith(null);
    });
    test('.mergeWith no fail if list member null', (){
      StyleTemplate st = new StyleTemplate();
      st.mergeWith([null, null, null]);
    });
    test('.mergeWith same property succeeds', (){
      StyleTemplate st = new StyleTemplate();
      st.setProperty("data", '42');

      StyleTemplate st2 = new StyleTemplate();
      st2.setProperty("data", '84');

      var b = new TestObject();
      b.data.value = '0';

      b.style.value = st;
      Expect.equals('42', b.data.value);

      b.style.value.mergeWith([st2]);
      Expect.equals('84', b.data.value);
    });
    test('.mergeWith new property succeeds', (){
      StyleTemplate st = new StyleTemplate();
      st.setProperty('data', '42');

      StyleTemplate st2 = new StyleTemplate();
      st2.setProperty("fruit", Fruit.orange);

      var b = new TestObject();
      b.data.value = '0';

      b.style.value = st;
      Expect.equals(Fruit.apple, b.fruit.value);

      b.style.value.mergeWith([st2]);
      Expect.equals(Fruit.orange, b.fruit.value);
      Expect.equals('42', b.data.value);
    });
    test('.mergeWith multiple styles succeeds', (){
      StyleTemplate st = new StyleTemplate();
      st.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Red)));

      StyleTemplate st2 = new StyleTemplate();
      st2.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Green)));

      StyleTemplate st3 = new StyleTemplate();
      st3.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Yellow)));

      var b = new TestObject();
      b.background.value = new SolidColorBrush(new Color.predefined(Colors.Blue));

      b.style.value = st;
      Expect.equals(Colors.Red.toString(), (b.background.value as SolidColorBrush).color.value.toColorString());

      //yellow should win
      //st and null should be ignored
      b.style.value.mergeWith([st2, st, null, st3]);
      Expect.equals(Colors.Yellow.toString(), (b.background.value as SolidColorBrush).color.value.toColorString());
    });
    test('.mergeWith to new Element style', (){
      StyleTemplate st = new StyleTemplate();
      st.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Red)));

      StyleTemplate st2 = new StyleTemplate();
      st2.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Green)));

      StyleTemplate st3 = new StyleTemplate();
      st3.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Yellow)));

      var b = new TestObject();
      b.background.value = new SolidColorBrush(new Color.predefined(Colors.Blue));

      //red should win
      b.style.value.mergeWith([st2, st3, null, st]);
      Expect.equals(Colors.Red.toString(), (b.background.value as SolidColorBrush).color.value.toColorString());
    });
    test('is FrameworkObject', (){
      StyleTemplate st = new StyleTemplate();
      Expect.isTrue(st is FrameworkObject);
    });
  });
}

