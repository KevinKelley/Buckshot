// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

library browser_buckshot;

import 'dart:html';
import 'package:buckshot/pal/html_layout_provider/html_layout_provider.dart';
export 'package:buckshot/pal/html_layout_provider/html_layout_provider.dart';

/**
 * Sets the Buckshot presentation provider to the HtmlLayoutProvider.
 */
void setPresentationProvider(){
  PresentationProvider.provider = new HtmlLayoutProvider();
}