part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Provides serialization/deserialization for XML format templates.
*/
class XmlTemplateProvider implements IPresentationFormatProvider
{
  @override
  bool isFormat(String template) => template.startsWith('<');

  @override
  String serialize(FrameworkObject elementRoot){
    throw new UnsupportedError('Serialization not yet supported.');
  }

  @override
  XmlElement toXmlTree(String template){
    return XML.parse(template);
  }
}
