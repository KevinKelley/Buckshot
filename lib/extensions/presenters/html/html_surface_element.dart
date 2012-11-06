part of html_surface_buckshot;

abstract class HtmlSurfaceElement implements BoxModelSurfaceElement
{
  Element rawElement;

  static void setStyleProperty(HtmlSurfaceElement element,
                               String property, String value) =>
    element.rawElement.style.setProperty(property, value);
}
