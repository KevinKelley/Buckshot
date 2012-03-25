//   Copyright (c) 2012, John Evans & LUCA Studios LLC
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.


/**
* Represents a base class for all visual elements in the framework.
* Generally speaking all elements that render DOM output should derive
* from this class. 
*/
class FrameworkElement extends FrameworkObject {
  FrameworkElement _containerParent;
  FrameworkElement _parent;
  StyleTemplate _style;
  final List<num> _transforms;

  /// Represents a map of [Binding]s that will be bound just before
  /// the element renders to the DOM.
  final HashMap<FrameworkProperty, BindingData> lateBindings;
  
  final HashMap<FrameworkProperty, String> _templateBindings;
  
  final HashMap<String, String> _transitionProperties;
  
  /// Represents the margin [Thickness] area outside the FrameworkElement boundary.
  FrameworkProperty marginProperty;
  /// Represents the width of the FrameworkElement.
  FrameworkProperty widthProperty;
  /// Represents the height of the FrameworkElement.
  FrameworkProperty heightProperty; 
  /// Represents the HTML 'ID' property of the FrameworkElement.
  FrameworkProperty htmlIDProperty;
  /// Represents the maximum width property of the FrameworkElement.
  FrameworkProperty maxWidthProperty; 
  /// Represents the minimum height property of the FrameworkElement.
  FrameworkProperty minWidthProperty;
  /// Represents the maximum height property of the FrameworkElement.
  FrameworkProperty maxHeightProperty;
  /// Represents the minimum height proeprty of the FrameworkElement.
  FrameworkProperty minHeightProperty; 
  /// Represents the shape the cursor will take when passing over the FrameworkElement.
  FrameworkProperty cursorProperty; 
  /// Represents a general use [Object] property of the FrameworkElement.
  FrameworkProperty tagProperty;
  /// Represents the data context assigned to the FrameworkElement.
  /// Declarative xml binding can be used to bind to data context.
  FrameworkProperty dataContextProperty;
  /// Represents the horizontal alignment of this FrameworkElement inside another element.
  FrameworkProperty horizontalAlignmentProperty; 
  /// Represents the [VerticalAlignment] of this FrameworkElement inside another element.
  FrameworkProperty verticalAlignmentProperty;
  /// Represents the html z order of this FrameworkElement in relation to other elements.
  FrameworkProperty zOrderProperty;
  /// Represents the actual adjusted width of the FrameworkElement.
  FrameworkProperty actualWidthProperty;
  /// Represents the actual adjusted height of the FrameworkElement.
  FrameworkProperty actualHeightProperty; 
  /// Represents the opacity value [Double] of the FrameworkElement.
  FrameworkProperty opacityProperty;
  /// Represents the [Visibility] property of the FrameworkElement.
  FrameworkProperty visibilityProperty;
  /// Represents the [StyleTemplate] value that is currently applied to the FrameworkElement.
  FrameworkProperty styleProperty;
  
  FrameworkProperty translateXProperty;
  FrameworkProperty translateYProperty;
  FrameworkProperty translateZProperty;
  FrameworkProperty scaleXProperty;
  FrameworkProperty scaleYProperty;
  FrameworkProperty scaleZProperty;
  FrameworkProperty rotateXProperty;
  FrameworkProperty rotateYProperty;
  FrameworkProperty rotateZProperty;
  FrameworkProperty transformOriginXProperty;
  FrameworkProperty transformOriginYProperty;
  FrameworkProperty transformOriginZProperty;
  FrameworkProperty perspectiveProperty;
  
