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

  @override void createPrimitive(){
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
