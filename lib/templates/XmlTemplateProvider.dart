// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

//TODO event handlers (waiting for reflection)

/**
* Provides serialization/deserialization for XML format templates.
*/
class XmlTemplateProvider implements IPresentationFormatProvider {

  final Miriam miriam;

  XmlTemplateProvider()
      :
        miriam = new Miriam();

  //TODO MIME as identifier type instead?
  String get fileExtension() => "xml";

  bool isFormat(String template) => template.startsWith('<');

  Future<FrameworkElement> deserialize(String templateXML){
    final c = new Completer();

    _getNextElement(XML.parse(templateXML)).then((e) => c.complete(e));

    return c.future;
  }

  Future<FrameworkObject> _getNextElement(XmlElement xmlElement){

    final c = new Completer();

    String lowerTagName = xmlElement.name.toLowerCase();

//    if (!buckshot._objectRegistry.containsKey(lowerTagName))
//      throw new PresentationProviderException('Element "${lowerTagName}"'
//      ' not found in object registry.');

    void completeElementParse(element){
      if (element is FrameworkResource){
        element.rawData = xmlElement.toString();
        _processResource(element);
        // complete nodes as null; they aren't added to the DOM
        c.complete(null);
      }else{
        c.complete(element);
      }
    }

    void processProperty(ofElement, ofXMLNode){
      final String elementLowerTagName = ofXMLNode.name.toLowerCase();

      //property node

      FrameworkProperty p = ofElement.resolveProperty(elementLowerTagName);
      if (p == null) throw new PresentationProviderException("Property node"
          " name '${elementLowerTagName}' is not a valid"
          " property of '${lowerTagName}'.");

      if (elementLowerTagName == "itemstemplate"){
        //accomodation for controls that use itemstemplates...
        if (ofXMLNode.children.length != 1){
          throw const PresentationProviderException('ItemsTemplate'
          ' can only have a single child.');
        }
        // defer parsing of the template xml, the template
        // iterator should handle later.
        setValue(p, ofXMLNode.children[0].toString());
      }else{

        var testValue = getValue(p);

        if (testValue != null && testValue is List){
          //complex property (list)
          for (final se in ofXMLNode.children){
            testValue.add(_getNextElement(se));
          }
        }else if (ofXMLNode.text.trim().startsWith("{")){

          //binding or resource
          _resolveBinding(p, ofXMLNode.text.trim());
        }else{
          //property node

          if (ofXMLNode.children.isEmpty()){
            //assume text assignment
            setValue(p, ofXMLNode.text.trim());
          }else{
            if (ofXMLNode.children.every((n) => n is XmlText)){
              // text assignment to property
              setValue(p, ofXMLNode.text.trim());
            }else if (ofXMLNode.children.length == 1 &&
                ofXMLNode.children[0] is! XmlText){

              // node assignment to property
              setValue(p, _getNextElement(ofXMLNode.children[0]));
            }
          }
        }
      }
    }

    void processTag(ofElement, ofXMLNode){
      final String elementLowerTagName = ofXMLNode.name.toLowerCase();

      if (ofXMLNode.name.contains(".")){
        //attached property
        Function setAttachedPropertyFunction =
            buckshot._objectRegistry[elementLowerTagName];

        //no data binding for attached properties
        setAttachedPropertyFunction(ofElement,
            Math.parseInt(ofXMLNode.text.trim()));
      }else{
        //element or resource

        if (!ofElement.isContainer)
          throw const PresentationProviderException("Attempted to add"
          " element to another element which is not a container.");

        var cc = ofElement.stateBag[FrameworkObject.CONTAINER_CONTEXT];

        FrameworkObject childElement = _getNextElement(ofXMLNode);

        if (childElement == null) return; // is a resource

        //CONTAINER_CONTEXT is a FrameworkProperty for single element, List for multiple
        if (cc is List){
          //list content
          cc.add(childElement);
        }else{
          // single child (previous child will be overwritten
          // if multiple are provided)
          //TODO throw on multiple child element nodes
          setValue(cc, childElement);
        }
      }
    }

    void processTextNode(ofElement, ofXMLNode){
      if (ofXMLNode.text.trim() != ""){
        if (!ofElement.isContainer)
          throw const PresentationProviderException("Text node found in element"
          " which does not have a container context defined.");

        var cc = ofElement.stateBag[FrameworkObject.CONTAINER_CONTEXT];

        if (cc is List) throw const PresentationProviderException("Expected"
        " container context to be property.  Found list.");

        setValue(cc, ofXMLNode.text.trim());
      }
    }

    buckshot
      .createByName(lowerTagName)
      .then((newElement){
         if (newElement == null){
           c.completeException(
               new PresentationProviderException('Element "${xmlElement.name}"'
           ' not found.'));
           return;
         }

     if (xmlElement.children.length > 0 &&
         xmlElement.children.every((n) => n is! XmlText)){
       //process nodes

       for(final e in xmlElement.children.dynamic){
         String elementLowerTagName = e.name.toLowerCase();

         if (miriam.getObjectByName(elementLowerTagName) != null){
//         if (buckshot._objectRegistry.containsKey(elementLowerTagName)){
            processTag(newElement, e);
         }else{
            processProperty(newElement, e);
         }
       }
     }else{
       //no nodes, check for text element
       processTextNode(newElement, xmlElement);
     }

     _assignAttributeProperties(newElement, xmlElement);

     completeElementParse(newElement);

   });


    return c.future;
  }