  //events
  /// Fires when the FrameworkElement is inserted into the DOM.
  final FrameworkEvent<RoutedEventArgs> loaded;
  /// Fires when the FrameworkElement is removed from the DOM.
  final FrameworkEvent<RoutedEventArgs> unloaded;
  /// Fires when the DOM gives the FrameworkElement focus.
  final FrameworkEvent<RoutedEventArgs> gotFocus;
  /// Fires when the DOM removes focus from the FrameworkElement.
  final FrameworkEvent<RoutedEventArgs> lostFocus;
  /// Fires when the mouse enters the boundary of the FrameworkElement.
  final FrameworkEvent<RoutedEventArgs> mouseEnter;
  /// Fires when the mouse leaves the boundary of the FrameworkElement.
  final FrameworkEvent<RoutedEventArgs> mouseLeave;
  /// Fires when the FrameworkElement's size changes.
  final FrameworkEvent<RoutedEventArgs> sizeChanged;
  /// Fires when a mouse click occurs on the FrameworkElement.
  final FrameworkEvent<MouseEventArgs> click;
  /// Fires when the mouse position changes over the FrameworkElement.
  final FrameworkEvent<MouseEventArgs> mouseMove;
  /// Fires when the mouse button changes to a down position while over the FrameworkElement.
  final FrameworkEvent<MouseEventArgs> mouseDown;
  /// Fires when the mouse button changes to an up position while over the FrameworkElement.
  final FrameworkEvent<MouseEventArgs> mouseUp;
  

  //TODO mouseWheel, onScroll;
  
  FrameworkElement() :
    lateBindings = new HashMap<FrameworkProperty, BindingData>(),
    _templateBindings = new HashMap<FrameworkProperty, String>(),
    loaded = new FrameworkEvent<RoutedEventArgs>(),
    unloaded = new FrameworkEvent<RoutedEventArgs>(),
    click = new FrameworkEvent<MouseEventArgs>(),
    gotFocus = new FrameworkEvent<RoutedEventArgs>(),
    lostFocus = new FrameworkEvent<RoutedEventArgs>(),
    mouseEnter = new FrameworkEvent<RoutedEventArgs>(),
    mouseLeave = new FrameworkEvent<RoutedEventArgs>(),
    sizeChanged = new FrameworkEvent<RoutedEventArgs>(),
    mouseMove = new FrameworkEvent<MouseEventArgs>(),
    mouseDown = new FrameworkEvent<MouseEventArgs>(),
    mouseUp = new FrameworkEvent<MouseEventArgs>(),
    _transforms = [50, 50, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0],
    _transitionProperties = new HashMap<String, String>()
  {   
    _Dom.appendBuckshotClass(_component, "frameworkelement");

    _style = new StyleTemplate(); //give a blank style so merging works immediately
    
    _initFrameworkProperties();

    _component.attributes["data-lucaui-element"] = this.type;
    
    _initFrameworkEvents();
  }
  
  static void doTransform(FrameworkElement e){
    _Dom.setXPCSS(
      e._component, 
      'transform', 
      '''translateX(${e._transforms[Transforms.translateX]}px) translateY(${e._transforms[Transforms.translateY]}px) translateZ(${e._transforms[Transforms.translateZ]}px)
         scaleX(${e._transforms[Transforms.scaleX]}) scaleY(${e._transforms[Transforms.scaleY]}) scaleZ(${e._transforms[Transforms.scaleZ]}) 
         rotateX(${e._transforms[Transforms.rotateX]}deg) rotateY(${e._transforms[Transforms.rotateY]}deg) rotateZ(${e._transforms[Transforms.rotateZ]}deg)
      ''');
  }
    
