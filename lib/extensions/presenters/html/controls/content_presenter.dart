library contentpresenter_html_buckshot;

import 'dart:html';
import 'package:buckshot/extensions/presenters/html/html_surface.dart';


class ContentPresenter
  extends SurfaceContentPresenter implements HtmlSurfaceElement
{
  final Element rawElement = new DivElement();

  ContentPresenter.register() : super.register();
  ContentPresenter(){
    rawElement.style.overflow = 'hidden';
    rawElement.style.display = '-webkit-flex';
    rawElement.style.boxSizing = 'border-box';
  }

  @override makeMe() => new ContentPresenter();


  @override void updateLayout(){
    if (content.value == null) return;
    if (!isLoaded) return;

    HtmlSurfaceElement.updateChildAlignment(this);
  }

  @override void initEvents(){
    HtmlSurfaceElement.initializeBaseEvents(this);
    super.initEvents();
  }

  /*
   * SurfaceContentPresenter overrides.
   */

  @override void onContentChanged(dynamic newContent){
    assert(newContent is HtmlSurfaceElement || newContent is String);

    if (newContent == null){
      rawElement.elements.clear();
      return;
    }

    if (newContent is HtmlSurfaceElement && newContent.isLoaded){
      throw 'Child already child of another element.';
    }

    rawElement.elements.clear();

    if (newContent is String){
      content.value = new TextBlock()..text.value = newContent;
      return;
    }

    rawElement.elements.add(newContent.rawElement);
    newContent.parent = this;
  }


  /*
   * SurfaceElement Overrides
   */
  @override void onUserSelectChanged(bool value){
      rawElement.style.userSelect = value ? 'all' : 'none';
  }

  @override void onMarginChanged(Thickness value){
    rawElement.style.margin =
        '${value.top}px ${value.right}px ${value.bottom}px ${value.left}px';
  }

  @override void onWidthChanged(num value){
    rawElement.style.width = '${value}px';
  }

  @override void onHeightChanged(num value){
    rawElement.style.height = '${value}px';
  }

  @override void onMaxWidthChanged(num value){
    rawElement.style.maxWidth = '${value}px';
  }

  @override void onMaxHeightChanged(num value){
    rawElement.style.maxHeight = '${value}px';
  }

  @override void onMinWidthChanged(num value){
    rawElement.style.minWidth = '${value}px';
  }

  @override void onMinHeightChanged(num value){
    rawElement.style.minHeight = '${value}px';
  }

  @override void onCursorChanged(Cursors value){
    rawElement.style.cursor = '$value';
  }

  @override void onHAlignChanged(HorizontalAlignment value){
    if (!isLoaded) return;
    parent.updateLayout();
  }

  @override void onVAlignChanged(VerticalAlignment value){
    if (!isLoaded) return;
    parent.updateLayout();
  }

  @override void onZOrderChanged(num value){
    rawElement.style.zIndex = '$value';
  }

  @override void onOpacityChanged(num value){
    rawElement.style.opacity = '$value';
  }

  @override void onVisibilityChanged(Visibility value){
    if (value == Visibility.visible){
      rawElement.style.visibility = '$value';
      rawElement.style.display =
          stateBag["display"] == null ? "inherit" : stateBag["display"];
    }else{
      //preserve in case some element is using "inline"
      //or some other fancy display value
      stateBag["display"] = rawElement.style.display;
      rawElement.style.visibility = '$value';
      rawElement.style.display = "none";
    }
  }

  @override void onDraggableChanged(bool draggable){
    throw new NotImplementedException('todo...');
  }
}
