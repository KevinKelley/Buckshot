library textblock_surface_controls_buckshot;

import 'package:buckshot/pal/surface/surface.dart';

class TextBlock extends SurfaceElement
{
  FrameworkProperty<Brush> background;
  FrameworkProperty<Color> foreground;
  FrameworkProperty<String> text;
  FrameworkProperty<num> fontSize;
  FrameworkProperty<String> fontFamily;

  //TODO: make strongly typed versions
  FrameworkProperty<String> decoration;
  FrameworkProperty<String> fontWeight;

  TextPrimitive _primitive;

  TextBlock()
  {
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = text;
  }

  TextBlock.register() : super.register();
  makeMe() => new TextBlock();

  @override void initProperties(){
    super.initProperties();

    fontWeight = new FrameworkProperty(this, 'fontWeight',
      propertyChangedCallback: (String value) => _primitive.fontWeight = value);

    decoration = new FrameworkProperty(this, 'decoration',
      propertyChangedCallback:
        (String value) => _primitive.decoration = value);

    background = new FrameworkProperty(
      this,
      "background",
      propertyChangedCallback: (Brush value) => _primitive.background = value,
      converter:const StringToSolidColorBrushConverter());

    foreground = new FrameworkProperty(
      this,
      "foreground",
      propertyChangedCallback: (Color c) => _primitive.foreground = c,
      defaultValue: getResource('theme_text_foreground'),
      converter:const StringToColorConverter());

    text = new FrameworkProperty(
      this,
      "text",
      propertyChangedCallback: (String value) => _primitive.text = value);

    fontSize = new FrameworkProperty(
      this,
      "fontSize",
      propertyChangedCallback: (num value) => _primitive.fontSize = value,
      converter: const StringToNumericConverter());

    fontFamily = new FrameworkProperty(
      this,
      "fontFamily",
      propertyChangedCallback: (value) => _primitive.fontFamily = value,
      defaultValue:getResource('theme_text_font_family'));

    background = new FrameworkProperty(this, 'background',
        propertyChangedCallback: (Brush value){
          _primitive.background = value;
        },
        converter: const StringToSolidColorBrushConverter());
  }

  void createElement(){
    _primitive = surfacePresenter.createPrimitive(this, new TextPrimitive());
  }

  void onUserSelectChanged(bool value){}
  void onMarginChanged(Thickness margin){
    _primitive.margin = margin;
  }
  void onWidthChanged(num value){
    _primitive.width = value;
  }
  void onHeightChanged(num value){
    _primitive.height = value;
  }
  void onMaxWidthChanged(num value){}
  void onMaxHeightChanged(num value){}
  void onMinWidthChanged(num value){}
  void onMinHeightChanged(num value){}
  void onCursorChanged(Cursors value){}
  void onHAlignChanged(HorizontalAlignment value){
    _primitive.hAlign = value;
    if (!isLoaded) return;
    parent.updateLayout();
  }
  void onValignChanged(VerticalAlignment value){
    _primitive.vAlign = value;
    if (!isLoaded) return;
    parent.updateLayout();
  }
  void onZOrderChanged(num value){}
  void onOpacityChanged(num value){}
  void onVisibilityChanged(num value){}
  void onStyleChanged(StyleTemplate value){}
  void onDraggableChanged(bool draggable){}
}
