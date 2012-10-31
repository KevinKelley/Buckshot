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

  @override void createPrimitive(){
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

    background = new FrameworkProperty(this, 'background',
        propertyChangedCallback: (Brush value){
          _primitive.fill = value;
        },
        converter: const StringToSolidColorBrushConverter());
  }

  @override void updateLayout(){
    if (!isLoaded) return;
    _primitive.updateChildAlignments();
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
