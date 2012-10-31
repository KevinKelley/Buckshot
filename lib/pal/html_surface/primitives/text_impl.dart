
class TextImpl extends TextPrimitive
{
  final Element rawElement = new ParagraphElement();

  TextImpl(){
    rawElement.style.minWidth = '0px';
  }

  set margin(Thickness value){
    super.margin = value;

    rawElement.style.margin =
      '${value.top}px ${value.right}px ${value.bottom}px ${value.left}px';
  }

  set width(num value) {
    super.width = value;
    rawElement.style.width = '${value}px';
  }

  set height(num value) {
    super.height = value;
    rawElement.style.height = '${value}px';
  }

  set foreground(Color color){
    super.foreground = color;
    rawElement.style.color = color.toColorString();
  }

  set text(String value){
    super.text = value;
    rawElement.text = value;
  }

  set fontFamily(String value){
    super.fontFamily = value;
    rawElement.style.fontFamily = '$value';
  }

  set fontWeight(String weight){
    super.fontWeight = weight;
    rawElement.style.fontWeight = '$weight';
  }

  set fontSize(num size){
    super.fontSize = size;
    rawElement.style.fontSize = '${size}px';
  }

  set background(Brush brush){
    super.background = brush;
    _setBackground(brush);
  }

  set decoration(String value){
    super.decoration = value;
    rawElement.style.textDecoration = '$value';
  }

  void _setBackground(Brush brush){
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