  void _initFrameworkProperties(){

    //TODO: propogate this property in elements that use virtual containers
    perspectiveProperty = new FrameworkProperty(this, "perspective", (num value){
     _Dom.setXPCSS(_component, 'perspective', '${value}'); 
    },converter:const StringToNumericConverter());
    
    translateXProperty = new FrameworkProperty(this, "translateX", (num value){
      _transforms[Transforms.translateX] = value;
      doTransform(this);
    },converter:const StringToNumericConverter());
        
    translateYProperty = new FrameworkProperty(this, "translateY", (num value){
      _transforms[Transforms.translateY] = value;
      doTransform(this);
    },converter:const StringToNumericConverter());
    
    translateZProperty = new FrameworkProperty(this, "translateZ", (num value){
      _transforms[Transforms.translateZ] = value;
      doTransform(this);
    },converter:const StringToNumericConverter());
    
    scaleXProperty = new FrameworkProperty(this, "scaleX", (num value){
      _transforms[Transforms.scaleX] = value;
      doTransform(this);
    },converter:const StringToNumericConverter());
    
    scaleYProperty = new FrameworkProperty(this, "scaleY", (num value){
      _transforms[Transforms.scaleY] = value;
      doTransform(this);
    },converter:const StringToNumericConverter());
    
    scaleZProperty = new FrameworkProperty(this, "scaleZ", (num value){
      _transforms[Transforms.scaleZ] = value;
      doTransform(this);
    },converter:const StringToNumericConverter());
    
    rotateXProperty = new FrameworkProperty(this, "rotateX", (num value){
      _transforms[Transforms.rotateX] = value;
      doTransform(this);
    },converter:const StringToNumericConverter());
    
    rotateYProperty = new FrameworkProperty(this, "rotateY", (num value){
      _transforms[Transforms.rotateY] = value;
      doTransform(this);
    },converter:const StringToNumericConverter());
    
    rotateZProperty = new FrameworkProperty(this, "rotateZ", (num value){
      _transforms[Transforms.rotateZ] = value;
      doTransform(this);
    },converter:const StringToNumericConverter());
        
    transformOriginXProperty = new FrameworkProperty(this, "transformOriginX", (num value){
      _transforms[Transforms.originX] = value;
      _Dom.setXPCSS(this._component, 'transform-origin', '${_transforms[Transforms.originX]}% ${_transforms[Transforms.originY]}% ${_transforms[Transforms.originZ]}px');
    },converter:const StringToNumericConverter());
    
    transformOriginYProperty = new FrameworkProperty(this, "transformOriginY", (num value){
      _transforms[Transforms.originY] = value;
      _Dom.setXPCSS(this._component, 'transform-origin', '${_transforms[Transforms.originX]}% ${_transforms[Transforms.originY]}% ${_transforms[Transforms.originZ]}px');
    },converter:const StringToNumericConverter());
    
    transformOriginZProperty = new FrameworkProperty(this, "transformOriginZ", (num value){
      _transforms[Transforms.originZ] = value;
      _Dom.setXPCSS(this._component, 'transform-origin', '${_transforms[Transforms.originX]}% ${_transforms[Transforms.originY]}% ${_transforms[Transforms.originZ]}px');
    },converter:const StringToNumericConverter());
    
    htmlIDProperty = new FrameworkProperty(
      this,
      "htmlID",
      (String value){
        _component.attributes["ID"] = value;
      });
    
    opacityProperty = new FrameworkProperty(
      this,
      "opacity",
      (value){
        if (value < 0.0) value = 0.0;
        if (value > 1.0) value = 0.1;
        _component.style.opacity = value.toStringAsPrecision(2);
        _component.style.filter = "alpha(opacity=${value * 100})";
      }, 1.0, converter:const StringToNumericConverter());
    
    visibilityProperty = new FrameworkProperty(
      this,
      "visibility",
      (Visibility value){
        if (value._bool){
          _component.style.visibility = "visible";
          
          _component.style.display =  _stateBag["display"] == null ? "inherit" : _stateBag["display"];
          _stateBag.remove("display");            
        }else{
          //preserve in case some element is using "inline" or some other fancy display value
          _stateBag["display"] = _component.style.getPropertyValue("display");
          
          _component.style.visibility = "hidden";
          
          _component.style.display = "none";
        }
      }, Visibility.visible);
    
    zOrderProperty = new FrameworkProperty(
      this,
      "zOrder",
      (value){
        _component.style.zIndex = value.toString(); //, null);
      }, converter:const StringToNumericConverter());
    
    marginProperty = new FrameworkProperty(
      this,
      "margin",
      (value){
        _component.style.margin = '${value.top}px ${value.right}px ${value.bottom}px ${value.left}px'; //, null);
        //if (_useOffsetWidthAndHeight) _computeWHOffset();
        //db("...margin - offsetX: ${whOffset.first}, offsetY ${whOffset.second}", this);
      }, new Thickness(0), converter:const StringToThicknessConverter());
    
    actualWidthProperty = new FrameworkProperty(
      this,
      "actualWidth",
      (int value){}, 0, converter:const StringToNumericConverter());
    
    actualHeightProperty = new FrameworkProperty(
      this,
      "actualHeight",
      (int value){}, 0, converter:const StringToNumericConverter());
    
    widthProperty = new FrameworkProperty(
      this,
      "width",
      (Dynamic value) => calculateWidth(value), "auto", converter:const StringToNumericConverter());
    
    heightProperty = new FrameworkProperty(
      this,
      "height",
      (Dynamic value) => calculateHeight(value), "auto", converter:const StringToNumericConverter());
    
    minHeightProperty = new FrameworkProperty(
      this,
      "minHeight",
      (value){
//        
//        if (height == "auto"){
//          _component.style.minHeight = '${value}px';
//          return;
//        }
//        
//        if (maxHeight != null && value > maxHeight){
//           minHeight = maxHeight;
//          _component.style.minHeight = '${minHeightProperty.value}px';
//          return;
//        }
//        
//        if (height != null && height < value){
//          height = value;
//        }

        _component.style.minHeight = '${value}px';
      }, converter:const StringToNumericConverter());
    
    maxHeightProperty = new FrameworkProperty(
      this,
      "maxHeight",
      (value){
//        
//        if (height == "auto"){
//          _component.style.maxHeight = '${value}px';
//          return;
//        }
//        
//        if (minHeight != null && value < minHeight){
//          maxHeight = minHeight;
//          _component.style.maxHeight = '${maxHeightProperty.value}px';
//          return;
//        }
//        
//        if (height != null && height > value)
//          height = value;
        
        _component.style.maxHeight = '${value}px';
      }, converter:const StringToNumericConverter());
    
    minWidthProperty = new FrameworkProperty(
      this,
      "minWidth",
      (value){
//        
//        if (width == "auto"){
//          _component.style.minWidth = '${value}px';
//          return;
//        }
//        
//        if (maxWidth != null && value > maxWidth){
//          minWidth = maxWidth;
//          _component.style.minWidth = '${minWidthProperty.value}px';
//          return;
//        }
//        
//        if (width != null && width < value)
//          width = value;
        
        _component.style.minWidth = '${value}px';
      }, converter:const StringToNumericConverter());
    
    maxWidthProperty = new FrameworkProperty(
      this,
      "maxWidth",
      (value){
//        
//        if (width == "auto"){
//          _component.style.maxWidth = '${value}px';
//          return;
//        }
//        
//        if (minWidth != null && value < minWidth){
//          maxWidth = minWidth;
//          _component.style.maxWidth = '${maxWidthProperty.value}px';
//          return;
//        }
//        
//        if (width != null && width > value)
//          width = value;
        
        _component.style.maxWidth = '${value}px';
      }, converter:const StringToNumericConverter());
    
    cursorProperty = new FrameworkProperty(
      this,
      "cursor",
      (Cursors value){
        _component.style.cursor = value._str;
      }, converter:const StringToCursorConverter());
    
    tagProperty = new FrameworkProperty(
      this,
      "tag",
      (value){});
    
    dataContextProperty = new FrameworkProperty(
      this,
      "dataContext",
      (value){});
        
    horizontalAlignmentProperty = new FrameworkProperty(
      this,
      "horizontalAlignment",
      (HorizontalAlignment value){
        updateLayout();
      }, 
      HorizontalAlignment.left, converter:const StringToHorizontalAlignmentConverter());
    
    verticalAlignmentProperty = new FrameworkProperty(
      this,
      "verticalAlignment",
      (VerticalAlignment value){
        updateLayout();
      }, 
      VerticalAlignment.top, converter:const StringToVerticalAlignmentConverter());
    
    styleProperty = new FrameworkProperty(
      this,
      "style",
      (StyleTemplate value){
        if (value == null){
          //setting non-null style to null
          _style._unregisterElement(this);
          styleProperty._previousValue = _style;
          _style = new StyleTemplate();
          styleProperty.value = _style;
        }else{
          //replacing style with style
          if (_style != null) _style._unregisterElement(this);
          value._registerElement(this);
          _style = value;
        }
      }, new StyleTemplate());
  }
     
