library surface_buckshot;
import 'package:buckshot/buckshot.dart';
export 'package:buckshot/buckshot.dart';
part 'measurement_changed_event_args.dart';
part 'surface_element.dart';
part 'primitives/surface_primitive.dart';
part 'primitives/box.dart';
part 'primitives/scroller.dart';
part 'primitives/scroll_setting.dart';
part 'primitives/stackpanel.dart';
part 'primitives/text_primitive.dart';
part 'primitives/border_style.dart';
part 'primitives/string_to_border_style.dart';
part 'primitives/image_primitive.dart';
part 'primitives/content_presenter_primitive.dart';
part 'primitives/collection_primitive.dart';

Surface surfacePresenter = presenter as Surface;

/**
 * This class provides a presentation abstraction for a 2d layout surface.
 */
abstract class Surface extends Presenter
{
  abstract Future<RectMeasurement> measure(SurfaceElement element);

  abstract createPrimitive(SurfaceElement element,
                                SurfacePrimitive primitiveKind);

  /** Initializes the given [element] to the [Presenter]. */
  void initElement(PresenterElement element){
  }

  /** Renders to the surface beginning from the given [rootElement]. */
  abstract void render(SurfaceElement rootElement);
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