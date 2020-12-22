import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';

import 'package:flutterannotation/mark.dart';

class MarkGenerator extends GeneratorForAnnotation<Mark> {
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    String className = element.displayName;
    String path = buildStep.inputId.path;
    String name =annotation.peek('name').stringValue;

    return "//$className\n//$path\n//$name";
  }
}