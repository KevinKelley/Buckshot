
class ImageImpl extends ImagePrimitive implements HtmlPrimitive
{
  final Element rawElement = new ImageElement();

  set alt(String value){
    super.alt = value;
    rawElement.attributes['alt'] = '$value';
  }

  set uri(String value){
    super.uri = value;
    rawElement.attributes['src'] = '$value';
  }

  set margin(Thickness value){
    super.margin = value;

    rawElement.style.margin =
      '${value.top}px ${value.right}px ${value.bottom}px ${value.left}px';
  }

  set width(num value) {
    super.width = value;
    rawElement.style.width = '${value}px';
  }

  set height(num value) {
    super.height = value;
    rawElement.style.height = '${value}px';
  }
}
