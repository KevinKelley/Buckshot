part of box_model_surface_buckshot;

abstract class BoxModelSurfaceElement extends SurfaceElement
{
  /// Represents the margin [Thickness] area outside the FrameworkElement boundary.
  FrameworkProperty<Thickness> margin = null;
  /// Represents the maximum width property of the FrameworkElement.
  FrameworkProperty<num> maxWidth = null;
  /// Represents the minimum height property of the FrameworkElement.
  FrameworkProperty<num> minWidth = null;
  /// Represents the maximum height property of the FrameworkElement.
  FrameworkProperty<num> maxHeight = null;
  /// Represents the minimum height property of the FrameworkElement.
  FrameworkProperty<num> minHeight = null;
  /// Represents the horizontal alignment of this FrameworkElement inside another element.
  FrameworkProperty<HorizontalAlignment> hAlign = null;
  /// Represents the [VerticalAlignment] of this FrameworkElement inside another element.
  FrameworkProperty<VerticalAlignment> vAlign = null;

  BoxModelSurfaceElement();
  BoxModelSurfaceElement.register() : super.register();
  @override makeMe() => null;

  void onMarginChanged(Thickness margin);
  void onMaxWidthChanged(num value);
  void onMaxHeightChanged(num value);
  void onMinWidthChanged(num value);
  void onMinHeightChanged(num value);
  void onHAlignChanged(HorizontalAlignment value);
  void onVAlignChanged(VerticalAlignment value);

  @override void initProperties(){
    super.initProperties();

    vAlign = new FrameworkProperty(this, 'vAlign',
        propertyChangedCallback: onVAlignChanged,
        converter: const StringToVerticalAlignmentConverter(),
        defaultValue: VerticalAlignment.top);

    hAlign = new FrameworkProperty(this, 'hAlign',
        propertyChangedCallback: onHAlignChanged,
        converter: const StringToHorizontalAlignmentConverter(),
        defaultValue: HorizontalAlignment.left);

    margin = new FrameworkProperty(this, 'margin',
        propertyChangedCallback: onMarginChanged,
        converter: const StringToThicknessConverter());

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
}
