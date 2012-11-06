part of surface_buckshot;

abstract class SurfaceBorder extends SurfaceElement implements FrameworkContainer
{
  FrameworkProperty<Brush> background;
  FrameworkProperty<SurfaceElement> content;
  FrameworkProperty<Thickness> borderThickness;
  FrameworkProperty<Thickness> padding;
  FrameworkProperty<Color> borderColor;
  FrameworkProperty<Thickness> cornerRadius;
  FrameworkProperty<BorderStyle> borderStyle;

  SurfaceBorder.register() : super.register();
  SurfaceBorder(){
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = content;
  }

  get containerContent => content.value;

  @override void createPrimitive(){
    //_primitive = surfacePresenter.createPrimitive(this, new Box());
  }

  @override void initProperties(){
    super.initProperties();

    cornerRadius = new FrameworkProperty(this, 'cornerRadius',
        propertyChangedCallback: onCornerRadiusChanged,
        converter: const StringToThicknessConverter());

    padding = new FrameworkProperty(this, 'padding',
        propertyChangedCallback: onPaddingChanged,
        converter: const StringToThicknessConverter());

    borderStyle = new FrameworkProperty(this, 'borderStyle',
        propertyChangedCallback: onBorderStyleChanged,
        converter: const StringToBorderStyleConverter(),
        defaultValue: BorderStyle.solid
       );

    content = new FrameworkProperty(this, 'content',
        propertyChangedCallback: onContentChanged);

    borderThickness = new FrameworkProperty(this, 'borderThickness',
        propertyChangedCallback: onBorderThicknessChanged,
        converter: const StringToThicknessConverter(),
        defaultValue: new Thickness(0));

    borderColor = new FrameworkProperty(this, 'borderColor',
        propertyChangedCallback: onBorderColorChanged,
        converter: const StringToColorConverter());

    background = new FrameworkProperty(this, 'background',
        propertyChangedCallback: onBackgroundChanged,
        converter: const StringToSolidColorBrushConverter());
  }

  onBackgroundChanged(Brush brush);
  onCornerRadiusChanged(Thickness value);
  onPaddingChanged(Thickness value);
  onBorderStyleChanged(BorderStyle style);
  onContentChanged(dynamic content);
  onBorderThicknessChanged(Thickness value);
  onBorderColorChanged(Color color);
}
