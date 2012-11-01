
/**
 * Represents a CollectionPresenter model, which renders a collection of
 * items into a panel container, using the given template.
 */
class CollectionPresenterImpl
  extends CollectionPrimitive implements HtmlPrimitive
{
  /**
   * Expands a property on a SurfaceElement which holds a reference to the
   * object item from the items collection.  This is typically used on the
   * template object that is created for each item in the items Collection.
   */
  final Expando<SurfaceElement> objectReference = new Expando<SurfaceElement>();

  /**
   * Expands a property on a SurfaceElement which holds a reference to the
   * template object created during construction of the CollectionPresenter
   * visual elements.
   */
  final Expando<SurfaceElement> templateReference =
      new Expando<SurfaceElement>();

  final rawElement = new DivElement();
  final SurfaceElement _visual;

  CollectionPresenterImpl(this._visual){
    rawElement.style.display = '-webkit-flex';
    rawElement.style.boxSizing = 'border-box';
    assert(rawElement.style.display == '-webkit-flex');
  }

  set panel(SurfaceElement container){
    assert(container != null);
    assert(container is FrameworkContainer);
    assert((container as FrameworkContainer).containerContent is List);

    super.panel = container.containerContent;

    rawElement.elements.clear();
    rawElement.elements.add(htmlPresenter.primitive[container].rawElement);
  }

  set items(ObservableList<SurfaceElement> list){
    assert(items == null);
    items = list;
  }

  set template(String value){
    assert(template == null);
    template = value;
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

  void invalidate(){
    assert(panel != null);
    assert(_visual != null);

    print('invalidating CollectionPresenter');

    var values = items;

    if (items == null){
      final dc = _visual.resolveDataContext();

      if (dc == null && panel.isLoaded){
        (panel as FrameworkContainer).containerContent.clear();
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

    htmlPresenter.primitive[panel].rawElement.elements.clear();
    _addItems(values);
  }

  void _removeItems(Collection items){
    int count = 0;
    final container = (panel as FrameworkContainer).containerContent;

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
    assert(template != null);

    items.forEach((iterationObject){
      Template
        .deserialize(template)
        .then((SurfaceElement it){
          objectReference[it] = iterationObject;
          it.dataContext.value = iterationObject;
          templateReference[iterationObject] = it;
          // itemCreated.invokeAsync(this, new ItemCreatedEventArgs(it));
          (panel as FrameworkContainer).containerContent.add(it);
        });
    });
  }
}
