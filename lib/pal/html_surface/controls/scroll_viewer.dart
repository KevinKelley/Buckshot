library scrollviewer_html_buckshot;

import 'dart:html';
import 'package:buckshot/pal/html_surface/html_surface.dart';

class ScrollViewer extends SurfaceScrollViewer implements HtmlSurfaceElement
{

  final Element rawElement = new DivElement();


  ScrollViewer.register() : super.register();
  ScrollViewer();

  @override makeMe() => new ScrollViewer();

  /*
   * SurfaceScrollViewer overrides.
   */

  @override void onHScrollChanged(ScrollSetting value){
    rawElement.style.overflowX = '$value';
  }

  @override void onVScrollChanged(ScrollSetting value){
    rawElement.style.overflowY = '$value';
  }

  @override void onContentChanged(dynamic newChild){
    assert(newChild is HtmlSurfaceElement);

    if (newChild == null){
      rawElement.elements.clear();
      return;
    }

    if (newChild.isLoaded){
      throw 'Child already child of another element.';
    }

    rawElement.elements.clear();
    rawElement.elements.add(newChild.rawElement);
    newChild.parent = this;
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

  @override void onStyleChanged(StyleTemplate value){}

  @override void onDraggableChanged(bool draggable){}
}
