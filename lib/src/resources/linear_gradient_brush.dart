part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents a gradient blend between two [Color]s.
*
* ## See Also
* * [RadialGradientBrush]
* * [SolidColorBrush]
*/
class LinearGradientBrush extends Brush
{
  /// Represents the [List<GradientStop>] collection of stops.
  FrameworkProperty<List<GradientStop>> stops;
  /// Represents the [LinearGradientDirection] of the LinearGradientBrush.
  FrameworkProperty<LinearGradientDirection> direction;
  /// Represents the fall back [Color] to use if gradients aren't supported.
  FrameworkProperty<Color> fallbackColor;

  LinearGradientBrush({LinearGradientDirection dir, Color fallback})
  {
    _initLinearGradientBrushProperties();

    if (dir != null) direction.value = dir;//LinearGradientDirection.horizontal;
    if (fallback != null) fallbackColor.value = fallback;// = new Color.predefined(Colors.White);

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = stops;
  }

  LinearGradientBrush.register() : super.register();
  makeMe() => new LinearGradientBrush();

  void _initLinearGradientBrushProperties(){
    stops = new FrameworkProperty(this, "stops",
        defaultValue:new List<GradientStop>());

    direction = new FrameworkProperty(this, "direction",
        defaultValue:LinearGradientDirection.horizontal,
        converter:const StringToLinearGradientDirectionConverter());

    fallbackColor = new FrameworkProperty(this, "fallbackColor",
        defaultValue:new Color.predefined(Colors.White),
        converter:const StringToColorConverter());
  }
}