  /** 
  Properties
  */

  /// Gets the [styleProperty] value.
  StyleTemplate get style() => getValue(styleProperty);
  /// Sets the [styleProperty] value.
  set style(StyleTemplate value) => setValue(styleProperty, value);
  
  // FIX
  /// Gets the inner width value.
  int get innerWidth() => 0; //_rawElement.clientWidth - (margin.left + margin.right);
  /// Gets the inner height value.
  int get innerHeight() => 0; //_rawElement.clientHeight - (margin.top + margin.bottom);
  
  /// Gets the inner width of the element less any bordering offsets (margin, padding, borderThickness)
  int get actualWidth() => getValue(actualWidthProperty);
  
  /// Gets the inner height of the element less any bordering offsets (margin, padding, borderThickness)
  int get actualHeight() => getValue(actualHeightProperty);
  
  /// Gets the raw html Element component of the Framework Element.
  Element get component() => _component;
  /// Sets the raw html Element component of the Framework Element.
  set component(Element value) => _component = value;
  
  /// Sets the parent FrameworkElement.
  set parent(FrameworkElement value) => _parent = value;
  /// Gets the parent FrameworkElement.
  FrameworkElement get parent() => _parent;
  
  /// Sets the [htmlIDProperty] value.
  set htmlID(String value) => setValue(htmlIDProperty, value);
  /// Gets the [htmlIDProperty] value.
  String get htmlID() => getValue(htmlIDProperty);
  
