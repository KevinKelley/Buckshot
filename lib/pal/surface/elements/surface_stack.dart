part of surface_buckshot;

abstract class SurfaceStack extends SurfaceElement implements FrameworkContainer
{
  FrameworkProperty<Orientation> orientation;
  FrameworkProperty<Brush> background;

  final ObservableList<SurfaceElement> children =
      new ObservableList<SurfaceElement>();

  SurfaceStack.register() : super.register();
  SurfaceStack(){
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = children;
  }

  get containerContent => children;

  abstract void onOrientationChanged(Orientation value);
  abstract void onBackgroundChanged(Brush brush);

  @override void initProperties(){
    super.initProperties();

    orientation = new FrameworkProperty(this, 'orientation',
        propertyChangedCallback: onOrientationChanged,
        converter: const StringToOrientationConverter(),
        defaultValue: Orientation.vertical);

    background = new FrameworkProperty(this, 'background',
        propertyChangedCallback: onBackgroundChanged,
        converter: const StringToSolidColorBrushConverter());
  }
}
