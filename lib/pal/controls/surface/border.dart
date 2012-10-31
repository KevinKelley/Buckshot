library border_surface_controls_buckshot;

import 'package:buckshot/pal/surface/surface.dart';

class Border extends SurfaceElement implements FrameworkContainer
{
  FrameworkProperty<Brush> background;
  FrameworkProperty<SurfaceElement> content;
  FrameworkProperty<Thickness> borderThickness;
  FrameworkProperty<Thickness> padding;
  FrameworkProperty<Color> borderColor;
  FrameworkProperty<Thickness> cornerRadius;
  FrameworkProperty<BorderStyle> borderStyle;

  Box _primitive;

  Border.register() : super.register();
  Border(){
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = content;
  }
  @override makeMe() => new Border();

  get containerContent => content.value;

//  @override void onLoaded(){
//    super.onLoaded();
//
//    print('Border loaded...');
//  }
//
//  @override void onUnloaded(){
//    super.onUnloaded();
//
//    print('Border unloaded...');
//  }

  @override void createElement(){
    _primitive = surfacePresenter.createPrimitive(this, new Box());
  }

  @override void initProperties(){
    super.initProperties();

    cornerRadius = new FrameworkProperty(this, 'cornerRadius',
        propertyChangedCallback: (Thickness value){
          _primitive.cornerRadius = value;
        },
        converter: const StringToThicknessConverter());

    padding = new FrameworkProperty(this, 'padding',
        propertyChangedCallback: (Thickness value){
          _primitive.padding = value;
        },
        converter: const StringToThicknessConverter());

    margin = new FrameworkProperty(this, 'margin',
        propertyChangedCallback: (Thickness value){
          _primitive.margin = value;
        },
        converter: const StringToThicknessConverter());

    borderStyle = new FrameworkProperty(this, 'borderStyle',
        propertyChangedCallback: (BorderStyle style){
          _primitive.strokeStyle = style;
        },
        converter: const StringToBorderStyleConverter(),
        defaultValue: BorderStyle.solid
       );

    content = new FrameworkProperty(this, 'content',
        propertyChangedCallback: (value) => _primitive.child = value);

    borderThickness = new FrameworkProperty(this, 'borderThickness',
        propertyChangedCallback: (Thickness value) => _primitive.strokeThickness = value,
        converter: const StringToThicknessConverter(),
        defaultValue: new Thickness(0));

    borderColor = new FrameworkProperty(this, 'borderColor',
        propertyChangedCallback: (Color value) => _primitive.strokeColor = value,
        converter: const StringToColorConverter());

    hAlign = new FrameworkProperty(this, 'hAlign',
        propertyChangedCallback: (HorizontalAlignment align){
          _primitive.hAlign = align;
          if (!isLoaded) return;
          parent.updateLayout();
        },
        converter: const StringToHorizontalAlignmentConverter());

    vAlign = new FrameworkProperty(this, 'vAlign',
        propertyChangedCallback: (VerticalAlignment align){
          _primitive.vAlign = align;
          if (!isLoaded) return;
          parent.updateLayout();
        },
        converter: const StringToVerticalAlignmentConverter());

    width = new FrameworkProperty(this, 'width',
        propertyChangedCallback: (num value) => _primitive.width = value,
        converter: const StringToNumericConverter());

    height = new FrameworkProperty(this, 'height',
        propertyChangedCallback: (num value) => _primitive.height = value,
        converter: const StringToNumericConverter());

    background = new FrameworkProperty(this, 'background',
        propertyChangedCallback: (Brush value){
          _primitive.fill = value;
        },
        converter: const StringToSolidColorBrushConverter());
  }

  @override void updateLayout(){
    if (content.value == null) return;
    if (!isLoaded) return;

    _primitive.updateChildLayout();
  }
}
