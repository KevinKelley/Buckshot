library surface_layout_buckshot;
import 'package:buckshot/buckshot.dart';
export 'package:buckshot/buckshot.dart';
part 'measurement_changed_event_args.dart';
part 'surface_element.dart';

/**
 * This class provides a presentation model for a 2d box-model layout surface.
 * In other words, DOM, SVG, etc.
 */
abstract class SurfaceLayout extends PresentationProvider
{
  abstract Future<RectMeasurement> measure(SurfaceElement element);

  abstract void createPrimitive(SurfaceElement element,
                                SurfacePrimitive primitiveKind);

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