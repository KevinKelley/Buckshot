// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

part of core_buckshotui_org;

Platform _platform = null;

/**
 * Gets the Buckshot [Platform] set for this runtime session.
 */
Platform get platform => _platform;
/**
 * Sets the Buckshot [Platform] for this runtime session.  The
 * provider may only be set once per session.
 */
set platform(Platform newPlatform){
  if (_platform != null){
    throw 'Presentation provider is already set.';
  }
  _platform = newPlatform;
}

/**
 * A generic callback type definition for presenter event loops.
 */
typedef void EventLoopCallback(num time);

/**
 * Base contract for PAL providers.
 */
abstract class Platform extends FrameworkObject
{
  HashMap<String, EventLoopCallback> workers;
  FrameworkProperty<num> viewportWidth;
  FrameworkProperty<num> viewportHeight;

  String get namespace;

  /** Renders to the given [view] to the current [Platform]. */
  Future<PlatformElement> render(View view);

  /** Initializes the given [element] to the [Platform]. */
  void initElement(PlatformElement element);

  /**
   * Retrieves a template from the given [uri] using platform-supported
   * implementations.
   */
  Future<String> getTemplate(String uri);

  Platform();
}

/**
 * Base contract for objects participating in the PAL.
 */
abstract class PlatformElement
{
  String get namespace;

  /** Fires when the element is loaded in the presentation. */
  FrameworkEvent<EventArgs> loaded;

  /** Fires when element is unloaded from the presentation. */
  FrameworkEvent<EventArgs> unloaded;

  /** Parent object of this object. */
  FrameworkObject parent;

  /**
   * Represents a name identifier for the element.
   *
   * Assigning a name to an element allows it to be found and bound to by other
   * elements.
   */
  FrameworkProperty<String> name;

  /**
   * Represents the data context assigned to the FrameworkElement.
   *
   * Declarative template binding can be used to bind to data context.
   */
  FrameworkProperty<dynamic> dataContext;

  /**
   * Called when the object is loaded into the presentation layer for the
   * first time.
   */
  void onFirstLoad();

  void onLoaded();

  void onUnloaded();

  void initProperties();

  void initEvents();

  void createPrimitive();

  void updateLayout();
}