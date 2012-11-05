part of surface_buckshot;

abstract class SurfaceText extends SurfaceElement
{
  FrameworkProperty<Brush> background;
  FrameworkProperty<Color> foreground;
  FrameworkProperty<String> text;
  FrameworkProperty<num> fontSize;
  FrameworkProperty<String> fontFamily;

  //TODO: make strongly typed versions of these
  FrameworkProperty<String> decoration;
  FrameworkProperty<String> fontWeight;

  SurfaceText()
  {
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = text;
  }

  SurfaceText.register() : super.register();

  abstract onFontWeightChanged(String value);
  abstract onDecorationChanged(String decoration);
  abstract onBackgroundChanged(Brush brush);
  abstract onForegroundChanged(Color color);
  abstract onTextChanged(String text);
  abstract onFontSizeChanged(num value);
  abstract onFontFamilyChanged(String family);

  @override void initProperties(){
    super.initProperties();

    fontWeight = new FrameworkProperty(this, 'fontWeight',
      propertyChangedCallback: onFontWeightChanged);

    decoration = new FrameworkProperty(this, 'decoration',
      propertyChangedCallback: onDecorationChanged);

    foreground = new FrameworkProperty(
      this,
      "foreground",
      propertyChangedCallback: onForegroundChanged,
      defaultValue: getResource('theme_text_foreground'),
      converter:const StringToColorConverter());

    text = new FrameworkProperty(
      this, "text", propertyChangedCallback: onTextChanged);

    fontSize = new FrameworkProperty(
      this,
      "fontSize",
      propertyChangedCallback: (num value) => onFontSizeChanged,
      converter: const StringToNumericConverter());

    fontFamily = new FrameworkProperty(
      this,
      "fontFamily",
      propertyChangedCallback: onFontFamilyChanged,
      defaultValue:getResource('theme_text_font_family'));

    background = new FrameworkProperty(this, 'background',
        propertyChangedCallback: onBackgroundChanged,
        converter: const StringToSolidColorBrushConverter());
  }
}
