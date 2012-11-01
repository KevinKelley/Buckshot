part of core_buckshotui_org;


/** Deprecated: Derive directly from FrameworkObject instead. */
@deprecated class TemplateObject extends FrameworkObject
{
  TemplateObject();
  TemplateObject.register() : super.register();
  makeMe() => null;

  @override void initProperties(){}
  @override void initEvents(){}
}
