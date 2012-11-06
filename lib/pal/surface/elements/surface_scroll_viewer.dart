part of surface_buckshot;

abstract class SurfaceScrollViewer
  extends SurfaceElement implements FrameworkContainer
{
  FrameworkProperty<ScrollSetting> hScroll;
  FrameworkProperty<ScrollSetting> vScroll;
  FrameworkProperty<SurfaceElement> content;

  SurfaceScrollViewer.register() : super.register();
  SurfaceScrollViewer(){
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = content;
  }

  get containerContent => content.value;

  void onContentChanged(dynamic content);
  void onHScrollChanged(ScrollSetting value);
  void onVScrollChanged(ScrollSetting value);

  @override initProperties(){
    super.initProperties();

    hScroll = new FrameworkProperty(this, 'hScroll',
        propertyChangedCallback: onHScrollChanged,
          defaultValue: ScrollSetting.visible,
          converter: const StringToScrollSettingConverter());

    vScroll = new FrameworkProperty(this, 'vScroll',
        propertyChangedCallback: onVScrollChanged,
          defaultValue: ScrollSetting.visible,
          converter: const StringToScrollSettingConverter());

    content = new FrameworkProperty(this, 'content',
        propertyChangedCallback: onContentChanged);
  }
}
