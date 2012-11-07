part of box_model_surface_buckshot;

abstract class SurfaceCollectionPresenter
  extends BoxModelSurfaceElement implements FrameworkContainer
{
  FrameworkProperty<SurfaceElement> presentationPanel;
  FrameworkProperty<String> itemsTemplate;
  /** Represents the collection to be used by the CollectionPresenter */
  FrameworkProperty<Collection> items;

  SurfaceCollectionPresenter.register() : super.register();
  SurfaceCollectionPresenter();

  get containerContent => items.value;

  void onPanelChanged(SurfaceElement newPanel);
  void onItemsTemplateChanged(String template);
  void onItemsChanged(Collection newItemsCollection);

  @override void initProperties(){
    super.initProperties();

    presentationPanel = new FrameworkProperty(this, 'presentationPanel',
        propertyChangedCallback: onPanelChanged);

    itemsTemplate = new FrameworkProperty(this, 'itemsTemplate',
        propertyChangedCallback: onItemsTemplateChanged);

    items = new FrameworkProperty(this, 'items',
        propertyChangedCallback: onItemsChanged);
  }

}
