part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


//TODO does this need to derive from BuckshotObject?

/**
* Represents a binding between two [FrameworkProperty] properties.
*
* ## Usage:
*
* ### Registering a Binding
* {var reference} = new Binding(...);
*
* ### Unregistering a Binding
* bindingReference.unregister();
*/
class Binding
{
  BindingMode bindingMode;
  Binding _twoWayPartner;
  final ValueConverter converter;
  final FrameworkProperty _fromProperty, _toProperty;

  /**
  * Boolean value representing if the binding is set or not.
  *   **This value is set by the framework**.
  */
  bool bindingSet = false;

  /**
  * Instantiates a binding between [fromProperty] and [toProperty],
  *  with an optional [bindingMode] and [converter].
  */
  Binding(
    this._fromProperty,
    this._toProperty,
    {this.bindingMode : BindingMode.OneWay,
    this.converter : const _DefaultConverter()})
  {
    if (_fromProperty == null || _toProperty == null) {
      throw const BuckshotException("Attempted to bind"
        " to/from null FrameworkProperty.");
    }

    //NOTE: circular bindings of same property are not checked
    // Circular bindings are not generally harmful because the
    // property system doesn't fire when values are equivalent
    // There is a case where it may be harmful, when value converters
    // are used to transform the values through the chain...
    if (identical(_fromProperty, _toProperty)) {
      throw const BuckshotException("Attempted to bind"
        " same property together.");
    }

    _registerBinding();
  }

  /**
   * Instantiates a binding between [fromProperty] and [toProperty],
   * with an optional [bindingMode] and [converter].
  *
  * This constructor fails silently if the binding isn't established.
  */
  Binding.loose(
    this._fromProperty,
    this._toProperty,
    {this.bindingMode : BindingMode.OneWay,
    this.converter : const _DefaultConverter()})
  {
    if (_fromProperty == null || _toProperty == null) return;

    //NOTE: circular bindings of same property are not checked
    // Circular bindings are not generally harmful because the property
    // system doesn't fire when values are equivalent
    // There is a case where it may be harmful, when value converters are
    // used to transform the values through the chain...
    if (identical(_fromProperty, _toProperty)) {
      throw const BuckshotException("Attempted to bind"
        " same property together.");
    }

    _registerBinding();
  }

  _registerBinding()
  {
    bindingSet = true;

    if (bindingMode == BindingMode.TwoWay){
      _fromProperty._bindings.add(this);

      //set the other binding, temporarily as a oneway
      //so that it doesn't feedback loop on this function
      Binding other =
          new Binding.loose(
                  _toProperty,
                  _fromProperty,
                  bindingMode: BindingMode.OneWay);
      this._twoWayPartner = other;
      other._twoWayPartner = this;

      //now set it to the proper binding type
      _toProperty
        ._bindings
        .last
        .bindingMode = BindingMode.TwoWay;

    }else{
      _fromProperty._bindings.add(this);

      //fire the new binding for one-way/one-time bindings?  make optional?
      Binding._executeBindingsFor(_fromProperty);
    }
  }

  /**
  * Unregisters the binding between two [FrameworkProperty] properties.
  */
  void unregister()
  {
    if (!bindingSet) return;
    bindingSet = false;
    int i = _fromProperty._bindings.indexOf(this, 0);

    if (i == -1) { throw const BuckshotException("Binding not found"
      " in binding registry when attempting to unregister.");
    }

    _fromProperty._bindings.removeRange(i, 1);

    // remove the peer binding if two-way
    if (bindingMode != BindingMode.TwoWay) return;

    _twoWayPartner.bindingSet = false;

    int pi = _twoWayPartner
                ._fromProperty
                ._bindings
                .indexOf(_twoWayPartner, 0);

    if (pi == -1) { throw const BuckshotException("Two-Way partner binding"
      " not found in binding registry when attempting to unregister.");
    }

    _twoWayPartner._fromProperty._bindings.removeRange(pi, 1);
  }

  static void _executeBindingsFor(FrameworkProperty property)
  {
    if (!property._bindings.isEmpty){
      new Logger('buckshot.pal.html.Binding')
        ..fine('Executing ${property._bindings.length} bindings for property $property');
    }
    property
      ._bindings
      .forEach((binding){
        new Logger('buckshot.pal.html.Binding')
          ..fine('... [$property] setting ${binding._toProperty} to ${binding._fromProperty}}');
          binding._toProperty.value =
              binding.converter.convert(binding._fromProperty.value);

        if (binding.bindingMode == BindingMode.OneTime) {
          binding.unregister();
        }
    });
  }
}


class _DefaultConverter implements ValueConverter
{
  const _DefaultConverter();
  convert(dynamic value, {dynamic parameter}) => value;
}
