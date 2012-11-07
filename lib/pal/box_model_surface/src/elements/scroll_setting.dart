part of box_model_surface_buckshot;

/**
 * Enumerates supported scroll setting values.
 */
class ScrollSetting
{
  final String _str;

  const ScrollSetting(this._str);

  static const visible = const ScrollSetting('scroll');
  static const hidden = const ScrollSetting('hidden');
  static const auto = const ScrollSetting('scroll');

  String toString() => _str;
}


class StringToScrollSettingConverter implements ValueConverter
{

  const StringToScrollSettingConverter();

  @override dynamic convert(dynamic value, {dynamic parameter}){
    if (value is! String) return value;

    switch(value){
      case 'visible':
        return ScrollSetting.visible;
      case 'hidden':
        return ScrollSetting.hidden;
      case 'auto':
        return ScrollSetting.auto;
      default:
        throw "Invalid ScrollSetting value for conversion.";
    }
  }
}