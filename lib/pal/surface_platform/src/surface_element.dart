part of surface_buckshot;

abstract class SurfaceElement extends FrameworkObject
{
  FrameworkProperty<HitTestVisibility> hitTest;
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

  FrameworkEvent<MeasurementChangedEventArgs> measurementChanged;
  FrameworkEvent<MeasurementChangedEventArgs> positionChanged;
  /// Fires when the DOM gives the FrameworkElement focus.
  FrameworkEvent<EventArgs> gotFocus;
  /// Fires when the DOM removes focus from the FrameworkElement.
  FrameworkEvent<EventArgs> lostFocus;
  /// Fires when the mouse enters the boundary of the FrameworkElement.
  FrameworkEvent<EventArgs> mouseEnter;
  /// Fires when the mouse leaves the boundary of the FrameworkElement.
  FrameworkEvent<EventArgs> mouseLeave;
  /// Fires when a mouse click occurs on the FrameworkElement.
  FrameworkEvent<MouseEventArgs> click;
  /// Fires when the mouse position changes over the FrameworkElement.
  FrameworkEvent<MouseEventArgs> mouseMove;
  /// Fires when the mouse button changes to a down position while over the FrameworkElement.
  FrameworkEvent<MouseEventArgs> mouseDown;
  /// Fires when the mouse button changes to an up position while over the FrameworkElement.
  FrameworkEvent<MouseEventArgs> mouseUp;

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
  void onHitTestVisibilityChanged(HitTestVisibility value);

  @override void initProperties(){
    super.initProperties();

    hitTest = new FrameworkProperty(this, 'hitTest',
        propertyChangedCallback: onHitTestVisibilityChanged,
        converter: const StringToHitTestVisibilityConverter());

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
    super.initEvents();
    registerEvent('measurementchanged', measurementChanged);
    registerEvent('positionchanged', positionChanged);
    registerEvent('gotfocus', gotFocus);
    registerEvent('lostfocus', lostFocus);
    registerEvent('click', click);
    registerEvent('mouseleave', mouseLeave);
    registerEvent('mouseenter', mouseEnter);
    registerEvent('mousedown', mouseDown);
    registerEvent('mouseup', mouseUp);
    registerEvent('mousemove', mouseMove);
  }
}