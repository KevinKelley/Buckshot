// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

library html_surface_buckshot;

import 'dart:html';
import 'package:xml/xml.dart';
import 'package:buckshot/pal/box_model_surface/box_model_surface.dart';
import 'package:buckshot/web/web.dart';
export 'package:buckshot/pal/box_model_surface/box_model_surface.dart';

//html included controls
import 'package:buckshot/extensions/presenters/html/controls/border.dart';
import 'package:buckshot/extensions/presenters/html/controls/text_block.dart';
import 'package:buckshot/extensions/presenters/html/controls/stack.dart';
import 'package:buckshot/extensions/presenters/html/controls/scroll_viewer.dart';
import 'package:buckshot/extensions/presenters/html/controls/image.dart';
import 'package:buckshot/extensions/presenters/html/controls/content_presenter.dart';
import 'package:buckshot/extensions/presenters/html/controls/collection_presenter.dart';
import 'package:buckshot/extensions/presenters/html/controls/slider.dart';
import 'package:buckshot/extensions/presenters/html/controls/button.dart';
import 'package:buckshot/extensions/presenters/html/controls/control.dart';
import 'package:buckshot/extensions/presenters/html/controls/check_box.dart';
import 'package:buckshot/extensions/presenters/html/controls/radio_button.dart';
import 'package:buckshot/extensions/presenters/html/controls/text_box.dart';
import 'package:buckshot/extensions/presenters/html/controls/text_area.dart';
import 'package:buckshot/extensions/presenters/html/controls/hyperlink.dart';
import 'package:buckshot/extensions/presenters/html/controls/drop_down_list.dart';
import 'package:buckshot/extensions/presenters/html/controls/grid/grid.dart';

export 'package:buckshot/extensions/presenters/html/controls/border.dart';
export 'package:buckshot/extensions/presenters/html/controls/text_block.dart';
export 'package:buckshot/extensions/presenters/html/controls/stack.dart';
export 'package:buckshot/extensions/presenters/html/controls/scroll_viewer.dart';
export 'package:buckshot/extensions/presenters/html/controls/image.dart';
export 'package:buckshot/extensions/presenters/html/controls/content_presenter.dart';
export 'package:buckshot/extensions/presenters/html/controls/collection_presenter.dart';
export 'package:buckshot/extensions/presenters/html/controls/control.dart';
export 'package:buckshot/extensions/presenters/html/controls/slider.dart';
export 'package:buckshot/extensions/presenters/html/controls/button.dart';
export 'package:buckshot/extensions/presenters/html/controls/check_box.dart';
export 'package:buckshot/extensions/presenters/html/controls/radio_button.dart';
export 'package:buckshot/extensions/presenters/html/controls/text_box.dart';
export 'package:buckshot/extensions/presenters/html/controls/text_area.dart';
export 'package:buckshot/extensions/presenters/html/controls/hyperlink.dart';
export 'package:buckshot/extensions/presenters/html/controls/drop_down_list.dart';
export 'package:buckshot/extensions/presenters/html/controls/grid/grid.dart';

part 'src/html_surface_element.dart';

/**
 * Initializes the Buckshot framework to use the [HtmlSurface] presenter.
 *
 * IMPORTANT:  This should be called first before making any other calls
 * to the Buckshot API.
 */
void initPresenter(){
  htmlPresenter = new HtmlSurface();
  registerElement(new Border.register());
  registerElement(new TextBlock.register());
  registerElement(new Stack.register());
  registerElement(new ScrollViewer.register());
  registerElement(new Image.register());
  registerElement(new ContentPresenter.register());
  registerElement(new CollectionPresenter.register());
  registerElement(new ControlTemplate.register());
  registerElement(new Slider.register());
  registerElement(new Button.register());
  registerElement(new RadioButton.register());
  registerElement(new CheckBox.register());
  registerElement(new TextBox.register());
  registerElement(new TextArea.register());
  registerElement(new Hyperlink.register());
  registerElement(new DropDownList.register());
  registerElement(new Grid.register());
  registerElement(new ColumnDefinition.register());
  registerElement(new RowDefinition.register());
}

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
  final Expando<HtmlSurfaceElement> surfaceElement =
      new Expando<HtmlSurfaceElement>();
  Element _rootDiv;

  HtmlSurface(){
    _rootDiv = query('#BuckshotHost');
    if (_rootDiv == null){
      throw "Unable to initialize the HtmlSurface provider. "
        "Div with ID 'BuckshotHost' not found in HTML page.";
    }

    _setMutationObserver(_rootDiv);
    _startEventLoop();
  }

  String get namespace => 'http://surface.buckshotui.org/html';

  @override void render(SurfaceElement rootElement){
    assert(rootElement is HtmlSurfaceElement);
    _rootDiv.elements.clear();

    _rootDiv.elements.add(rootElement.rawElement);
  }

  void clearSurface(){
    _rootDiv.elements.clear();
  }

  /** Initializes the given [element] to the [Presenter]. */
  @override void initElement(PresenterElement element){
    super.initElement(element);

    if (element is HtmlSurfaceElement){
      surfaceElement[element.rawElement] = element;
      Browser.appendClass(element.rawElement, '$element');
    }
  }

  /**
   * Returns a [Future] containing the bounding position and dimensions of the
   * given [element].
   *
   * This measurement occurs within the browser layout interrupt to prevent
   * contention with animations.
   */
  @override Future<RectMeasurement> measure(SurfaceElement element){
    assert(element is HtmlSurfaceElement);
    assert(element.rawElement != null);

    final c = new Completer();

    window.requestLayoutFrame((){
      final bounding = element.rawElement.getBoundingClientRect();
      c.complete(
          new RectMeasurement(
              bounding.left, bounding.top, bounding.width, bounding.height));
    });

    return c.future;
  }


//    assert(primitive[element] == null);
//
//    HtmlPrimitive p;
//
//    // TODO Use some sort of supported type enumeration or a map instead
//    // of this?
//    if (primitiveKind is Box){
//      p = new BoxImpl();
//    } else if (primitiveKind is Scroller){
//      p = new ScrollerImpl();
//    } else if (primitiveKind is StackPanel){
//      p = new StackPanelImpl();
//    } else if (primitiveKind is TextPrimitive){
//      p = new TextImpl();
//    } else if (primitiveKind is ImagePrimitive){
//      p = new ImageImpl();
//    }else if (primitiveKind is ContentPresenterPrimitive){
//      p = new ContentPresenterImpl();
//    }else{
//        throw 'Invalid Surface Primitive';
//    }
//
//    primitive[element] = p;
//
//    surfaceElement[p.rawElement] = element;
//    return p;
//  }

  void _startEventLoop(){
    workers = new HashMap<String, EventLoopCallback>();
    window.requestAnimationFrame(_doEventLoopWork);
  }

  void _doEventLoopWork(num time){
    workers.forEach((_, work) => work(time));
    window.requestAnimationFrame(_doEventLoopWork);
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
      log('Invalid container type found: $container'
          ' ${container.containerContent}');
    }
  }

  void _loadChildren(FrameworkContainer container){
    if (container.containerContent == null) return;

    if (container.containerContent is Collection){
      container.containerContent.forEach((content){
        if(content is! SurfaceElement) {
          // likely a text node of a textblock.
          assert(content is String);
          return;
        }
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
      log('Invalid container type found: $container'
          ' ${container.containerContent}');
    }
  }
}