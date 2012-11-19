library surface_buckshot;
import 'package:buckshot/buckshot.dart';
export 'package:buckshot/buckshot.dart';
part 'src/measurement_changed_event_args.dart';
part 'src/surface_element.dart';
part 'src/surface_point.dart';
part 'src/rect_measurement.dart';
part 'src/hit_test_visibility.dart';
part 'src/string_to_hittestvisibility.dart';

SurfacePlatform surfacePlatform = platform as SurfacePlatform;

/**
 * This class provides a presentation abstraction for a 2d layout surface.
 */
abstract class SurfacePlatform extends Platform
{
  Future<RectMeasurement> measure(SurfaceElement element);
}