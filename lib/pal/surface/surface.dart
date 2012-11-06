library surface_buckshot;
import 'package:buckshot/buckshot.dart';
export 'package:buckshot/buckshot.dart';
part 'measurement_changed_event_args.dart';
part 'surface_element.dart';
part 'elements/scroll_setting.dart';
part 'elements/border_style.dart';
part 'elements/string_to_border_style.dart';
part 'elements/surface_border.dart';
part 'elements/surface_text.dart';
part 'elements/surface_stack.dart';
part 'elements/surface_scroll_viewer.dart';
part 'elements/surface_image.dart';
part 'elements/surface_content_presenter.dart';
part 'elements/surface_collection_presenter.dart';

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