// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

library dockpanel_control_extensions_buckshot;

import 'dart:html';
import 'package:buckshot/extensions/platforms/html/html_platform.dart';

/**
 * A panel element that supports docking of child elements within it.
 */
class DockPanel extends Control implements FrameworkContainer
{
  static AttachedFrameworkProperty dockProperty;

  FrameworkProperty<bool> fillLast;
  FrameworkProperty<Brush> background;

  final ObservableList<HtmlPlatformElement> children =
      new ObservableList<HtmlPlatformElement>();

  DockPanel()
  {
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = children;
  }

  DockPanel.register() : super.register()
  {
    registerAttachedProperty('dockpanel.dock', DockPanel.setDock);
  }
  makeMe() => new DockPanel();

  @override void initEvents(){
    super.initEvents();

    children.listChanged + onChildrenChanging;
  }

  @override void initProperties(){
    super.initProperties();

    fillLast = new FrameworkProperty(this, 'fillLast',
      defaultValue: true,
      converter:const StringToBooleanConverter());

    background = new FrameworkProperty(this, 'background',
        propertyChangedCallback: (Brush brush) {
          HtmlPlatformElement.setBackgroundBrush(this, brush);
        },
        converter: const StringToSolidColorBrushConverter());
  }

  get containerContent => children;

  void onChildrenChanging(sender, ListChangedEventArgs args){
    if (!isLoaded) return;
    args.newItems.forEach((item){
      item.parent = this;
    });

    args.oldItems.forEach((item){
      item.parent = null;
    });
    invalidate();
  }

  @override void createPrimitive(){
    rawElement = new DivElement();
    rawElement.style.overflow = 'hidden';
    rawElement.style.display = '-webkit-flex';
    rawElement.style.boxSizing = 'border-box';
  }

  @override void updateLayout(){
    if (!isLoaded) return;
    invalidate();
  }

  /**
  * Sets given [DockLocation] value to the Dockpanel.dockProperty
  * for the given [element]. */
  static void setDock(HtmlPlatformElement element, value){
    assert(value is String || value is DockLocation);

    if (element == null) return;

    value = const StringToLocationConverter().convert(value);

    if (DockPanel.dockProperty == null) {
      DockPanel.dockProperty = new AttachedFrameworkProperty("dock",
        (HtmlPlatformElement e, DockLocation l){});
    }

    AttachedFrameworkProperty.setValue(element, dockProperty, value);

  }

  /**
  * Returns the [DockLocation] value currently assigned to the
  * Dockpanel.dockProperty for the given element. */
  static DockLocation getDock(HtmlPlatformElement element){
    if (element == null) return DockLocation.left;

    final value = AttachedFrameworkProperty.getValue(element, dockProperty);

    if (DockPanel.dockProperty == null || value == null) {
      DockPanel.setDock(element, DockLocation.left);
    }

    return AttachedFrameworkProperty.getValue(element, dockProperty);
  }


