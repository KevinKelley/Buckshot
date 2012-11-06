library textblock_html_buckshot;

import 'dart:html';
import 'package:buckshot/pal/html_surface/html_surface.dart';

class TextBlock extends SurfaceText implements HtmlSurfaceElement
{
  final Element rawElement = new ParagraphElement();

  TextBlock(){
    // This setting helps with wrapping in flexbox containers.
    rawElement.style.minWidth = '0px';
    rawElement.style.margin = '0px';
  }

  TextBlock.register() : super.register();
  makeMe() => new TextBlock();


  /*
   * SurfaceText Overrides
   */
  @override void onFontWeightChanged(String value){
    rawElement.style.fontWeight = '$value';
  }

  @override void onDecorationChanged(String decoration){
    rawElement.style.textDecoration = '$decoration';
  }

  @override void onBackgroundChanged(Brush brush){
    _setFill(brush);
  }

  @override void onForegroundChanged(Color color){
    rawElement.style.color = color.toColorString();
  }

  @override void onTextChanged(String text){
    rawElement.text = '$text';
  }

  @override void onFontSizeChanged(num value){
    rawElement.style.fontSize = '${value}px';
  }

  @override void onFontFamilyChanged(String family){
    rawElement.style.fontFamily = '$family';
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
