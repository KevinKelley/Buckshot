library generator_core_buckshotui_org;

import 'dart:io';
import 'dart:json';
import 'package:xml/xml.dart';
import 'package:html5lib/parser.dart' as html;

import 'package:buckshot/gen/genie.dart';

void generateCode(){

  final fileNames = _getChangedFiles(new Options().arguments);
  if (fileNames.isEmpty){
    return;
  }

  final out = new File('test.tmp').openOutputStream();

  out.onError = (e){
    out.close();
    exit(1);
  };

  for(final fileNameAndPath in fileNames){

    try{
      final gs = new GeneratorFile(fileNameAndPath);

      if (gs.fileData == null){
        throw const Exception('Could not read file data.');
      }

      var result;

      if (gs.fileType == GeneratorFile.HTML){
        result = _generateFromHTML(gs.name, gs.fileData);

      }else if (gs.fileType == GeneratorFile.TEMPLATE){
        result = _generateFromXMLTemplate(gs.name, gs.fileData);

        out.writeString('${result.values}');
      }

    } on XmlException catch(xmlE){
    } on Exception catch(e){
    }
  }

  out.close();
}

List<String> _getChangedFiles(List<String> rawArgs){
  return
    rawArgs
      .filter((arg) =>
          arg.startsWith('--changed') &&
          (validTemplateExtensions.some((ext) => arg.endsWith(ext)) ||
              arg.endsWith('.html')))
      .map((arg) => arg.replaceFirst('--changed=', ''));
}


Map<String, String> _generateFromXMLTemplate(String name, String templateData){
  return JSON.parse(genCode(name, XML.parse(templateData)));
}

Map<String, String> _generateFromHTML(String name, String htmlData){
  return {'html' : htmlData};
}



