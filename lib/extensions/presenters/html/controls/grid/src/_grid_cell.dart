part of grid_html_buckshot;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

// Internal class that provides virtual containers for the
// Grid control.
class _GridCell extends Control implements FrameworkContainer
{
  EventHandlerReference _ref;
  FrameworkProperty<HtmlSurfaceElement> content;

  _GridCell()
  {
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = content;
  }
  _GridCell.register() : super.register();
  makeMe() => null;

  get containerContent => content.value;

  @override void initProperties(){
    super.initProperties();

    content = new FrameworkProperty(this, 'content',
      propertyChangedCallback: (HtmlSurfaceElement newContent)
        {
          rawElement.elements.clear();
          assert(newContent != null);
          rawElement.elements.add(newContent.rawElement);
        });
  }

  @override void createPrimitive(){
    rawElement = new DivElement()
                    ..style.overflow = "hidden"
                    ..style.position = "absolute"
//                    ..style.background = 'Blue'
                    ..style.display ='table';

    rawElement.style.display = '-webkit-flex';
    rawElement.style.boxSizing = 'border-box';
  }

  @override void updateLayout(){
    super.updateLayout();
    if (!isLoaded) return;
    if (content.value == null) return;
    _updateChildLayout();
  }

  void _updateChildLayout(){
    assert(containerContent != null);

    final rawChild = containerContent.rawElement;

    if (containerContent.hAlign.value != null){
      switch(containerContent.hAlign.value){
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

    if (containerContent.vAlign.value == null) return;
    switch(containerContent.vAlign.value){
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
