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

    margin = new FrameworkProperty(this, 'margin',
        propertyChangedCallback: (Thickness value){
          _primitive.margin = value;
        },
        converter: const StringToThicknessConverter());

    hAlign = new FrameworkProperty(this, 'hAlign',
        propertyChangedCallback: (HorizontalAlignment align){
          _primitive.hAlign = align;
          if (!isLoaded) return;
          parent.updateLayout();
        },
        defaultValue: HorizontalAlignment.left,
        converter: const StringToHorizontalAlignmentConverter());

    vAlign = new FrameworkProperty(this, 'vAlign',
        propertyChangedCallback: (VerticalAlignment align){
          _primitive.vAlign = align;
          if (!isLoaded) return;
          parent.updateLayout();
        },
        defaultValue: VerticalAlignment.top,
        converter: const StringToVerticalAlignmentConverter());

    width = new FrameworkProperty(this, 'width',
        propertyChangedCallback: (num value) => _primitive.width = value,
        converter: const StringToNumericConverter());

    height = new FrameworkProperty(this, 'height',
        propertyChangedCallback: (num value) => _primitive.height = value,
        converter: const StringToNumericConverter());
  }

  @override void createElement(){
    _primitive = surfacePresenter.createPrimitive(this, new Scroller());
  }

}
