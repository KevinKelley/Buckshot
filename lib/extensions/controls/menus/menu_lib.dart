// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('menus.controls.buckshotui.org');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:dartnet_event_model/events.dart');
#import('package:dart_utils/shared.dart');
#import('package:dart_utils/web.dart');

#source('menu.dart');
#source('menu_item.dart');
#source('text_menu_strip.dart');
#source('content_menu_strip.dart');

/**
 * Registers control components to the framework if reflection is not
 * enabled.
 */
void registerMenuControls(){
  if (reflectionEnabled) return;

  buckshot.registerElement(new Menu.register());
  buckshot.registerElement(new MenuItem.register());
  buckshot.registerElement(new TextMenuStrip.register());
  buckshot.registerElement(new ContentMenuStrip.register());
}