  /** Invalidates the DockPanel layout and causes it to redraw. */
  void invalidate(){
    //TODO .removeLast() instead?
    rawElement.elements.clear();

    var currentContainer = rawElement;
    var lastLocation = DockLocation.left;

    //makes a flexbox container
    Element createContainer(DockLocation loc){
      final c = new RawHtml();
      c.rawElement.style.display = '-webkit-flex';
      c.rawElement.style.boxSizing = 'border-box';
      c.rawElement.style.flexFlow =
        (loc == DockLocation.left || loc == DockLocation.right)
          ? 'row'
          : 'column';

      //set the orientation
//      Polly.setCSS(c, 'flex-direction', (loc == DockLocation.left
//          || loc == DockLocation.right) ? 'row' : 'column');

      //set the stretch
      c.rawElement.style.setProperty('-webkit-flex', '1 1 auto');

      //make container-level adjustments based on the dock location.
      switch(loc.toString()){
        case 'right':
          c.rawElement.style.setProperty('-webkit-justify-content', 'flex-end');
          break;
        case 'top':
          c.rawElement.style.setProperty('-webkit-justify-content', 'flex-start');
          c.rawElement.style.setProperty('-webkit-align-items', 'stretch');
          break;
        case 'bottom':
          c.rawElement.style.setProperty('-webkit-justify-content', 'flex-end');
          c.rawElement.style.setProperty('-webkit-align-items', 'stretch');
          break;
      }

      return c.rawElement;
    }

    // Adds child to container with correct alignment and ordering.
    void addChild(Element container, HtmlPlatformElement child, DockLocation loc){
      if (loc == DockLocation.top || loc == DockLocation.bottom){
        child.rawElement.style.setProperty('-webkit-flex', 'none');
      }

      if ((loc == DockLocation.right || loc == DockLocation.bottom)
          && (container.elements.length > 0)){
        container.insertBefore(child.rawElement, container.elements[0]);
      }else{
        container.elements.add(child.rawElement);
      }
    }

    children.forEach((child){
      child.parent = this;

      if (currentContainer == rawElement){
        lastLocation = DockPanel.getDock(child);

        final newContainer = createContainer(lastLocation);

        addChild(newContainer, child, lastLocation);

        currentContainer.elements.add(newContainer);

        currentContainer = newContainer;
      }else{
        final loc = DockPanel.getDock(child);

        if (loc == lastLocation){
          addChild(currentContainer, child, lastLocation);
        }else{

          final newContainer = createContainer(loc);

          addChild(newContainer, child, loc);

          if ((lastLocation == DockLocation.right ||
              lastLocation == DockLocation.bottom)
              && (currentContainer.elements.length > 0)){
            currentContainer.insertBefore(newContainer,
              currentContainer.elements[0]);
          }else{
            currentContainer.elements.add(newContainer);
          }

          currentContainer = newContainer;
          lastLocation = loc;
        }
      }
    });

    //stretch the last item to fill the remaining space
    if (fillLast.value && !children.isEmpty){
      final child = children.last;
      //stretch the last item to fill the remaining space
      final p = child.rawElement.parent;

      assert(p is Element);
      child.rawElement.style.setProperty('-webkit-flex', '1 1 auto');
      child.rawElement.style.setProperty('-webkit-align-self', 'stretch');
    }
  }



//
//  static int _gridCount = 0;
//  // Used by DockPanel when display:flex is not available.
//  //
//  // The polyfill in this case uses nested Grid 2-column or 2-row elements for
//  // each child.
//  _invalidatePolyfill(){
//
//    //TODO .removeLast() instead?
////    children.forEach((FrameworkObject child){
////      child.removeFromLayoutTree();
////    });
//
//    var currentContainer = this;
//    var lastLocation = DockLocation.left;
//
//    //makes a flexbox container
//    Grid createContainer(DockLocation loc){
//      // set the grid row/column definitions based on position
//
//      final g = new Grid()
//                    ..hAlign.value = HorizontalAlignment.stretch
//                    ..vAlign.value = VerticalAlignment.stretch
//                    ..name.value = 'grid_${_gridCount++}'
//                    ..background.value = new SolidColorBrush(new Color.predefined(Colors.Yellow));
//
//      switch(loc){
//        case DockLocation.left:
//          g.columnDefinitions.add(new ColumnDefinition.with(new GridLength.auto()));
//          g.columnDefinitions.add(new ColumnDefinition.with(new GridLength.star(1)));
//          g.rowDefinitions.add(new RowDefinition.with(new GridLength.star(1)));
//          return g;
//        case DockLocation.right:
//          g.columnDefinitions.add(new ColumnDefinition.with(new GridLength.star(1)));
//          g.columnDefinitions.add(new ColumnDefinition.with(new GridLength.auto()));
//          g.rowDefinitions.add(new RowDefinition.with(new GridLength.star(1)));
//          return g;
//        case DockLocation.top:
//          g.rowDefinitions.add(new RowDefinition.with(new GridLength.auto()));
//          g.rowDefinitions.add(new RowDefinition.with(new GridLength.star(1)));
//          g.columnDefinitions.add(new ColumnDefinition.with(new GridLength.star(1)));
//          return g;
//        case DockLocation.bottom:
//          g.rowDefinitions.add(new RowDefinition.with(new GridLength.star(1)));
//          g.rowDefinitions.add(new RowDefinition.with(new GridLength.auto()));
//          g.columnDefinitions.add(new ColumnDefinition.with(new GridLength.star(1)));
//          return g;
//      }
//
//    }
//
//    // Adds child to container with correct alignment and ordering.
//    void addDockedChild(Grid container, HtmlPlatformElement child, DockLocation loc){
//      switch(loc){
//        case DockLocation.left:
//          Grid.setColumn(child, 0);
//          Grid.setRow(child, 0);
//          child.hAlign.value = HorizontalAlignment.left;
//          child.vAlign.value = VerticalAlignment.stretch;
//          break;
//        case DockLocation.right:
//          Grid.setColumn(child, 1);
//          Grid.setRow(child, 0);
//          child.hAlign.value = HorizontalAlignment.right;
//          child.vAlign.value = VerticalAlignment.stretch;
//          break;
//        case DockLocation.top:
//          Grid.setColumn(child, 0);
//          Grid.setRow(child, 0);
//          child.hAlign.value = HorizontalAlignment.stretch;
//          child.vAlign.value = VerticalAlignment.top;
//          break;
//        case DockLocation.bottom:
//          Grid.setColumn(child, 0);
//          Grid.setRow(child, 1);
//          child.hAlign.value = HorizontalAlignment.stretch;
//          child.vAlign.value = VerticalAlignment.bottom;
//          break;
//      }
//
//      container.children.add(child);
//    }
//
//    children.forEach((child){
////      child.parent = this;
//
//      if (currentContainer == this){
//        lastLocation = DockPanel.getDock(child);
//
//        final newContainer = createContainer(lastLocation);
//
//        addDockedChild(newContainer, child, lastLocation);
//
////        print('....first container');
////        printTree(newContainer);
//
//        newContainer.addToLayoutTree(currentContainer);
//
//        Polly.setFlexboxAlignment(newContainer);
//
//        currentContainer = newContainer;
//      }else{
//        final location = DockPanel.getDock(child);
//
//        final newContainer = createContainer(location);
//
//        addDockedChild(newContainer, child, location);
////        print('....new container');
////        printTree(newContainer);
//
//
//        switch(lastLocation){
//          case DockLocation.left:
//            Grid.setColumn(newContainer, 1);
//            break;
//          case DockLocation.right:
//            Grid.setColumn(newContainer, 0);
//            break;
//          case DockLocation.top:
//            Grid.setRow(newContainer, 1);
//            break;
//          case DockLocation.bottom:
//            Grid.setRow(newContainer, 0);
//            break;
//        }
//
//        currentContainer.children.add(newContainer);
//
////        print('....current container');
////        printTree(currentContainer);
//
//
//        //print('$currentContainer column defs: ${currentContainer.columnDefinitions} ${Grid.getColumn(newContainer)}');
//
//        lastLocation = location;
//
//        currentContainer = newContainer;
//      }
//    });
//
//    //stretch the last item to fill the remaining space
////    if (fillLast && !children.isEmpty()){
////      final child = children.last();
////      //stretch the last item to fill the remaining space
////      final p = child.rawElement.parent;
////
////      assert(p is Element);
////
////      Polly.setCSS(child.rawElement, 'flex', '1 1 auto');
////
////      Polly.setCSS(child.rawElement, 'align-self', 'stretch');
////    }
//  }

}
