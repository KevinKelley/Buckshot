// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

library html_surface_buckshot;

import 'dart:html';
import 'package:buckshot/pal/surface/surface.dart';
export 'package:buckshot/buckshot.dart';
part 'primitives/html_primitive.dart';
part 'primitives/box_impl.dart';
part 'primitives/scroller_impl.dart';
part 'primitives/stackpanel_impl.dart';
part 'primitives/text_impl.dart';
part 'primitives/image_impl.dart';

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
  final Expando<HtmlPrimitive> primitive = new Expando<HtmlPrimitive>();
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

  void clearSurface(){
    _rootDiv.elements.clear();
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

    HtmlPrimitive p;

    if (primitiveKind is Box){
      p = new BoxImpl();
    } else if (primitiveKind is Scroller){
      p = new ScrollerImpl();
    } else if (primitiveKind is StackPanel){
      p = new StackPanelImpl();
    } else if (primitiveKind is TextPrimitive){
      p = new TextImpl();
    } else if (primitiveKind is ImagePrimitive){
      p = new ImageImpl();
    }else{
        throw 'Invalid Surface Primitive';
    }

    primitive[element] = p;

    surfaceElement[p.rawElement] = element;
    return p;
  }

  void _setMutationObserver(Element element){
    new MutationObserver(_mutationHandler)
      .observe(element, subtree: true, childList: true, attributes: false);
  }

  // Provides a reliable loaded/unloaded notification for all elements in
  // the visual tree.
  void _mutationHandler(List<MutationRecord> mutations,
                        MutationObserver observer){
    for (final MutationRecord r in mutations){
      r.addedNodes.forEach((node){
        if (surfaceElement[node] == null) return;
        final el = surfaceElement[node];
        el.onLoaded();

        if (el is FrameworkContainer){
          _loadChildren(el);
        }

      });

      r.removedNodes.forEach((node){
        if (surfaceElement[node] == null) return;
        final el = surfaceElement[node];
        el.onUnloaded();

        if (el is FrameworkContainer){
          _unloadChildren(el);
        }
      });
    }
  }

  void _unloadChildren(FrameworkContainer container){
    if (container.containerContent == null) return;

    if (container.containerContent is Collection){
      container.containerContent.forEach((content){
        assert(content is SurfaceElement);
        content.onUnloaded();

        if (content is FrameworkContainer){
          _unloadChildren(content);
        }

      });
    }else if (container.containerContent is SurfaceElement){
      container.containerContent.onUnloaded();
      if (container.containerContent is FrameworkContainer){
        _unloadChildren(container.containerContent);
      }
    }else{
      throw "Invalid container type found.";
    }
  }

  void _loadChildren(FrameworkContainer container){
    if (container.containerContent == null) return;

    if (container.containerContent is Collection){
      container.containerContent.forEach((content){
        assert(content is SurfaceElement);
        content.onLoaded();

        if (content is FrameworkContainer){
          _loadChildren(content);
        }

      });
    }else if (container.containerContent is SurfaceElement){
      container.containerContent.onLoaded();
      if (container.containerContent is FrameworkContainer){
        _loadChildren(container.containerContent);
      }
    }else{
      log('Invalid container type found.');
    }
  }
}