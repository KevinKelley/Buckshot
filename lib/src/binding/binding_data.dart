part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class BindingData
{
  final String dataContextPath;
  final ValueConverter converter;
  final BindingMode bindingMode;
  
  BindingData(this.dataContextPath, this.converter, this.bindingMode);
}
