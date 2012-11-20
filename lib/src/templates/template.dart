part of core_buckshotui_org;

/**
 * A template is a **non-visual** element that contains a single root visual
 * element.  Though not required, it is recommended to use this element as
 * the root of any Buckshot Template, so that namespace declarations are in
 * scope for the entire template.
 *
 * The template element itself will never be returned by the template parser.
 * Instead the parser will return the root element within the template.
 *
 * ## Example Usage (in the HTML Platform) ##
 *     <template
 *       xmlns='http://www.buckshotui.org/platform/html'
 *       xmlns:custom='http://www.buckshotui.org/customcontrols'>
 *
 *       <stack>
 *         <textblock text='hello world' />
 *         <!-- declare a control from the 'custom' namespace -->
 *         <custom:clock time='auto'></custom:clock>
 *       </stack>
 *     </template>
 */
class Template extends FrameworkObject implements FrameworkContainer
{
  /**
   * A property that represents the root [FrameworkObject] of the template. */
  FrameworkProperty<FrameworkObject> rootVisual;

  Template.register() : super.register();
  Template(){
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = rootVisual;
  }
  @override makeMe() => new Template();

  @override initProperties(){
    super.initProperties();
    rootVisual = new FrameworkProperty(this, 'rootVisual');
  }

  @override get containerContent => rootVisual.value;
}