  /// Sets the [opacityProperty] value.
  set opacity(double value) => setValue(opacityProperty, value);
  /// Gets the [opacityProperty] value.
  double get opacity() => getValue(opacityProperty);
  
  /// Sets the [visibilityProperty] value.
  set visibility(Visibility value) => setValue(visibilityProperty, value); 
  /// Gets the [visibilityProperty] value.
  Visibility get visibility() => getValue(visibilityProperty);
  
  /// Sets the [zOrderProperty] value.
  set zOrder(int value) => setValue(zOrderProperty, value);
  /// Gets the [zOrderProperty] value.
  int get zOrder() => getValue(zOrderProperty);
  
  /// Sets the [dataContextProperty] value.
  set dataContext(Dynamic value) => setValue(dataContextProperty, value);
  /// Gets the [dataContextProperty] value.
  Dynamic get dataContext() => getValue(dataContextProperty);
  
  /// Sets the [tagProperty] value.
  set tag(Dynamic value) => setValue(tagProperty, value);
  /// Gets the [tagProperty] value.
  Dynamic get tag() => getValue(tagProperty);
  
  /// Sets the [marginProperty] value.
  set margin(Thickness value) => setValue(marginProperty, value);
  /// Gets the [marginProperty] value.
  Thickness get margin() => getValue(marginProperty);
  
  /// Sets the [widthProperty] value.
  set width(Dynamic value) => setValue(widthProperty, value);
  /// Gets the [widthProperty] value.
  Dynamic get width() => getValue(widthProperty);
  
  /// Sets the [heightProperty] value.
  set height(Dynamic value) => setValue(heightProperty, value);
  /// Gets the [heightProperty] value.
  Dynamic get height() => getValue(heightProperty);
  
  /// Sets the [minWidthProperty] value.
  set minWidth(num value) => setValue(minWidthProperty, value);
  /// Gets the [minWidthProperty] value.
  num get minWidth() => getValue(minWidthProperty);
  
  /// Sets the [maxWidthProperty] value.
  set maxWidth(num value) => setValue(maxWidthProperty, value);
  /// Gets the [maxWidthProperty] value.
  num get maxWidth() => getValue(maxWidthProperty);
  
  /// Sets the [minHeightProperty] value.
  set minHeight(num value) => setValue(minHeightProperty, value);
  /// Gets the [minHeightProperty] value.
  num get minHeight() => getValue(minHeightProperty);
  
  /// Sets the [maxHeightProperty] value.
  set maxHeight(num value) => setValue(maxHeightProperty, value);
  /// Gets the [maxHeightProperty] value.
  num get maxHeight() => getValue(maxHeightProperty);
  
  /// Sets the [cursorProperty] value.
  set cursor(Cursors value) => setValue(cursorProperty, value);
  /// Gets the [cursorProperty] value.
  Cursors get cursor() => getValue(cursorProperty);
  
  /// Sets the [verticalAlignmentProperty] value.
  set verticalAlignment(VerticalAlignment value) => setValue(verticalAlignmentProperty, value);
  /// Gets the [verticalAlignmentProperty] value.
  VerticalAlignment get verticalAlignment() => getValue(verticalAlignmentProperty);
   
