library image_surface_controls_buckshot;

import 'package:buckshot/pal/surface/surface.dart';

class Image extends SurfaceElement
{
  /// Represents the URI location of the image.
  FrameworkProperty<String> uri;
  /// Represents the html alternate text for the image.
  FrameworkProperty<String> alt;

  ImagePrimitive _primitive;

  Image();
  Image.register() : super.register();
  makeMe() => new Image();

  @override void createElement(){
    _primitive = surfacePresenter.createPrimitive(this, new ImagePrimitive());
  }

  @override void initProperties(){
    super.initProperties();

    uri = new FrameworkProperty(this, 'uri',
        propertyChangedCallback: (String value) => _primitive.uri = value);

    alt = new FrameworkProperty(this, 'alt',
        propertyChangedCallback: (String value) => _primitive.alt = value);
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
