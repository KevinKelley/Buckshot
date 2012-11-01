
class ContentPresenterImpl
  extends ContentPresenterPrimitive implements HtmlPrimitive
{
  final Element rawElement = new DivElement();

  ContentPresenterImpl(){
    rawElement.style.overflow = 'hidden';
    rawElement.style.display = '-webkit-flex';
    rawElement.style.boxSizing = 'border-box';
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
          rawChild.style.minWidth = '0px';
          rawChild.style.setProperty('-webkit-flex', '1 1 auto');
          // this setting prevents the flex box from overflowing if it's child
          // content is bigger than it's parent.
          // Flexbox spec 7.2
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
