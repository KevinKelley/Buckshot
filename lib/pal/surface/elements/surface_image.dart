part of surface_buckshot;

abstract class SurfaceImage extends SurfaceElement
{
  /// Represents the URI location of the image.
  FrameworkProperty<String> uri;
  /// Represents the html alternate text for the image.
  FrameworkProperty<String> alt;

  SurfaceImage();
  SurfaceImage.register() : super.register();

  abstract void onUriChanged(String newUri);
  abstract void onAltChanged(String newAlt);

  @override void initProperties(){
    super.initProperties();

    uri = new FrameworkProperty(this, 'uri',
      propertyChangedCallback: onUriChanged);

    alt = new FrameworkProperty(this, 'alt',
      propertyChangedCallback: onAltChanged);
  }
}
