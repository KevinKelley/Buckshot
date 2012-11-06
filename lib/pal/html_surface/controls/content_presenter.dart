library contentpresenter_html_buckshot;

import 'dart:html';
import 'package:buckshot/pal/html_surface/html_surface.dart';


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

    _updateChildLayout();
  }


  /*
   * SurfaceContentPresenter overrides.
   */

  @override void onContentChanged(dynamic newContent){
    assert(newContent is HtmlSurfaceElement);

    if (newContent == null){
      rawElement.elements.clear();
      return;
    }
    if (newContent.isLoaded){
      throw 'Child already child of another element.';
    }
    rawElement.elements.clear();
    rawElement.elements.add(newContent.rawElement);
    newContent.parent = this;
  }


  /*
   * SurfaceElement Overrides
   */
  @override void onUserSelectChanged(bool value){}

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

  @override void onMaxWidthChanged(num value){}

  @override void onMaxHeightChanged(num value){}

  @override void onMinWidthChanged(num value){}

  @override void onMinHeightChanged(num value){}

  @override void onCursorChanged(Cursors value){}

  @override void onHAlignChanged(HorizontalAlignment value){
    if (!isLoaded) return;
    parent.updateLayout();
  }

  @override void onVAlignChanged(VerticalAlignment value){
    if (!isLoaded) return;
    parent.updateLayout();
  }

  @override void onZOrderChanged(num value){}

  @override void onOpacityChanged(num value){}

  @override void onVisibilityChanged(num value){}

  @override void onDraggableChanged(bool draggable){}

  /*
   * Private methods.
   */

  void _updateChildLayout(){
    assert(containerContent != null);

    final rawChild = containerContent.rawElement;

    if (containerContent.hAlign.value != null){
      switch(containerContent.hAlign.value){
        case HorizontalAlignment.left:
          rawElement.style.setProperty('-webkit-justify-content', 'flex-start');
          rawChild.style.setProperty('-webkit-flex', 'none');
          rawChild.style.minWidth = '';
          break;
        case HorizontalAlignment.right:
          rawElement.style.setProperty('-webkit-justify-content', 'flex-end');
          rawChild.style.setProperty('-webkit-flex', 'none');
          rawChild.style.minWidth = '';
          break;
        case HorizontalAlignment.center:
          rawElement.style.setProperty('-webkit-justify-content', 'center');
          rawChild.style.setProperty('-webkit-flex', 'none');
          rawChild.style.minWidth = '';
          break;
        case HorizontalAlignment.stretch:
          rawElement.style.setProperty('-webkit-justify-content', 'flex-start');
          rawChild.style.minWidth = '0px';
          rawChild.style.setProperty('-webkit-flex', '1 1 auto');
          // this setting prevents the flex box from overflowing if it's child
          // content is bigger than it's parent.
          // Flexbox spec 7.2
          break;
      }
    }

    if (containerContent.vAlign.value == null) return;
    switch(containerContent.vAlign.value){
      case VerticalAlignment.top:
        rawElement.style.setProperty('-webkit-align-items', 'flex-start');
        break;
      case VerticalAlignment.bottom:
        rawElement.style.setProperty('-webkit-align-items', 'flex-end');
        break;
      case VerticalAlignment.center:
        rawElement.style.setProperty('-webkit-align-items', 'center');
        break;
      case VerticalAlignment.stretch:
        rawElement.style.setProperty('-webkit-align-items', 'stretch');
        break;
    }
  }

}
