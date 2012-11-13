// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

library html_platform_buckshot;

import 'dart:html';
import 'package:xml/xml.dart';
import 'package:buckshot/web/web.dart';
import 'package:buckshot/pal/box_model_surface/box_model_surface.dart';
export 'package:buckshot/pal/box_model_surface/box_model_surface.dart';

//html included controls
import 'package:buckshot/extensions/platforms/html/controls/border.dart';
import 'package:buckshot/extensions/platforms/html/controls/text_block.dart';
import 'package:buckshot/extensions/platforms/html/controls/stack.dart';
import 'package:buckshot/extensions/platforms/html/controls/scroll_viewer.dart';
import 'package:buckshot/extensions/platforms/html/controls/image.dart';
import 'package:buckshot/extensions/platforms/html/controls/content_presenter.dart';
import 'package:buckshot/extensions/platforms/html/controls/collection_presenter.dart';
import 'package:buckshot/extensions/platforms/html/controls/slider.dart';
import 'package:buckshot/extensions/platforms/html/controls/button.dart';
import 'package:buckshot/extensions/platforms/html/controls/control.dart';
import 'package:buckshot/extensions/platforms/html/controls/check_box.dart';
import 'package:buckshot/extensions/platforms/html/controls/radio_button.dart';
import 'package:buckshot/extensions/platforms/html/controls/text_box.dart';
import 'package:buckshot/extensions/platforms/html/controls/text_area.dart';
import 'package:buckshot/extensions/platforms/html/controls/hyperlink.dart';
import 'package:buckshot/extensions/platforms/html/controls/drop_down_list.dart';
import 'package:buckshot/extensions/platforms/html/controls/grid/grid.dart';
import 'package:buckshot/extensions/platforms/html/controls/layout_canvas.dart';
import 'package:buckshot/extensions/platforms/html/controls/raw_html.dart';

export 'package:buckshot/extensions/platforms/html/controls/border.dart';
export 'package:buckshot/extensions/platforms/html/controls/text_block.dart';
export 'package:buckshot/extensions/platforms/html/controls/stack.dart';
export 'package:buckshot/extensions/platforms/html/controls/scroll_viewer.dart';
export 'package:buckshot/extensions/platforms/html/controls/image.dart';
export 'package:buckshot/extensions/platforms/html/controls/content_presenter.dart';
export 'package:buckshot/extensions/platforms/html/controls/collection_presenter.dart';
export 'package:buckshot/extensions/platforms/html/controls/control.dart';
export 'package:buckshot/extensions/platforms/html/controls/slider.dart';
export 'package:buckshot/extensions/platforms/html/controls/button.dart';
export 'package:buckshot/extensions/platforms/html/controls/check_box.dart';
export 'package:buckshot/extensions/platforms/html/controls/radio_button.dart';
export 'package:buckshot/extensions/platforms/html/controls/text_box.dart';
export 'package:buckshot/extensions/platforms/html/controls/text_area.dart';
export 'package:buckshot/extensions/platforms/html/controls/hyperlink.dart';
export 'package:buckshot/extensions/platforms/html/controls/drop_down_list.dart';
export 'package:buckshot/extensions/platforms/html/controls/grid/grid.dart';
export 'package:buckshot/extensions/platforms/html/controls/layout_canvas.dart';
export 'package:buckshot/extensions/platforms/html/controls/raw_html.dart';

part 'src/html_platform_element.dart';

bool _platformInitialized = false;

/**
 * Initializes the Buckshot framework to use the [HtmlPlatform] presenter.
 *
 * Optional argument [hostID] may also be specified (e.g. '#myhostdiv')
 *
 * IMPORTANT:  This should be called first before making any other calls
 * to the Buckshot API.
 */
void initPlatform({String hostID : '#BuckshotHost'}){
  if (_platformInitialized) return;
  _htmlPlatform = new HtmlPlatform.host(hostID);
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
  registerElement(new LayoutCanvas.register());
  registerElement(new RawHtml.register());
  htmlPlatform._loadResources();
  _platformInitialized = true;
}

/**
 * Gets the [HtmlPlatform] context for this [Platform].
 */
HtmlPlatform get htmlPlatform => platform as HtmlPlatform;
set _htmlPlatform(HtmlPlatform p) {
  assert(platform == null);
  platform = p;
}

/**
 * Html box model presentation provider.
 */
class HtmlPlatform extends BoxModelSurface
{
  static const int _UNKNOWN = -1;
  static const int _HTML_ELEMENT = 0;
  static const int _HTTP_RESOURCE = 1;
  static const int _SERIALIZED = 2;
  bool _resourcesLoaded = false;
  final Expando<HtmlPlatformElement> surfaceElement =
      new Expando<HtmlPlatformElement>();
  Element _rootDiv;

  /** Initializes the HtmlPlatform with the default host ID '#BuckshotHost'. */
  factory HtmlPlatform() => new HtmlPlatform._internal('#BuckshotHost');

