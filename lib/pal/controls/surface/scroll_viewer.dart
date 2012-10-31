library scrollviewer_surface_controls_buckshot;

import 'package:buckshot/pal/surface/surface.dart';


class ScrollViewer extends SurfaceElement implements FrameworkContainer
{
  FrameworkProperty<ScrollSetting> hScroll;
  FrameworkProperty<ScrollSetting> vScroll;
  FrameworkProperty<SurfaceElement> content;

  Scroller _primitive;

  ScrollViewer.register() : super.register();
  ScrollViewer(){
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = content;
  }
  @override makeMe() => new ScrollViewer();

  get containerContent => content.value;

  @override initProperties(){
    super.initProperties();

    hScroll = new FrameworkProperty(this, 'hScroll',
        propertyChangedCallback:
          (ScrollSetting value) => _primitive.horizontalScroll = value,
          defaultValue: ScrollSetting.visible,
          converter: const StringToScrollSettingConverter());

    vScroll = new FrameworkProperty(this, 'vScroll',
        propertyChangedCallback:
          (ScrollSetting value) => _primitive.verticalScroll = value,
          defaultValue: ScrollSetting.visible,
          converter: const StringToScrollSettingConverter());

    content = new FrameworkProperty(this, 'content',
        propertyChangedCallback: (value) => _primitive.child = value);
  }

  @override void createPrimitive(){
    _primitive = surfacePresenter.createPrimitive(this, new Scroller());
  }

  void onUserSelectChanged(bool value){}
  void onMarginChanged(Thickness margin){
    _primitive.margin = margin;
  }
  void onWidthChanged(num value){
    _primitive.width = value;
  }
  void onHeightChanged(num value){
    _primitive.height = value;
  }
  void onMaxWidthChanged(num value){}
  void onMaxHeightChanged(num value){}
  void onMinWidthChanged(num value){}
  void onMinHeightChanged(num value){}
  void onCursorChanged(Cursors value){}
  void onHAlignChanged(HorizontalAlignment value){
    _primitive.hAlign = value;
    if (!isLoaded) return;
    parent.updateLayout();
  }
  void onValignChanged(VerticalAlignment value){
    _primitive.vAlign = value;
    if (!isLoaded) return;
    parent.updateLayout();
  }
  void onZOrderChanged(num value){}
  void onOpacityChanged(num value){}
  void onVisibilityChanged(num value){}
  void onStyleChanged(StyleTemplate value){}
  void onDraggableChanged(bool draggable){}
}
