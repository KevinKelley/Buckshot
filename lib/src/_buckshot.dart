part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* A general utility service for the Buckshot framework.
*
* ## Deprecated ##
* This class will be removed once mirrors are supported by dart2js.
*/
@deprecated class _buckshot extends FrameworkObject
{
  // Wrappers to prevent propagation of static warnings elsewhere.
  reflectMe(object) => reflect(object);
  get mirrorSystem => currentMirrorSystem();

}