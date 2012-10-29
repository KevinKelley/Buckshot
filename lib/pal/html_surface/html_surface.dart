// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

library html_surface_buckshot;

import 'dart:html';
import 'package:buckshot/pal/surface/surface.dart';
export 'package:buckshot/pal/surface/surface.dart';

/**
 * Html box model presentation provider.
 */
class HtmlSurface extends Surface
{
  final Expando<Element> rawElement = new Expando<Element>();
  Element _rootDiv;

  HtmlSurface(){
    _rootDiv = query('#BuckshotHost');
    if (_rootDiv == null){
      throw "Unable to initialize the HtmlSurface provider. "
        "Div with ID 'BuckshotHost' not found in HTML page.";
    }
  }

  String get namespace => 'http://surface.buckshotui.org/html';

  @override void setWidth(SurfaceElement element, num value){
    assert(rawElement[element] != null);
    rawElement[element].style.width = '${value}px';
  }

  @override void setHeight(SurfaceElement element, num value){
    assert(rawElement[element] != null);
    rawElement[element].style.height = '${value}px';
  }

  @override void setFill(SurfaceElement element, Brush brush){
    assert(rawElement[element] != null);
    final re = rawElement[element];

    if (brush is SolidColorBrush){
      re.style.background =
          '${brush.color.value.toColorString()}';
    }else if (brush is LinearGradientBrush){
      re.style.background =
          brush.fallbackColor.value.toColorString();

      final colorString = new StringBuffer();

      //create the string of stop colors
      brush.stops.value.forEach((GradientStop stop){
        colorString.add(stop.color.value.toColorString());

        if (stop.percent.value != -1) {
          colorString.add(" ${stop.percent.value}%");
        }

        if (stop != brush.stops.value.last) {
          colorString.add(", ");
        }
      });

      //set the background for all browser types
      re.style.background = "-webkit-linear-gradient(${brush.direction.value}, ${colorString})";
      re.style.background = "-moz-linear-gradient(${brush.direction.value}, ${colorString})";
      re.style.background = "-ms-linear-gradient(${brush.direction.value}, ${colorString})";
      re.style.background = "-o-linear-gradient(${brush.direction.value}, ${colorString})";
      re.style.background = "linear-gradient(${brush.direction.value}, ${colorString})";
    }else if (brush is RadialGradientBrush){
      //set the fallback
      re.style.background = brush.fallbackColor.value.toColorString();

      final colorString = new StringBuffer();

      //create the string of stop colors
      brush.stops.value.forEach((GradientStop stop){
        colorString.add(stop.color.value.toColorString());

        if (stop.percent.value != -1) {
          colorString.add(" ${stop.percent.value}%");
        }

        if (stop != brush.stops.value.last) {
          colorString.add(", ");
        }
      });

      //set the background for all browser types
      re.style.background = "-webkit-radial-gradient(50% 50%, ${brush.drawMode.value}, ${colorString})";
      re.style.background = "-moz-radial-gradient(50% 50%, ${brush.drawMode.value}, ${colorString})";
      re.style.background = "-ms-radial-gradient(50% 50%, ${brush.drawMode.value}, ${colorString})";
      re.style.background = "-o-radial-gradient(50% 50%, ${brush.drawMode.value}, ${colorString})";
      re.style.background = "radial-gradient(50% 50%, ${brush.drawMode.value}, ${colorString})";
    }else{
      log('Unrecognized brush "$brush" assignment. Defaulting to solid white.');
      re.style.background =
          new SolidColorBrush.fromPredefined(Colors.White);
    }

  }


  @override void render(SurfaceElement rootElement){
    assert(rawElement[rootElement] != null);

    _rootDiv.elements.clear();

    _rootDiv.elements.add(rawElement[rootElement]);

  }

  /** Initializes the given [element] to the [Presenter]. */
  @override void initElement(PresenterElement element){
    //TODO may not need this.
  }

  /**
   * Returns a [Future] containing the bounding position and dimensions of the
   * given [element].
   *
   * This measurement occurs within the browser layout interrupt to prevent
   * contention with animations.
   */
  @override Future<RectMeasurement> measure(SurfaceElement element){
    assert(rawElement[element] != null);

    final c = new Completer();

    window.requestLayoutFrame((){
      final bounding = rawElement[element].getBoundingClientRect();
      c.complete(
          new RectMeasurement(
              bounding.left, bounding.top, bounding.width, bounding.height));
    });

    return c.future;
  }

  @override void createPrimitive(SurfaceElement element,
                       SurfacePrimitive primitiveKind){

    if (rawElement[element] != null){
      throw 'Primitive already set.';
    }

    switch(primitiveKind){
      case SurfacePrimitive.box:
        final box = new DivElement()
          ..style.background = 'Orange';
        rawElement[element] = box;

        break;
      case SurfacePrimitive.text:
        rawElement[element] = new ParagraphElement();
        break;
      default:
        throw 'Invalid Surface Primitive';
    }
  }
}



// may need this to offer html-specific primitives
class HtmlPrimitive extends SurfacePrimitive
{
  const HtmlPrimitive(String str) : super(str);
}
