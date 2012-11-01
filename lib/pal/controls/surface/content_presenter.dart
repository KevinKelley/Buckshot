library contenpresenter_surface_controls_buckshot;

import 'package:buckshot/pal/surface/surface.dart';

/**
 * A presenter element which itself has no visual attributes, but can display
 * a single child element.
 *
 * ContentPresenter is typically used as a placeholder element in control
 * templates.
 */
class ContentPresenter extends SurfaceElement implements FrameworkContainer
{
  FrameworkProperty<SurfaceElement> content;

  ContentPresenterPrimitive _primitive;

  ContentPresenter.register() : super.register();
  ContentPresenter(){
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = content;
  }

  @override makeMe() => new ContentPresenter();

  get containerContent => content.value;

  @override void createPrimitive(){
    _primitive = surfacePresenter.createPrimitive(this,
        new ContentPresenterPrimitive());
  }

  @override initProperties(){
    super.initProperties();

    content = new FrameworkProperty(this, 'content',
        propertyChangedCallback: (value) => _primitive.child = value);
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
  void onVAlignChanged(VerticalAlignment value){
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