  void _resolveBinding(FrameworkProperty p, String binding){
    if (!binding.startsWith("{") || !binding.endsWith("}"))
      throw const PresentationProviderException('Binding must begin with'
        ' "{" and end with "}"');

    FrameworkProperty placeholder =
        new FrameworkProperty(null, "placeholder",(_){});

    String stripped = binding.substring(1, binding.length - 1);

    BindingMode mode = BindingMode.OneWay;
    IValueConverter vc = null;

    //TODO support converters...
    var params = stripped.split(',');

    var words = params[0].trim().split(' ');

    if (params.length > 1 && words[0] != "template"){
      params
        .getRange(1, params.length - 1)
        .forEach((String param){
          String lParam = param.trim().toLowerCase();
          if (lParam.startsWith('mode=') || lParam.startsWith('mode =')){
            var modeSplit = lParam.split('=');
            if (modeSplit.length == 2){
              switch(modeSplit[1]){
                case "twoway":
                    mode = BindingMode.TwoWay;
                  break;
                case "onetime":
                    mode = BindingMode.OneTime;
                  break;
              }
            } //TODO: else throw?

          }
          else if (lParam.startsWith('converter=')
              || lParam.startsWith('converter ='))
          {
            var converterSplit = lParam.split('=');

            if (converterSplit.length == 2
                && converterSplit[1].startsWith('{resource ')
                && converterSplit[1].endsWith('}')){
              _resolveBinding(placeholder, converterSplit[1]);
              var testValueConverter = getValue(placeholder);
              if (testValueConverter is IValueConverter)
                vc = testValueConverter;
            } //TODO: else throw?
          }
        });
    }

    switch(words[0]){
      case "resource":
        if (words.length != 2)
          throw const PresentationProviderException('Binding'
            ' syntax incorrect.');

        setValue(p, buckshot.retrieveResource(words[1]));
        break;
      case "template":
        if (words.length != 2)
          throw const BuckshotException('{template} bindings must contain a'
            ' property name parameter: {template [propertyName]}');

          p.sourceObject.dynamic._templateBindings[p] = words[1];
        break;
      case "data":
        if (!(p.sourceObject is FrameworkElement)){
          throw const PresentationProviderException('{data...} binding only'
            ' supported on types that derive from FrameworkElement.');
        }

        switch(words.length){
          case 1:
            //dataContext directly
            p.sourceObject.dynamic.lateBindings[p] =
                new BindingData("", null, mode);
            break;
          case 2:
            //dataContext object via property resolution
            p.sourceObject.dynamic.lateBindings[p] =
                new BindingData(words[1], null, mode);
            break;
          default:
            throw const PresentationProviderException('Binding'
              ' syntax incorrect.');
        }
        break;
      case "element":
        if (words.length != 2)
          throw const PresentationProviderException('Binding'
            ' syntax incorrect.');

        if (words[1].contains(".")){
          var ne = words[1].substring(0, words[1].indexOf('.'));
          var prop = words[1].substring(words[1].indexOf('.') + 1);

          if (!buckshot.namedElements.containsKey(ne))
            throw new PresentationProviderException("Named element '${ne}'"
            " not found.");

          Binding b;
          try{
            new Binding(buckshot.namedElements[ne].resolveProperty(prop),
              p, bindingMode:mode);
          }catch (Exception err){
            //try to bind late...
            FrameworkProperty theProperty =
                buckshot.namedElements[ne].resolveFirstProperty(prop);
            theProperty.propertyChanging + (_, __) {

              //unregister previous binding if one already exists.
              if (b != null) b.unregister();

              b = new Binding(buckshot.namedElements[ne].resolveProperty(prop),
                p, bindingMode:mode);
            };
          }


        }else{
          throw const PresentationProviderException("Element binding requires"
            " a minimum named element/property"
            " pairing (usage '{element name.property}')");
        }
        break;
      default:
        throw const PresentationProviderException('Binding syntax incorrect.');
    }
  }

  void _processResource(FrameworkResource resource){
    //ignore the collection object, the resources will come here anyway
    //TODO: maybe support merged resource collections in the future...
    if (resource is ResourceCollection) return;

    if (resource.key.isEmpty())
      throw const PresentationProviderException("Resource is missing"
        " a key identifier.");

    //add/replace resource at given key
    buckshot.registerResource(resource);
  }

  void _assignAttributeProperties(BuckshotObject element,
                                  XmlElement xmlElement){

    if (xmlElement.attributes.length == 0) return;

    xmlElement.attributes.forEach((String k, String v){

      if (k.contains(".")){
        var prop = k.toLowerCase();
        //attached property
        if (buckshot._objectRegistry.containsKey(prop)){

          Function setAttachedPropertyFunction = buckshot._objectRegistry[prop];

          setAttachedPropertyFunction(element, v);
        }
      }else{
        //property
        FrameworkProperty p = element.resolveProperty(k);

        if (p == null) return; //TODO throw?

        if (v.trim().startsWith("{")){
          //binding or resource
          _resolveBinding(p, v.trim());
        }else{
          //value or enum (enums converted at property level
          //via FrameworkProperty.stringToValueConverter [if assigned])
            setValue(p, v);
        }
      }
    });
  }

  String serialize(FrameworkElement elementRoot){
    throw const NotImplementedException();
  }
}
