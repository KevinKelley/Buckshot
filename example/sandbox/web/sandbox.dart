// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

import 'dart:html';
import 'package:dartnet_event_model/events.dart';
import 'package:buckshot/extensions/controls/html/all_html_controls.dart';
import 'apps/todo/todo.dart' as todo;
import 'viewmodels/calculator_viewmodel.dart';
part 'viewmodels/clock_viewmodel.dart';
part 'viewmodels/master_viewmodel.dart';
part 'models/demo_model.dart';
part 'views/main.dart';
part 'views/error_view.dart';
part 'views/calculator/calculator.dart';
part 'views/calculator/extended_calc.dart';
part 'views/calculator/standard_calc.dart';
part 'views/clock.dart';

void main() {
  initHtmlControls();

  setView(new Main())
    .then((t){
        bindToWindowDimensions(t.parent);

        (t.parent as Border).background.value = getResource('theme_dark_brush');

        (t.parent as Border).verticalScrollEnabled.value = true;

        final demo = queryString['demo'];

        if (demo != null){
          t.dataContext.value.setTemplate('${demo}');
        }else{
          t.dataContext.value.setTemplate('welcome');
          t.dataContext.value.setQueryStringTo('welcome');
        }
    });


}


Map<String, String> get queryString {
  var results = {};
  var qs;
  qs = window.location.search.isEmpty ? ''
      : window.location.search.substring(1);
  var pairs = qs.split('&');

  for(final pair in pairs){
    var kv = pair.split('=');
    if (kv.length != 2) continue;
    results[kv[0]] = kv[1];
  }

  return results;
}