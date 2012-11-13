library svg_surface_buckshot;

import 'dart:html';
import 'package:buckshot/pal/surface_platform/surface_platform.dart';
export 'package:buckshot/pal/surface_platform/surface_platform.dart';

part 'svg_surface_element.dart';


/**
 * Initializes the Buckshot framework to use the [HtmlSurface] presenter.
 *
 * IMPORTANT:  This should be called first before making any other calls
 * to the Buckshot API.
 */
void initPlatform(){
  svgPresenter = new SvgSurface();
}

SvgSurface get svgPresenter => surfacePlatform as SvgSurface;
set svgPresenter(SvgSurface p) {
  assert(platform == null);
  platform = p;
}

class SvgSurface extends SurfacePlatform
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

  @override Future<PlatformElement> render(View view){
    return
       initFramework()
       .chain((_) => view.ready)
       .chain((rootVisual){
          throw new NotImplementedException();
          return new Future.immediate(rootVisual);
      });
  }

}
