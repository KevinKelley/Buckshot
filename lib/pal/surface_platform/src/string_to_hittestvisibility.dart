part of surface_buckshot;

class StringToHitTestVisibilityConverter implements ValueConverter
{
  const StringToHitTestVisibilityConverter();

  convert(value, {parameter}){
    if (value is! String) return value;

    switch(value){
      case 'visiblePainted': return HitTestVisibility.visiblePainted;
      case 'visibleFill': return HitTestVisibility.visibleFill;
      case 'visibleStroke': return HitTestVisibility.visibleStroke;
      case 'visible': return HitTestVisibility.visible;
      case 'painted': return HitTestVisibility.painted;
      case 'fill': return HitTestVisibility.fill;
      case 'stroke': return HitTestVisibility.stroke;
      case 'all': return HitTestVisibility.all;
      case 'none': return HitTestVisibility.none;
      default: return HitTestVisibility.none;
    }
  }
}