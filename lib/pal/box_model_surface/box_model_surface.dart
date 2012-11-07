library box_model_surface_buckshot;

import 'package:buckshot/pal/surface/surface.dart';
export 'package:buckshot/pal/surface/surface.dart';

part 'src/box_model_surface_element.dart';
part 'src/elements/scroll_setting.dart';
part 'src/elements/border_style.dart';
part 'src/elements/string_to_border_style.dart';
part 'src/elements/surface_border.dart';
part 'src/elements/surface_text.dart';
part 'src/elements/surface_stack.dart';
part 'src/elements/surface_scroll_viewer.dart';
part 'src/elements/surface_image.dart';
part 'src/elements/surface_content_presenter.dart';
part 'src/elements/surface_collection_presenter.dart';

abstract class BoxModelSurface extends Surface {}