
class ScrollerImpl extends Scroller
{
  final Element rawElement = new DivElement();

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
}
