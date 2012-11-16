import 'dart:html';
import 'package:buckshot/buckshot.dart';
import 'package:xml/xml.dart';
import 'package:dartnet_event_model/events.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

import 'dart_tests.dart' as dart;
import 'binding_tests.dart' as binding;
import 'template_tests.dart' as template;
import 'framework_object_tests.dart' as frameworkobject;
import 'framework_property_tests.dart' as frameworkproperty;
import 'style_template_tests.dart' as styletemplates;
import 'var_resource_tests.dart' as varresource;

void main() {
  useHtmlEnhancedConfiguration();

//  dart.run();
  binding.run();
  template.run();
  frameworkobject.run();
  frameworkproperty.run();
  styletemplates.run();
  varresource.run();
}


