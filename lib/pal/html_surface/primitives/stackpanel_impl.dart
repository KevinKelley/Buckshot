
class StackPanelImpl extends StackPanel implements HtmlPrimitive
{
  final Element rawElement = new DivElement();

  StackPanelImpl(){
    rawElement.style.overflow = 'hidden';
    rawElement.style.display = '-webkit-flex';
    children.listChanged + onListChanged;
  }

  set orientation(Orientation value){
    if (super.orientation == value) return;
    super.orientation = value;

    rawElement.style.flexFlow =
      (value == Orientation.vertical) ? 'column' : 'row';

    updateChildAlignments();
  }

  void onListChanged(_, ListChangedEventArgs args){
    args.oldItems.forEach((child){
      htmlPresenter.primitive[child].rawElement.remove();
    });

    args.newItems.forEach((child){
      rawElement.elements.add(htmlPresenter.primitive[child].rawElement);
      _setChildCrossAxisAlignment(htmlPresenter.primitive[child]);
    });
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

  set fill(Brush brush){
    super.fill = brush;
    _setFill(brush);
  }

  /**
   * Updates the cross-axis alignments for all children. */
  void updateChildAlignments(){
    children.forEach((child){
      _setChildCrossAxisAlignment(htmlPresenter.primitive[child]);
    });
  }

  void _setChildCrossAxisAlignment(HtmlPrimitive child){
    final rawChild = child.rawElement as Element;

    if (orientation == Orientation.horizontal){
      if (child.vAlign == null) return;
      switch(child.vAlign){
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
      if (child.hAlign == null) return;
      switch(child.hAlign){
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
