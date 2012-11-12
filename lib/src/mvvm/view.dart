part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents a View definition for the framework.
*
* (in the MVVM context of a "view")
*
*/
class View
{
  FrameworkObject _rootElement;
  final Completer _c = new Completer();

  /**
   * Future completes when view is ready (has an element assigned to
   * rootVisual).
   */
  Future<FrameworkObject> ready;

  /// Gets the visual root of the view.
  FrameworkObject get rootVisual => _rootElement;
  set rootVisual(FrameworkObject element) {
    assert(element != null && element is FrameworkObject);

    if (_rootElement != null){
      throw const BuckshotException('View already initialized.');
    }

    _rootElement = element;

    _c.complete(_rootElement);
  }

  View()
  {
    ready = _c.future;
  }

  /**
   * Constructs a view from a given raw [template] string.
   *
   * Future View.ready will complete when the template is loaded.
   */
  View.fromTemplate(String template)
  {
    ready = _c.future;

    Template
      .deserialize(template)
      .then((t) => rootVisual = t);
  }

  /**
   * Constructs a view from a given template [resourceName].  Depending on
   * what is provided in the string (Uri, or DOM id ['#something']), the
   * constructor will retrieve the resource and deserialize it.
   */
  View.fromResource(String resourceName)
  {
    ready = _c.future;

    Template
      .getTemplate(resourceName)
      .chain((template) => Template.deserialize(template))
      .then((t) => rootVisual = t);
  }

  /** Constructs a view from a given [element]. */
  View.from(FrameworkObject element)
  {
    ready = _c.future;
    rootVisual = element;
  }
}
