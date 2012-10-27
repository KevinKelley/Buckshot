// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

part of core_buckshotui_org;

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

  static get provider => _provider;
}