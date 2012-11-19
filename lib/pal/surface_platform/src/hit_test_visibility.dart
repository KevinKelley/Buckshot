part of surface_buckshot;

/**
 * Enumerates hit-test settings of an [SvgPlatformElement].
 */
class HitTestVisibility
{
  final String _str;
  const HitTestVisibility(this._str);

  static const visiblePainted = const HitTestVisibility('visiblePainted');
  static const visibleFill = const HitTestVisibility('visibleFill');
  static const visibleStroke = const HitTestVisibility('visibleStroke');
  static const visible = const HitTestVisibility('visible');
  static const painted = const HitTestVisibility('painted');
  static const fill = const HitTestVisibility('fill');
  static const stroke = const HitTestVisibility('stroke');
  static const all = const HitTestVisibility('all');
  static const none = const HitTestVisibility('none');

  String toString() => _str;
}