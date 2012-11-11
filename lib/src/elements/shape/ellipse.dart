part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
 *  A primitive [Shape] representing an ellipse.
 */
class Ellipse extends Shape{

  FrameworkProperty<num> _cx;
  FrameworkProperty<num> _cy;
  FrameworkProperty<num> _rx;
  FrameworkProperty<num> _ry;

  Ellipse(){
    Browser.appendClass(rawElement, "ellipse");
    _initEllipseProperties();
  }

  Ellipse.register() : super.register();
  makeMe() => new Ellipse();

  void _initEllipseProperties(){
    _cx = new FrameworkProperty(this, '_cx',
      propertyChangedCallback: (v){
        if (v is! num) return;

        var result = v / 2;
        shapeElement.attributes['cx'] = '${result}';
        _rx.value = result;

      });

    _cy = new FrameworkProperty(this, '_cy',
      propertyChangedCallback: (v){
        if (v is! num) return;

        var result = v / 2;
        shapeElement.attributes['cy'] = '${result}';
        _ry.value = result;

      });

    _rx = new FrameworkProperty(this, '_rx',
      propertyChangedCallback: (v){
        shapeElement.attributes['rx'] = '${v - strokeWidth.value / 2}';
      });
    _ry = new FrameworkProperty(this, '_ry',
      propertyChangedCallback: (v){
        shapeElement.attributes['ry'] = '${v - strokeWidth.value / 2}';
      });

    bind(width, _cx);
    bind(height, _cy);
  }

  String get shapeTag => 'ellipse';
}
