library svg_surface_buckshot;

import 'dart:html';
import 'package:buckshot/pal/surface/surface.dart';
export 'package:buckshot/pal/surface/surface.dart';

part 'svg_surface_element.dart';


/**
 * Initializes the Buckshot framework to use the [HtmlSurface] presenter.
 *
 * IMPORTANT:  This should be called first before making any other calls
 * to the Buckshot API.
 */
void initPresenter(){
  svgPresenter = new SvgSurface();
}

SvgSurface get svgPresenter => surfacePresenter as SvgSurface;
set svgPresenter(SvgSurface p) {
  assert(presenter == null);
  presenter = p;
}

class SvgSurface extends Surface
{
  final Expando<SvgSurfaceElement> surfaceElement =
      new Expando<SvgSurfaceElement>();

  SVGSVGElement _rootDiv;

  SvgSurface(){
    _rootDiv = query('#BuckshotSVGHost');

    if (_rootDiv == null){
      throw "Unable to initialize the HtmlSurface provider. "
        "SVGElement with ID 'BuckshotHost' not found in HTML page.";
    }

    _rootDiv.attributes['width'] = '500';
    _rootDiv.attributes['height'] = '500';
  }

  @override void render(SurfaceElement rootElement){
    assert(rootElement is SvgSurfaceElement);

    _rootDiv.elements.add(rootElement.rawElement);
  }

}
