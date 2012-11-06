part of surface_buckshot;

abstract class SurfaceElement extends FrameworkObject
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
  /// Represents the horizontal alignment of this FrameworkElement inside another element.
  FrameworkProperty<HorizontalAlignment> hAlign;
  /// Represents the [VerticalAlignment] of this FrameworkElement inside another element.
  FrameworkProperty<VerticalAlignment> vAlign;
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
  makeMe() => null;

  void onUserSelectChanged(bool value);
  void onMarginChanged(Thickness margin);
  void onWidthChanged(num value);
  void onHeightChanged(num value);
  void onMaxWidthChanged(num value);
  void onMaxHeightChanged(num value);
  void onMinWidthChanged(num value);
  void onMinHeightChanged(num value);
  void onCursorChanged(Cursors value);
  void onHAlignChanged(HorizontalAlignment value);
  void onVAlignChanged(VerticalAlignment value);
  void onZOrderChanged(num value);
  void onOpacityChanged(num value);
  void onVisibilityChanged(num value);
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

    vAlign = new FrameworkProperty(this, 'vAlign',
        propertyChangedCallback: onVAlignChanged,
        converter: const StringToVerticalAlignmentConverter(),
        defaultValue: VerticalAlignment.top);

    hAlign = new FrameworkProperty(this, 'hAlign',
        propertyChangedCallback: onHAlignChanged,
        converter: const StringToHorizontalAlignmentConverter(),
        defaultValue: HorizontalAlignment.left);

    cursor = new FrameworkProperty(this, 'cursor',
        propertyChangedCallback: onCursorChanged,
        converter: const StringToCursorConverter());

    userSelect = new FrameworkProperty(this, 'userSelect',
        propertyChangedCallback: onUserSelectChanged,
        converter: const StringToBooleanConverter());

    margin = new FrameworkProperty(this, 'margin',
        propertyChangedCallback: onMarginChanged,
        converter: const StringToThicknessConverter());

    width = new FrameworkProperty(this, 'width',
        propertyChangedCallback: onWidthChanged,
        converter: const StringToNumericConverter());

    height = new FrameworkProperty(this, 'height',
        propertyChangedCallback: onHeightChanged,
        converter: const StringToNumericConverter());

    minWidth = new FrameworkProperty(this, 'minWidth',
        propertyChangedCallback: onMinWidthChanged,
        converter: const StringToNumericConverter());

    maxWidth = new FrameworkProperty(this, 'maxWidth',
        propertyChangedCallback: onMaxWidthChanged,
        converter: const StringToNumericConverter());

    minHeight = new FrameworkProperty(this, 'minHeight',
        propertyChangedCallback: onMinHeightChanged,
        converter: const StringToNumericConverter());

    maxHeight = new FrameworkProperty(this, 'maxHeight',
        propertyChangedCallback: onMaxHeightChanged,
        converter: const StringToNumericConverter());
  }

  @override void initEvents(){
    registerEvent('measurementchanged', measurementChanged);
    registerEvent('positionchanged', positionChanged);
  }
}