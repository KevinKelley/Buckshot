library surface_buckshot;
import 'package:buckshot/buckshot.dart';
export 'package:buckshot/buckshot.dart';
part 'measurement_changed_event_args.dart';
part 'surface_element.dart';


Surface surfacePresenter = presenter as Surface;

/**
 * This class provides a presentation abstraction for a 2d layout surface.
 */
abstract class Surface extends Presenter
{
  Future<RectMeasurement> measure(SurfaceElement element);

  /** Initializes the given [element] to the [Presenter]. */
  void initElement(PresenterElement element){}

  /** Renders to the surface beginning from the given [rootElement]. */
  void render(SurfaceElement rootElement);
}

/**
 * A standard rectangle measurement class for surface boxes.
 */
class RectMeasurement
{
  final num left;
  final num top;
  final num width;
  final num height;

  RectMeasurement(this.left, this.top, this.width, this.height);
}