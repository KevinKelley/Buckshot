
/**
 * A primitive type for surface presentations.
 *
 * A box may contain a single child [SurfaceElement]
 */
class Box extends SurfacePrimitive
{
  Brush fill;
  Thickness strokeThickness;
  Color strokeColor;
  Thickness cornerRadius;
  Thickness padding;
  BorderStyle strokeStyle;

  set child(SurfaceElement child) {}
  SurfaceElement get child {}

  void updateChildLayout(){}
}