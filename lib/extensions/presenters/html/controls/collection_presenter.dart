library collectionpresenter_html_buckshot;

import 'dart:html';
import 'package:buckshot/extensions/presenters/html/html_surface.dart';

class CollectionPresenter
  extends SurfaceCollectionPresenter implements HtmlSurfaceElement
{
  /**
   * Expands a property on a SurfaceElement which holds a reference to the
   * object item from the items collection.  This is typically used on the
   * template object that is created for each item in the items Collection.
   */
  final Expando<dynamic> objectReference = new Expando<dynamic>();

  /**
   * Expands a property on a SurfaceElement which holds a reference to the
   * template object created during construction of the CollectionPresenter
   * visual elements.
   */
  final Expando<HtmlSurfaceElement> templateReference =
      new Expando<HtmlSurfaceElement>();

  final Element rawElement = new DivElement();

  CollectionPresenter.register() : super.register();
  CollectionPresenter(){
    rawElement.style.display = '-webkit-flex';
    rawElement.style.boxSizing = 'border-box';
    assert(rawElement.style.display == '-webkit-flex');

    presentationPanel.value = new Stack();
  }

  @override makeMe() => new CollectionPresenter();

  @override void onPanelChanged(SurfaceElement newPanel){
    assert(newPanel != null);
    assert(newPanel is FrameworkContainer);
    assert((newPanel as FrameworkContainer).containerContent is List);

    rawElement.elements.clear();
    rawElement.elements.add(newPanel.rawElement);
    newPanel.parent = this;
  }

  @override onFirstLoad(){
    invalidate();
  }

  @override void onItemsChanged(Collection newItemsCollection){}
  @override void onItemsTemplateChanged(String newTemplate){}

  void invalidate(){
    assert(presentationPanel.value != null);

    //print('invalidating CollectionPresenter');

    var values = items.value;

    if (values == null){
      final dc = resolveDataContext();
      if (dc == null && presentationPanel.value.isLoaded){
        presentationPanel.value.containerContent.clear();
        return;
      } else if (dc == null){
          return;
      }

      values = dc.value;
    }

    if (values is! Collection){
      throw const BuckshotException("Expected CollectionPresenter items"
        " to be of type Collection.");
    }

    presentationPanel.value.rawElement.elements.clear();
    _addItems(values);
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
  void _removeItems(Collection items){
    int count = 0;
    final container = presentationPanel.value.containerContent;

    for(final element in container.children){
      if (items.some((item) => item == objectReference[element])){
        container.children.remove(element);
        count++;
      }

      if (count == items.length){
        // found them all
        break;
      }
    }
  }

  void _addItems(Collection items){
    if (itemsTemplate.value == null){
      //no template, then just call toString on the object.
      items.forEach((iterationObject){
        final it = new TextBlock()
          ..hAlign.value = HorizontalAlignment.stretch
          ..text.value = '$iterationObject';
        objectReference[it] = iterationObject;

        //itemCreated.invokeAsync(this, new ItemCreatedEventArgs(it));
        presentationPanel.value.containerContent.add(it);
      });
    }else{
      items.forEach((iterationObject){
        Template
        .deserialize(itemsTemplate.value)
        .then((SurfaceElement it){
          objectReference[it] = iterationObject;
          it.dataContext.value = iterationObject;
          //templateReference[iterationObject] = it;
          // itemCreated.invokeAsync(this, new ItemCreatedEventArgs(it));
          presentationPanel.value.containerContent.add(it);
        });
      });
    }
  }

  @override void updateLayout(){
    super.updateLayout();
    if (!isLoaded) return;
    if (presentationPanel.value == null) return;

    _updateChildLayout();
  }

  void _updateChildLayout(){
    assert(containerContent != null);

    final rawChild = presentationPanel.value.rawElement;

    if (presentationPanel.value.hAlign.value != null){
      switch(presentationPanel.value.hAlign.value){
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

    if (presentationPanel.value.vAlign.value == null) return;
    switch(presentationPanel.value.vAlign.value){
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
