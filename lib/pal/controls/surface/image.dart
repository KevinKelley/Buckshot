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
    uri = new FrameworkProperty(this, 'uri',
        propertyChangedCallback: (String value) => _primitive.uri = value);

    alt = new FrameworkProperty(this, 'alt',
        propertyChangedCallback: (String value) => _primitive.alt = value);

    margin = new FrameworkProperty(this, 'margin',
        propertyChangedCallback: (Thickness value){
          _primitive.margin = value;
        },
        converter: const StringToThicknessConverter());

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
  }
}