  /// Sets the [horizontalAlignmentProperty] value.
  set horizontalAlignment(HorizontalAlignment value) => setValue(horizontalAlignmentProperty, value);
  /// Gets the [horizontalAlignmentProperty] value.
  HorizontalAlignment get horizontalAlignment() => getValue(horizontalAlignmentProperty);
  
  ElementRect mostRecentMeasurement;
  
  void updateMeasurement(){
    _component
      .rect
      .then((ElementRect r) { mostRecentMeasurement = r;});
  }
  
  /*
  ** Methods
  */
  
  
  //TODO Async?
  
  ///
  /// Returns the first non-null [dataContext] [FrameworkProperty]
  /// in the this [FrameworkElement]'s heirarchy.
  ///
  /// Returns null if no non-null [dataContext] can be found.
  FrameworkProperty resolveDataContext(){
    if (dataContext != null) return dataContextProperty;
    if (parent == null) return null;
    return parent.resolveDataContext();
  }
  
  bool _dataContextUpdated = false;
  void updateDataContext(){
    if (_dataContextUpdated) return;
    _dataContextUpdated = true;
    
    //TODO: Support multiple datacontext updates
    
    var dc = resolveDataContext();
    if (dc == null) return;
    
    //binding each property in the lateBindings collection
    //to the data context
    lateBindings.forEach((FrameworkProperty p, BindingData bd){
      if (bd.dataContextPath == ""){
        new Binding(dc, p);
      }else{
        if (!(dc.value is BuckshotObject))
          throw new FrameworkException("Datacontext binding attempted to resolve properties '${bd.dataContextPath}' on non-BuckshotObject type.");
        
        //TODO keep a reference to these so they can be removed if the datacontext changes
        
        if (bd.converter != null)
          new Binding(dc.value.resolveProperty(bd.dataContextPath), p, bindingMode:bd.bindingMode, converter:bd.converter);
        else
          new Binding(dc.value.resolveProperty(bd.dataContextPath), p, bindingMode:bd.bindingMode);
      } 
    });
  }
  
  /// ** Internal Use Only **
  void calculateWidth(int value){
    if (value == "auto"){
      _component.style.width = "auto"; //, null);
      setValue(actualWidthProperty, innerWidth);
      if (this is Panel) updateLayout();
      return;
    }
        
    if (minWidth != null && value < minWidth){
      width = minWidth;
    }
    
    if (maxWidth != null && value > maxWidth){
      width = maxWidth;
    }

    int adjustedValue = value - (margin.left + margin.right);
    _component.style.width = '${adjustedValue}px';
    setValue(actualWidthProperty, adjustedValue);
    if (this is Panel) updateLayout();
    
  }
  
  /// ** Internal Use Only **
  void calculateHeight(int value){
    if (value == "auto"){
      _component.style.height = "auto";//, null);
      setValue(actualHeightProperty, innerHeight);
      if (this is Panel) updateLayout();
      return;
    }
        
    if (minHeight != null && value < minHeight){
      height = minHeight;
    }
    
    if (maxHeight != null && value > maxHeight){
      height =  maxHeight;
    }
    
    int adjustedValue = value - (margin.top + margin.bottom);
    _component.style.height = '${adjustedValue}px'; //, null);
    setValue(actualHeightProperty, adjustedValue);
    if (this is Panel) updateLayout();
  }
  
  //TODO load/unload should be asynchronous
  void addToLayoutTree(FrameworkElement parentElement){

    parentElement._component.elements.add(_component);
    
    parent = parentElement;
    
   // db('Added to Layout Tree', this);
    if (!parentElement._isLoaded) return;
       
    _onAddedToDOM();
  }
  
  void _onAddedToDOM(){
    //parent is in the DOM so we should call loaded event and check for children
        
    updateDataContext();
       
    _isLoaded = true;
    
    updateLayout();

    onLoaded();
    loaded.invoke(this, new EventArgs());
    
    //db('Added to DOM', this);
    
    if (this is! IFrameworkContainer) return;
    
    if (this.dynamic.content is List){
      this.dynamic.content.forEach((FrameworkElement child) => child._onAddedToDOM());    
    }else if (this.dynamic.content is FrameworkElement){
      this.dynamic.content._onAddedToDOM();
    }
  }
  
