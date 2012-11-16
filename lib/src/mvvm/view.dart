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
  PlatformElement _rootElement;
  final Completer _c = new Completer();

  /**
   * Future completes when view is ready (has an element assigned to
   * rootVisual).
   */
  Future<PlatformElement> ready;

  /// Gets the visual root of the view.
  PlatformElement get rootVisual => _rootElement;
  set rootVisual(PlatformElement element) {
    assert(element != null && element is PlatformElement);

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
  View.fromTemplate(String template) {
    _init(template);
  }

  /**
   * Constructs a view from a given template [resourceName].  Depending on
   * what is provided in the string (Uri, or DOM id ['#something']), the
   * [Platform] will attempt to retrieve the resource and deserialize it.
   */
  View.fromResource(String resourceName){
    _init(resourceName);
  }

  void _init(String uriOrTemplate){
    ready = _c.future;

    Template
      .deserialize(uriOrTemplate)
      .then((t) => rootVisual = t);
  }

  /** Constructs a view from a given [element]. */
  View.fromElement(PlatformElement element)
  {
    ready = _c.future;
    rootVisual = element;
  }
}
