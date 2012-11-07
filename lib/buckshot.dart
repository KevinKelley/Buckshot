// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
 *  ## Try Buckshot Online ##
 * <http://www.buckshotui.org/sandbox>
 */

library core_buckshotui_org;

import 'dart:json';
import 'dart:isolate';
import 'dart:math';

import 'package:xml/xml.dart';
import 'package:dartnet_event_model/events.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

export 'package:dartnet_event_model/events.dart';
export 'package:meta/meta.dart';

// Uncomment this to run with reflection.
// Also below, set reflectionEnabled = true.
// import 'dart:mirrors';

part 'src/core/presenter.dart';
part 'src/core/system.dart';
part 'src/core/framework_object.dart';
part 'src/core/framework_property.dart';
part 'src/core/observable_list.dart';
part 'src/core/framework_property_base.dart';
part 'src/core/attached_framework_property.dart';
part 'src/core/framework_container.dart';
part 'src/core/hashable_object.dart';
part 'src/core/theme.dart';
part 'src/core/debug.dart';
part 'src/core/_buckshot.dart';

part 'src/events/buckshot_event.dart';
part 'src/events/attached_property_changed_event_args.dart';
part 'src/events/property_changed_event_args.dart';
part 'src/events/drag_event_args.dart';

part 'src/mvvm/view_model_base.dart';
part 'src/mvvm/view.dart';
part 'src/mvvm/data_template.dart';

part 'src/binding/binding.dart';
part 'src/binding/binding_mode.dart';
part 'src/binding/binding_data.dart';

part 'src/elements/actions/action_base.dart';
part 'src/elements/actions/play_animation.dart';
part 'src/elements/actions/set_property.dart';
part 'src/elements/actions/toggle_property.dart';

part 'src/converters/string_to_numeric.dart';
part 'src/converters/string_to_thickness.dart';
part 'src/converters/string_to_boolean.dart';
part 'src/converters/string_to_horizontalalignment.dart';
part 'src/converters/string_to_orientation.dart';
part 'src/converters/string_to_verticalalignment.dart';
part 'src/converters/string_to_color.dart';
part 'src/converters/string_to_color_string.dart';
part 'src/converters/string_to_solidcolorbrush.dart';
part 'src/converters/string_to_radialgradientdrawmode.dart';
part 'src/converters/string_to_visibility.dart';
part 'src/converters/string_to_inputtypes.dart';
part 'src/converters/string_to_location.dart';

part 'src/enums/visibility.dart';
part 'src/enums/orientation.dart';
part 'src/enums/colors.dart';
part 'src/enums/cursors.dart';
part 'src/enums/linear_gradient_brush.dart';
part 'src/enums/radial_gradient_draw_mode.dart';
part 'src/enums/horizontal_alignment.dart';
part 'src/enums/vertical_alignment.dart';
part 'src/enums/transforms.dart';
part 'src/enums/transition_timing.dart';
part 'src/enums/dock_location.dart';

part 'src/resources/framework_resource.dart';
part 'src/resources/resource_collection.dart';
part 'src/resources/var.dart';
part 'src/resources/color.dart';
part 'src/resources/brush.dart';
part 'src/resources/solid_color_brush.dart';
part 'src/resources/linear_gradient_brush.dart';
part 'src/resources/radial_gradient_brush.dart';
part 'src/resources/setter.dart';
part 'src/resources/style_template.dart';
part 'src/resources/gradient_stop.dart';

//part 'src/animation/framework_animation.dart';
//part 'src/animation/animation_resource.dart';
//part 'src/animation/animation_key_frame.dart';
//part 'src/animation/animation_state.dart';
//part 'src/animation_css_compiler.dart';

part 'src/templates/presentation_format_provider.dart';
part 'src/templates/xml_template_provider.dart';
part 'src/templates/template.dart';
part 'src/templates/template_exception.dart';

part 'src/converters/value_converter.dart';
part 'src/primitives/thickness.dart';
part 'src/primitives/tuple.dart';

part 'src/events/buckshot_exception.dart';
part 'src/events/animation_exception.dart';
part 'src/events/framework_property_resolution_exception.dart';

//Use this to generate clean dart docs of just the buckshot library
main(){}

/**
 * Set this to true in order to use the mirror-based code.
 *
 * You must also uncomment the import directive for mirrors.
 */
bool reflectionEnabled = false;