  /**
   * Initializes thte HtmlPlatform using the given [hostID] which must begin
   * with a '#'.
   */
  factory HtmlPlatform.host(String hostID) =>
      new HtmlPlatform._internal(hostID);

  HtmlPlatform._internal(String hostID){
    assert(hostID != null);
    assert(hostID.startsWith('#'));
    _rootDiv = query(hostID);

    if (_rootDiv == null){
      throw "Unable to initialize the HtmlSurface provider. "
        "Div with ID 'BuckshotHost' not found in HTML page.";
    }

    _setMutationObserver(_rootDiv);
    _initCSS();
    _startEventLoop();
  }

  String get namespace => 'http://surface.buckshotui.org/html';

  /**
   * Helper function which takes an [element] and binds it's
   * width and height values to the dimensions of the viewport.
   *
   *  Currently only supports desktop browsers.
   */
  void bindToBrowserDimensions(HtmlPlatformElement element){
    bind(viewportHeight, element.height);
    bind(viewportWidth, element.width);
    if (viewportHeight.value == null){
      element.height.value = window.innerHeight;
    }
    if (viewportWidth.value == null){
      element.width.value = window.innerWidth;
    }
  }

  @override Future<String> getTemplate(String uri){
    var c = new Completer();
    final type = _determineType(uri);

    if (type == _HTML_ELEMENT) {
      // e.g. "#something"
      var result = document.query(uri);
      if (result == null) {
        throw new BuckshotException('Unabled to find template'
            ' "${uri}" in HTML file.');
      }
      c.complete(result.text.trim());
    }else if (type == _HTTP_RESOURCE){
      // e.g. "path/to/myTemplate.xml"
      var r = new HttpRequest();

      void onError(e) {
        c.complete(null);
      }

      r.on.abort.add(onError);
      r.on.error.add(onError);
      r.on.loadEnd.add((e) {
        c.complete(r.responseText.trim());
      });

      try{
        r.open('GET', uri, true);
        r.setRequestHeader('Accept', 'text/xml');
        r.send();
      }on Exception catch(e){
        c.complete(null);
      }
    }else{
      // should be a template.
      c.complete(uri);
    }

    return c.future;
  }

  /**
   * Renders the given [view] into a host [Border] container, which is
   * implicitly created in the DOM host element.
   */
  @override Future<PlatformElement> render(View view){
    return initFramework()
            .chain((_) => view.ready)
            .chain((rootVisual){
              _rootDiv.elements.clear();
              final b = new Border()..isLoaded = true;
              _rootDiv.elements.add(b.rawElement);
              b.content.value = rootVisual;
              return new Future.immediate(rootVisual);
            });
  }

  void clearSurface(){
    _rootDiv.elements.clear();
  }

  /** Initializes the given [element] to the [Presenter]. */
  @override void initElement(PlatformElement element){
    if (element is HtmlPlatformElement){
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
    assert(element is HtmlPlatformElement);
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

  @override void initProperties(){
    super.initProperties();
    viewportWidth = new FrameworkProperty(this, 'viewportwidth');
    viewportHeight = new FrameworkProperty(this, 'viewportheight');
    _setViewportWatcher();
  }

  /**
  * Used to determine the type of the string.
  *
  * Checks to see if its referencing a [_HTML_ELEMENT], a [_HTTP_RESOURCE]
  * or one of the serialized types [_SERIALIZED].
  */
  static int _determineType(String from) {
    if (from.startsWith('#')) {
      return _HTML_ELEMENT;
    }else{
      final t = new Template();

      for(final p in t.providers){
        if(p.isFormat(from)){
          return _SERIALIZED;
        }
      }
    }

    // Assume its pointing to a HTTP resource
    return _HTTP_RESOURCE;
  }

  StyleElement _buckshotCSS;
  void _initCSS(){
    document.head.elements.add(
        new Element.html('<style id="__BuckshotCSS__"></style>'));

    _buckshotCSS = document.head.query('#__BuckshotCSS__');

    assert(_buckshotCSS != null);
  }

  Future _loadResources(){
    if (_resourcesLoaded) return new Future.immediate(false);
    _resourcesLoaded = true;

    if (!document.body.attributes.containsKey('data-buckshot-resources')){
      return new Future.immediate(false);
    }

    return Template
        .deserialize(document.body.attributes['data-buckshot-resources']);
  }

  void _setViewportWatcher(){
    window.on.resize.add((e){
      if (window.innerWidth != viewportWidth.value){
        viewportWidth.value = window.innerWidth;
      }

      if (window.innerHeight != viewportHeight.value){
        viewportHeight.value = window.innerHeight;
      }
    });
  }

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
        if (el.isLoaded) return;
        el.onLoaded();

        if (el is FrameworkContainer){
          _loadChildren(el);
        }
      });

      r.removedNodes.forEach((node){
        if (surfaceElement[node] == null) return;
        final el = surfaceElement[node];
        if (!el.isLoaded) return;
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