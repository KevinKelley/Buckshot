// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

part of core_buckshotui_org;

class Presentation<T extends PresentationProvider>
{
  final T provider;

  Presentation(this.provider);


}

abstract class PresentationProvider
{
  static PresentationProvider _provider;

  String get namespace;

  /**
   * Sets the given [provider] as the presentation provider for this instance
   * of Buckshot.  Note that this can only be set once per runtime session.
   */
  static set provider(PresentationProvider provider){
    if (_provider != null){
      throw 'Presentation provider already set.';
    }

    _provider = provider;
  }

  static PresentationProvider get provider => _provider;
}

abstract class PresentationElement
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
  FrameworkProperty<Dynamic> dataContext;

  /**
   * Called when the object is loaded into the presentation layer for the
   * first time.
   */
  abstract void onFirstLoad();
}