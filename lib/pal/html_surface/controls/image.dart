library image_html_buckshot;

import 'dart:html';
import 'package:buckshot/pal/html_surface/html_surface.dart';

class Image extends SurfaceImage implements HtmlSurfaceElement
{
  final Element rawElement = new ImageElement();

  Image.register() : super.register();
  Image();

  @override makeMe() => new Image();

  /*
   * SurfaceImage overrides.
   */

  @override void onUriChanged(String newUri){
    rawElement.attributes['src'] = '$newUri';
  }

  @override void onAltChanged(String newAlt){
    rawElement.attributes['alt'] = '$newAlt';
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
}
