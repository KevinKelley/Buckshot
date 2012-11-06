// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

part of core_buckshotui_org;

Presenter _presenter = null;

/**
 * Gets the Buckshot [Presenter] set for this runtime session.
 */
Presenter get presenter => _presenter;
/**
 * Sets the Buckshot [Presenter] for this runtime session.  The
 * provider may only be set once per session.
 */
set presenter(Presenter newProvider){
  if (_presenter != null){
    throw 'Presentation provider is already set.';
  }
  _presenter = newProvider;
}

/**
 * Base contract for PAL providers.
 */
abstract class Presenter
{
  String get namespace;

  /** Initializes the given [element] to the [Presenter]. */
  void initElement(PresenterElement element);
}

/**
 * Base contract for objects participating in the PAL.
 */
abstract class PresenterElement
{
  /** Fires when the element is loaded in the presentation. */
  FrameworkEvent<EventArgs> loaded;

  /** Fires when element is unloaded from the presentation. */
  FrameworkEvent<EventArgs> unloaded;

  /** Parent object of this object. */
  FrameworkObject parent;

  /// Represents a name identifier for the element.
  /// Assigning a name to an element
  /// allows it to be found and bound to by other elements.
  FrameworkProperty<String> name;

  /// Represents the data context assigned to the FrameworkElement.
  /// Declarative xml binding can be used to bind to data context.
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