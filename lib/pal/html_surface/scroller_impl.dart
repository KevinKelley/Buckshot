
class ScrollerImpl extends Scroller
{
  final Element rawElement = new DivElement();

  ScrollerImpl(){
    rawElement.style.background = 'Orange';
  }

  set horizontalScroll(ScrollSetting value){
    super.horizontalScroll = value;
    rawElement.style.overflowX = '$value';
  }

  set verticalScroll(ScrollSetting value){
    super.verticalScroll = value;
    rawElement.style.overflowY = '$value';
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

  SurfaceElement get child{
    if (rawElement.elements.isEmpty) return null;

    return htmlPresenter.surfaceElement[rawElement.elements[0]];
  }

  set child(SurfaceElement newChild){
    if (newChild == null){
      rawElement.elements.clear();
      return;
    }
    if (newChild.isLoaded){
      throw 'Child already child of another element.';
    }
    rawElement.elements.clear();
    rawElement.elements.add(htmlPresenter.primitive[newChild].rawElement);
    newChild.parent = htmlPresenter.surfaceElement[rawElement];
  }

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
