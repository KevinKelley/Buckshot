part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/*
 * Top-level Logging and Debug
 */

var _logEvents = new ObservableList<String>();

set logLevel(Level level){
  Logger.root.level = level;
}

final _traceProperty = [];

void _logit(LogRecord record){
  final event = '[${record.loggerName} - ${record.level}'
  ' - ${record.sequenceNumber}] ${record.message}';
  _logEvents.add(event);
  print(event);
}

void dumpTheme(){
  print('THEME RESOURCES');
  _resourceRegistry.forEach((k, v){
    if (!k.startsWith('theme')) return;
    print('$k: $v');
  });
}

/**
 * Debug function that pretty prints an element tree to stdout.
 */
void printTree(startWith, [int indent = 0]){
  if (startWith == null || startWith is! FrameworkObject) return;

  String space(int n){
    var s = new StringBuffer();
    for(int i = 0; i < n; i++){
      s.add(' ');
    }
    return s.toString();
  }

  print('${space(indent)}${startWith}'
        '(Parent=${startWith.parent})');

  if (startWith is FrameworkContainer){
    if ((startWith as FrameworkContainer).containerContent is List){
      (startWith as FrameworkContainer)
        .containerContent
        .forEach((e) => printTree(e, indent + 3));
    }else{
      printTree(startWith.containerContent, indent + 3);
    }
  }
}