  void onLoaded(){}
  void onUnloaded(){}
  
  void removeFromLayoutTree(){
  //    throw new FrameworkException('Attempted to remove element that is not already loaded into the DOM.');
    
    this._component.remove();
    
    //db('Removed from Layout Tree', this);
    var p = parent;
    
    parent = null;
    
    if (!p._isLoaded) return;
    
    _onRemoveFromDOM();
  }
  
  _onRemoveFromDOM(){
    _isLoaded = false;

    onUnloaded();
    unloaded.invoke(this, new EventArgs());
    
    //db('Removed from DOM', this);
    
    if (this is! IFrameworkContainer) return;
       
    if (this.dynamic.content is List){
      this.dynamic.content.forEach((FrameworkElement child) => child._onRemoveFromDOM());    
    }else if (this.dynamic.content is FrameworkElement){
      this.dynamic.content._onRemoveFromDOM();
    }
  }
  
  
  void _initFrameworkEvents(){
        
    _component.on.mouseUp.add((e){
      if (!mouseUp.hasHandlers) return;

      _component.rect.then((ElementRect r){
          int x = (e.pageX - r.offset.left);
          int y = (e.pageY - r.offset.top);
          MouseEventArgs args = new MouseEventArgs(x, y, e.pageX, e.pageY);
          mouseUp.invoke(this, args);
      });
        
        
      if (e.cancelable) e.cancelBubble = true;
    });

    _component.on.mouseDown.add((e){
      if (!mouseDown.hasHandlers) return;
           
        _component.rect.then((ElementRect r){
          int x = (e.pageX - r.offset.left);
          int y = (e.pageY - r.offset.top);
          mouseDown.invoke(this, new MouseEventArgs(x, y, e.pageX, e.pageY));
        });
        
      if (e.cancelable) e.cancelBubble = true;
    });
    
    _component.on.mouseMove.add((e) {
      if (!mouseMove.hasHandlers) return;
                 
      _component.rect.then((ElementRect r){
        int x = (e.pageX - r.offset.left);
        int y = (e.pageY - r.offset.top);
        mouseMove.invoke(this, new MouseEventArgs(x, y, e.pageX, e.pageY));
      });
     
      if (e.cancelable) e.cancelBubble = true;
    });
    
    _component.on.click.add((e) {
      if (!click.hasHandlers) return;
      // FIX
      _component.rect.then((ElementRect r){
        int x = (e.pageX - r.offset.left);
        int y = (e.pageY - r.offset.top);
        click.invoke(this, new MouseEventArgs(x, y, e.pageX, e.pageY));
      });
      
      if (e.cancelable) e.cancelBubble = true;  
    });

    _component.on.focus.add((e){
      if (!gotFocus.hasHandlers) return;
      
      gotFocus.invoke(this, new EventArgs());
      
      if (e.cancelable) e.cancelBubble = true;
    });

    _component.on.blur.add((e){
      if (!lostFocus.hasHandlers) return;

      lostFocus.invoke(this, new EventArgs());
      
      if (e.cancelable) e.cancelBubble = true;
    });
    
    _component.on.mouseOver.add((e){
      if (!mouseEnter.hasHandlers) return;
      
      mouseEnter.invoke(this, new EventArgs());
      
      if (e.cancelable) e.cancelBubble = true;
    });

    _component.on.mouseOut.add((e){
      if (!mouseLeave.hasHandlers) return;
      
      mouseLeave.invoke(this, new EventArgs());
      
      if (e.cancelable) e.cancelBubble = true;
    });
    
  }
  
  bool _isPropertySet(String property){
    if (_component == null) return false;
    
    if (_component.style.getPropertyValue(property) == null) return false;
    
    return true;
  }    
  
  /// Overridden [FrameworkObject] method.
  void CreateElement(){
    _component = _Dom.createByTag("div");
  }
  
  /// Overridden [FrameworkObject] method.
  updateLayout(){}
  
  String get type() => "FrameworkElement";
}
