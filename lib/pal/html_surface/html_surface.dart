// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

library html_surface_buckshot;

import 'dart:html';
import 'package:buckshot/pal/surface/surface.dart';
export 'package:buckshot/buckshot.dart';
part 'box_impl.dart';

HtmlSurface get htmlPresenter => surfacePresenter as HtmlSurface;
set htmlPresenter(HtmlSurface p) {
  assert(presenter == null);

  presenter = p;
}

/**
 * Html box model presentation provider.
 */
class HtmlSurface extends Surface
{
  final Expando<SurfacePrimitive> primitive = new Expando<SurfacePrimitive>();

  final Expando<SurfaceElement> surfaceElement = new Expando<SurfaceElement>();

  Element _rootDiv;

  HtmlSurface(){
    _rootDiv = query('#BuckshotHost');
    if (_rootDiv == null){
      throw "Unable to initialize the HtmlSurface provider. "
        "Div with ID 'BuckshotHost' not found in HTML page.";
    }

    _setMutationObserver(_rootDiv);
  }

  String get namespace => 'http://surface.buckshotui.org/html';

  @override void render(SurfaceElement rootElement){
    assert(primitive[rootElement] != null);

    _rootDiv.elements.clear();

    _rootDiv.elements.add(primitive[rootElement].rawElement);
  }

  /** Initializes the given [element] to the [Presenter]. */
  @override void initElement(PresenterElement element){
    super.initElement(element);
  }


  /**
   * Returns a [Future] containing the bounding position and dimensions of the
   * given [element].
   *
   * This measurement occurs within the browser layout interrupt to prevent
   * contention with animations.
   */
  @override Future<RectMeasurement> measure(SurfaceElement element){
    assert(primitive[element] != null);

    final c = new Completer();

    window.requestLayoutFrame((){
      final bounding = primitive[element].rawElement.getBoundingClientRect();
      c.complete(
          new RectMeasurement(
              bounding.left, bounding.top, bounding.width, bounding.height));
    });

    return c.future;
  }

  @override createPrimitive(SurfaceElement element,
                       SurfacePrimitive primitiveKind){

    assert(primitive[element] == null);

    SurfacePrimitive p;

    if (primitiveKind is Box){
      p = new BoxImpl();
      primitive[element] = p;
    }else{
        throw 'Invalid Surface Primitive';
    }

//    switch(primitiveKind){
//      case SurfacePrimitive.box:
//        rawElement[element] =
//          new DivElement()
//            ..style.background = 'Orange';
//        break;
//      case SurfacePrimitive.text:
//        rawElement[element] =
//          new ParagraphElement();
//        break;
//      default:
//        throw 'Invalid Surface Primitive';
//    }

    surfaceElement[p.rawElement] = element;
    return p;
  }

  void _setMutationObserver(Element element){
    new MutationObserver(_mutationHandler)
      .observe(element, subtree: true, childList: true, attributes: false);
  }

  void _mutationHandler(List<MutationRecord> mutations,
                        MutationObserver observer){
    print('mutations: $mutations');

    for (final MutationRecord r in mutations){
      r.addedNodes.forEach((node){
        if (surfaceElement[node] == null) return;
        print('added element ${surfaceElement[node]}');
        surfaceElement[node].onLoaded();
      });

      r.removedNodes.forEach((node){
        if (surfaceElement[node] == null) return;
        print('removed element ${surfaceElement[node]}');
        surfaceElement[node].onUnloaded();
      });
    }
  }
}