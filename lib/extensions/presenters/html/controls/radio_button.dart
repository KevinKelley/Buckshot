library radio_button_html_buckshot;

import 'dart:html';
import 'package:buckshot/extensions/presenters/html/html_surface.dart';
part 'radio_button_group.dart';

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* A button that only allows a single selection when part of the same group. */
class RadioButton extends Control
{
  /// Represents the value of the radio button.
  FrameworkProperty<String> value;
  /// Represents the groupName of the radio button.
  FrameworkProperty<String> groupName;

  /// Event which fires whenever a selection change occurs on this radio button.
  final FrameworkEvent selectionChanged = new FrameworkEvent<EventArgs>();

  RadioButton()
  {
    registerEvent('selectionchanged', selectionChanged);
  }

  RadioButton.register() : super.register();
  makeMe() => new RadioButton();

  @override void initProperties(){
    super.initProperties();

    value = new FrameworkProperty(this, 'value',
      propertyChangedCallback: (String v){
        rawElement.attributes['value'] = v;
      });

    groupName = new FrameworkProperty(this, 'groupName',
      propertyChangedCallback: (String v){
        rawElement.attributes['name'] =  v;
      },
      defaultValue: 'default');
  }

  @override void initEvents(){
    super.initEvents();
//    click + (_, __){
//      selectionChanged.invoke(this, new EventArgs());
//    };
  }

  /// Gets whether the check box is checked.
  bool get isChecked {
    InputElement inputElement = rawElement as InputElement;

    return inputElement.checked;
  }

  @override void createPrimitive(){
    rawElement = new InputElement();
    rawElement.attributes['type'] = 'radio';
  }

  /// Manually sets this radio button as the selected one of a group.
  void setAsSelected(){
    InputElement inputElement = rawElement as InputElement;

    inputElement.checked = true;
    selectionChanged.invoke(this, new EventArgs());
  }

  get defaultControlTemplate => '';
}
