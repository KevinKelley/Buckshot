
/** Base class for surface primitive types */
abstract class SurfacePrimitive
{
  num width;
  num height;
  num minWidth;
  num minHeight;
  num maxWidth;
  num maxHeight;
  num opacity;
  Visibility visibility;
  HorizontalAlignment hAlign;
  VerticalAlignment vAlign;
  Thickness margin;
  Cursors cursor;
  String name;
}