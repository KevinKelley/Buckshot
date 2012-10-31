part of core_buckshotui_org;


/** Deprecated: Derive directly from BuckshotObject instead. */
@deprecated class TemplateObject extends BuckshotObject
{
  TemplateObject();
  TemplateObject.register() : super.register();
  makeMe() => null;

  @override void initProperties(){}
  @override void initEvents(){}
}
