part of surface_buckshot;

/**
 * A presenter element which itself has no visual attributes, but can display
 * a single child element.
 *
 * ContentPresenter is typically used as a placeholder element in control
 * templates.
 */
abstract class SurfaceContentPresenter
  extends SurfaceElement implements FrameworkContainer
{
  FrameworkProperty<SurfaceElement> content;

  SurfaceContentPresenter.register() : super.register();
  SurfaceContentPresenter(){
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = content;
  }

  get containerContent => content.value;

  void onContentChanged(dynamic newContent);

  @override initProperties(){
    super.initProperties();

    content = new FrameworkProperty(this, 'content',
        propertyChangedCallback: onContentChanged);
  }
}
