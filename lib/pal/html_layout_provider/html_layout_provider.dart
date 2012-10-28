// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

library html_layout_provider;

import 'dart:html';
import 'package:buckshot/pal/surface_layout/surface_layout_provider.dart';
export 'package:buckshot/pal/surface_layout/surface_layout_provider.dart';

/**
 * Html box model presentation provider.
 */
class HtmlLayoutProvider extends SurfaceLayout
{
  final Expando<Element> rawElement = new Expando<Element>();

  String get namespace => 'html.provider.buckshotui.org';

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
        rawElement[element] = new DivElement();
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
