// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

library browser_buckshot;

import 'dart:html';
import 'package:buckshot/pal/html_surface/html_surface.dart';
export 'package:buckshot/pal/html_surface/html_surface.dart';

/**
 * Initializes the Buckshot [presenter] to the [HtmlSurface] presenter.
 *
 * IMPORTANT:  This should be called first before making any other calls
 * to the Buckshot API.
 */
void initPresenter(){
  presenter = new HtmlSurface();
}