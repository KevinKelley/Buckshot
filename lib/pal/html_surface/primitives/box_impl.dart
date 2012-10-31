
class BoxImpl extends Box
{
  final Element rawElement = new DivElement();

  BoxImpl(){
    rawElement.style.overflow = 'hidden';
    rawElement.style.display = '-webkit-flex';
  }

  set cornerRadius(Thickness value){
    super.cornerRadius = value;

    rawElement.style.borderRadius =
      '${value.top}px ${value.right}px ${value.bottom}px ${value.left}px';
  }

  set margin(Thickness value){
    super.margin = value;

    rawElement.style.margin =
      '${value.top}px ${value.right}px ${value.bottom}px ${value.left}px';
  }

  set padding(Thickness value){
    super.padding = value;

    rawElement.style.padding =
      '${value.top}px ${value.right}px ${value.bottom}px ${value.left}px';
  }

  set strokeStyle(BorderStyle style){
    super.strokeStyle = style;

    rawElement.style.borderStyle = '$style';
  }

  set strokeColor(Color value){
    super.strokeColor = value;

    rawElement.style.borderColor = value.toColorString();
  }

  set strokeThickness(Thickness value){
    super.strokeThickness = value;
    rawElement.style.borderWidth =
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

  set fill(Brush brush){
    super.fill = brush;
    _setFill(brush);
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

  @override void updateChildLayout(){
    assert(child != null);

    final rawChild = htmlPresenter.primitive[child].rawElement;

    if (child.hAlign.value != null){
      switch(child.hAlign.value){
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
          rawChild.style.setProperty('-webkit-flex', 'auto');
          // this setting prevents the flex box from overflowing if it's child
          // content is bigger than it's parent.
          // Flexbox spec 7.2
          rawChild.style.minWidth = '100%';
          break;
      }
    }

    if (child.vAlign.value == null) return;
    switch(child.vAlign.value){
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
