library surface_buckshot;
import 'package:buckshot/buckshot.dart';
export 'package:buckshot/buckshot.dart';
part 'src/measurement_changed_event_args.dart';
part 'src/surface_element.dart';
part 'src/surface_point.dart';
part 'src/rect_measurement.dart';


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