part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.
/**
* A base class for brush objects. */
class Brush extends FrameworkResource
{
  Brush();
  Brush.register() : super.register();
  @override makeMe() => null;
}