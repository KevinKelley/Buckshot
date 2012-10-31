library stack_surface_controls_buckshot;

import 'package:buckshot/pal/surface/surface.dart';

class Stack extends SurfaceElement implements FrameworkContainer
{
  FrameworkProperty<Orientation> orientation;
  FrameworkProperty<Brush> background;

  StackPanel _primitive;

  Stack.register() : super.register();
  Stack(){
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = children;
  }
  @override makeMe() => new Stack();

  get containerContent => children;

  ObservableList<SurfaceElement> get children => _primitive.children;

  @override void createElement(){
    _primitive = surfacePresenter.createPrimitive(this, new StackPanel());
  }

  @override void initProperties(){
    super.initProperties();

    orientation = new FrameworkProperty(this, 'orientation',
        propertyChangedCallback: (Orientation value){
          _primitive.orientation = value;
        },
        converter: const StringToOrientationConverter(),
        defaultValue: Orientation.vertical);

    hAlign = new FrameworkProperty(this, 'hAlign',
        propertyChangedCallback: (HorizontalAlignment align){
          _primitive.hAlign = align;
          if (!isLoaded) return;
          parent.updateLayout();
        },
        defaultValue: HorizontalAlignment.left,
        converter: const StringToHorizontalAlignmentConverter());

    vAlign = new FrameworkProperty(this, 'vAlign',
        propertyChangedCallback: (VerticalAlignment align){
          _primitive.vAlign = align;
          if (!isLoaded) return;
          parent.updateLayout();
        },
        defaultValue: VerticalAlignment.top,
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

    margin = new FrameworkProperty(this, 'margin',
        propertyChangedCallback: (Thickness value){
          _primitive.margin = value;
        },
        converter: const StringToThicknessConverter());
  }
}
