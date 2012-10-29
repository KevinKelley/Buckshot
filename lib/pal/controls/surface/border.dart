library border_surface_controls_buckshot;

import 'package:buckshot/pal/surface/surface.dart';

class Border extends SurfaceElement
{
  FrameworkProperty<Brush> background;

  Border.register() : super.register();
  Border();
  makeMe() => new Border();

  @override createElement(){
    surfacePresenter.createPrimitive(this, SurfacePrimitive.box);
  }

  @override void initProperties(){
    super.initProperties();

    background = new FrameworkProperty(this, 'background',
        propertyChangedCallback: (Brush value){
          surfacePresenter.setFill(this, value);
        },
        converter: const StringToSolidColorBrushConverter());
  }
}
