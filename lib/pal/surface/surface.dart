library surface_buckshot;
import 'package:buckshot/buckshot.dart';
export 'package:buckshot/buckshot.dart';
part 'measurement_changed_event_args.dart';
part 'surface_element.dart';


Surface surfacePresenter = presenter as Surface;

/**
 * This class provides a presentation model for a 2d layout surface.
 * In other words, DOM, SVG, Canvas, etc.
 *
 * Presenters using this interface are expected to provide a box-model
 * layout implementation.
 */
abstract class Surface extends Presenter
{
  abstract Future<RectMeasurement> measure(SurfaceElement element);

  abstract void createPrimitive(SurfaceElement element,
                                SurfacePrimitive primitiveKind);

  /** Initializes the given [element] to the [Presenter]. */
  abstract void initElement(PresenterElement element);

  /** Renders to the surface beginning from the given [rootElement]. */
  abstract void render(SurfaceElement rootElement);

  abstract void setWidth(SurfaceElement element, num value);
  abstract void setHeight(SurfaceElement element, num value);
  abstract void setFill(SurfaceElement element, Brush value);
}

/**
 * Enumerates supported surface primitives.
 */
class SurfacePrimitive
{
  final String _str;

  const SurfacePrimitive(this._str);

  static const box = const SurfacePrimitive('box');
  static const text = const SurfacePrimitive('text');

  String toString() => _str;
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