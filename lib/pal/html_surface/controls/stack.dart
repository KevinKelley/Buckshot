library stack_html_buckshot;

import 'dart:html';
import 'package:buckshot/pal/html_surface/html_surface.dart';

class Stack extends SurfaceStack implements HtmlSurfaceElement
{
  final Element rawElement = new DivElement();

  Stack.register() : super.register();
  Stack(){
    rawElement.style.overflow = 'hidden';
    rawElement.style.display = '-webkit-flex';
    children.listChanged + onListChanged;
  }

  @override makeMe() => new Stack();

  void onListChanged(_, ListChangedEventArgs args){
    args.oldItems.forEach((child){
      rawElement.remove();
      child.parent = null;
    });

    args.newItems.forEach((child){
      rawElement.elements.add(child.rawElement);
      child.parent = this;
      _setChildCrossAxisAlignment(child);
    });
  }

  /**
   * Updates the cross-axis alignments for all children. */
  void _updateChildAlignments(){
    children.forEach((child){
      _setChildCrossAxisAlignment(child);
    });
  }

  void _setChildCrossAxisAlignment(HtmlSurfaceElement child){
    final rawChild = child.rawElement as Element;

    if (orientation.value == Orientation.horizontal){
      if (child.vAlign.value == null) return;
      switch(child.vAlign.value){
        case VerticalAlignment.top:
          rawChild.style.setProperty('-webkit-align-self', 'flex-start');
          break;
        case VerticalAlignment.bottom:
          rawChild.style.setProperty('-webkit-align-self', 'flex-end');
          break;
        case VerticalAlignment.center:
          rawChild.style.setProperty('-webkit-align-self', 'center');
          break;
        case VerticalAlignment.stretch:
          rawChild.style.setProperty('-webkit-align-self', 'stretch');
          break;
      }
    }else{
      if (child.hAlign.value == null) return;
      switch(child.hAlign.value){
        case HorizontalAlignment.left:
          rawChild.style.setProperty('-webkit-align-self', 'flex-start');
          break;
        case HorizontalAlignment.right:
          rawChild.style.setProperty('-webkit-align-self', 'flex-end');
          break;
        case HorizontalAlignment.center:
          rawChild.style.setProperty('-webkit-align-self', 'center');
          break;
        case HorizontalAlignment.stretch:
          rawChild.style.setProperty('-webkit-align-self', 'stretch');
          break;
      }
    }
  }

  /*
   * SurfaceStack Overrides
   */

  @override void onOrientationChanged(Orientation value){
    rawElement.style.flexFlow =
      (value == Orientation.vertical) ? 'column' : 'row';

    _updateChildAlignments();
  }

  @override void onBackgroundChanged(Brush brush){
    _setFill(brush);
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


  /*
   * Private methods.
   */

  void _setFill(Brush brush){
    if (brush is SolidColorBrush){
      rawElement.style.background =
          '${brush.color.value.toColorString()}';
    }else if (brush is LinearGradientBrush){
      rawElement.style.background =
          brush.fallbackColor.value.toColorString();

      final colorString = new StringBuffer();

      //create the string of stop colors
      brush.stops.value.forEach((GradientStop stop){
        colorString.add(stop.color.value.toColorString());

        if (stop.percent.value != -1) {
          colorString.add(" ${stop.percent.value}%");
        }

        if (stop != brush.stops.value.last) {
          colorString.add(", ");
        }
      });

      //set the background for all browser types
      rawElement.style.background =
          "-webkit-linear-gradient(${brush.direction.value}, ${colorString})";
      rawElement.style.background =
          "-moz-linear-gradient(${brush.direction.value}, ${colorString})";
      rawElement.style.background =
          "-ms-linear-gradient(${brush.direction.value}, ${colorString})";
      rawElement.style.background =
          "-o-linear-gradient(${brush.direction.value}, ${colorString})";
      rawElement.style.background =
          "linear-gradient(${brush.direction.value}, ${colorString})";
    }else if (brush is RadialGradientBrush){
      //set the fallback
      rawElement.style.background = brush.fallbackColor.value.toColorString();

      final colorString = new StringBuffer();

      //create the string of stop colors
      brush.stops.value.forEach((GradientStop stop){
        colorString.add(stop.color.value.toColorString());

        if (stop.percent.value != -1) {
          colorString.add(" ${stop.percent.value}%");
        }

        if (stop != brush.stops.value.last) {
          colorString.add(", ");
        }
      });

      //set the background for all browser types
      rawElement.style.background =
        "-webkit-radial-gradient(50% 50%, ${brush.drawMode.value}, ${colorString})";
      rawElement.style.background =
        "-moz-radial-gradient(50% 50%, ${brush.drawMode.value}, ${colorString})";
      rawElement.style.background =
        "-ms-radial-gradient(50% 50%, ${brush.drawMode.value}, ${colorString})";
      rawElement.style.background =
        "-o-radial-gradient(50% 50%, ${brush.drawMode.value}, ${colorString})";
      rawElement.style.background =
        "radial-gradient(50% 50%, ${brush.drawMode.value}, ${colorString})";
    }else{
      log('Unrecognized brush "$brush" assignment. Defaulting to solid white.');
      rawElement.style.background =
          new SolidColorBrush.fromPredefined(Colors.White);
    }
  }
}
