part of surface_buckshot;

class SurfaceElement extends FrameworkObject
{
  RectMeasurement previousMeasurement;
  RectMeasurement previousPosition;
  RectMeasurement mostRecentMeasurement;

  FrameworkProperty<bool> userSelect;
  /// Represents the margin [Thickness] area outside the FrameworkElement boundary.
  FrameworkProperty<Thickness> margin;
  /// Represents the width of the FrameworkElement.
  FrameworkProperty<num> width;
  /// Represents the height of the FrameworkElement.
  FrameworkProperty<num> height;
  /// Represents the maximum width property of the FrameworkElement.
  FrameworkProperty<num> maxWidth;
  /// Represents the minimum height property of the FrameworkElement.
  FrameworkProperty<num> minWidth;
  /// Represents the maximum height property of the FrameworkElement.
  FrameworkProperty<num> maxHeight;
  /// Represents the minimum height property of the FrameworkElement.
  FrameworkProperty<num> minHeight;
  /// Represents the shape the cursor will take when passing over the FrameworkElement.
  FrameworkProperty<Cursors> cursor;
  /// Represents a general use [Object] property of the FrameworkElement.
  FrameworkProperty<Object> tag;
  /// Represents the horizontal alignment of this FrameworkElement inside another element.
  FrameworkProperty<HorizontalAlignment> hAlign;
  /// Represents the [VerticalAlignment] of this FrameworkElement inside another element.
  FrameworkProperty<VerticalAlignment> vAlign;
  /// Represents the html z order of this FrameworkElement in relation to other elements.
  FrameworkProperty<int> zOrder;
  /// Represents the actual adjusted width of the FrameworkElement.
  FrameworkProperty<num> actualWidth;
  /// Represents the actual adjusted height of the FrameworkElement.
  FrameworkProperty<num> actualHeight;
  /// Represents the opacity value [Double] of the FrameworkElement.
  FrameworkProperty<num> opacity;
  /// Represents the [Visibility] property of the FrameworkElement.
  FrameworkProperty<Visibility> visibility;
  /// Represents the [StyleTemplate] value that is currently applied to the FrameworkElement.
  FrameworkProperty<StyleTemplate> style;
  /// Represents whether an element is draggable
  FrameworkProperty<bool> draggable;

  final FrameworkEvent<MeasurementChangedEventArgs> measurementChanged
    = new FrameworkEvent<MeasurementChangedEventArgs>();

  final FrameworkEvent<MeasurementChangedEventArgs> positionChanged
    = new FrameworkEvent<MeasurementChangedEventArgs>();

  SurfaceElement();
  SurfaceElement.register() : super.register();
  makeMe() => null;

  @override void initProperties(){
    super.initProperties();
  }

  @override void initEvents(){
    super.initEvents();

    registerEvent('measurementchanged', measurementChanged);
    registerEvent('positionchanged', positionChanged);
  }
}