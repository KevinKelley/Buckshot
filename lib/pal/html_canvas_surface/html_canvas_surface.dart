// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

library html_canvas_surface_buckshot;

import 'dart:html';
import 'package:buckshot/pal/surface/surface.dart';
export 'package:buckshot/pal/surface/surface.dart';

/**
 * Html5 Canvas box model presentation provider.
 */
class HtmlCanvasSurface extends Surface
{
  final Expando<Element> rawElement = new Expando<Element>();
  Element _rootDiv;
  final CanvasElement _c = new CanvasElement();

  HtmlCanvasSurface(){
    _rootDiv = query('#BuckshotHost');
    if (_rootDiv == null){
      throw "Unable to initialize the HtmlSurface provider. "
        "Div with ID 'BuckshotHost' not found in HTML page.";
    }
    _c.width = 500;
    _c.height = 500;

    _rootDiv.elements.add(_c);

  }

  String get namespace => 'http://surface.buckshotui.org/html';

  @override void setWidth(SurfaceElement element, num value){
    assert(rawElement[element] != null);
    throw const NotImplementedException();
  }

  @override void setHeight(SurfaceElement element, num value){
    assert(rawElement[element] != null);
    throw const NotImplementedException();
  }

  @override void setFill(SurfaceElement element, Brush brush){
    assert(rawElement[element] != null);

    throw const NotImplementedException();
  }


  @override void render(SurfaceElement rootElement){
    assert(rawElement[rootElement] != null);
    throw const NotImplementedException();

  }

  /** Initializes the given [element] to the [Presenter]. */
  @override void initElement(SurfaceElement element){
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
    throw const NotImplementedException();
  }

  @override void createPrimitive(SurfaceElement element,
                       SurfacePrimitive primitiveKind){

    if (rawElement[element] != null){
      throw 'Primitive already set.';
    }

    switch(primitiveKind){
      case SurfacePrimitive.box:
        throw const NotImplementedException();
      case SurfacePrimitive.text:
        throw const NotImplementedException();
      default:
        throw 'Invalid Surface Primitive';
    }
  }
}