part of surface_buckshot;

abstract class SurfaceElement extends FrameworkObject
{
  RectMeasurement previousMeasurement;
  RectMeasurement previousPosition;
  RectMeasurement mostRecentMeasurement;

  FrameworkProperty<bool> userSelect;
  /// Represents the width of the FrameworkElement.
  FrameworkProperty<num> width;
  /// Represents the height of the FrameworkElement.
  FrameworkProperty<num> height;
  /// Represents the shape the cursor will take when passing over the FrameworkElement.
  FrameworkProperty<Cursors> cursor;
  /// Represents the html z order of this FrameworkElement in relation to other elements.
  FrameworkProperty<int> zOrder;
  /// Represents the actual adjusted width of the FrameworkElement.
  FrameworkProperty<num> opacity;
  /// Represents the [Visibility] property of the FrameworkElement.
  FrameworkProperty<Visibility> visibility;
  /// Represents whether an element is draggable
  FrameworkProperty<bool> draggable;

  final FrameworkEvent<MeasurementChangedEventArgs> measurementChanged
    = new FrameworkEvent<MeasurementChangedEventArgs>();

  final FrameworkEvent<MeasurementChangedEventArgs> positionChanged
    = new FrameworkEvent<MeasurementChangedEventArgs>();

  SurfaceElement();
  SurfaceElement.register() : super.register();
  @override makeMe() => null;

  void onUserSelectChanged(bool value);
  void onWidthChanged(num value);
  void onHeightChanged(num value);
  void onCursorChanged(Cursors value);
  void onZOrderChanged(num value);
  void onOpacityChanged(num value);
  void onVisibilityChanged(Visibility value);
  void onDraggableChanged(bool draggable);

  @override void initProperties(){
    super.initProperties();

    draggable = new FrameworkProperty(this, 'draggable',
        propertyChangedCallback: onDraggableChanged,
        converter: const StringToBooleanConverter());

    visibility = new FrameworkProperty(this, 'visibility',
        propertyChangedCallback: onVisibilityChanged,
        converter: const StringToVisibilityConverter());

    opacity = new FrameworkProperty(this, 'opacity',
        propertyChangedCallback: onOpacityChanged,
        converter: const StringToNumericConverter());

    zOrder = new FrameworkProperty(this, 'zOrder',
        propertyChangedCallback: onZOrderChanged,
        converter: const StringToNumericConverter());

    cursor = new FrameworkProperty(this, 'cursor',
        propertyChangedCallback: onCursorChanged,
        converter: const StringToCursorConverter());

    userSelect = new FrameworkProperty(this, 'userSelect',
        propertyChangedCallback: onUserSelectChanged,
        converter: const StringToBooleanConverter());

    width = new FrameworkProperty(this, 'width',
        propertyChangedCallback: onWidthChanged,
        converter: const StringToNumericConverter());

    height = new FrameworkProperty(this, 'height',
        propertyChangedCallback: onHeightChanged,
        converter: const StringToNumericConverter());
  }

  @override void initEvents(){
    registerEvent('measurementchanged', measurementChanged);
    registerEvent('positionchanged', positionChanged);
  }
}