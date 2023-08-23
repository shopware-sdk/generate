import 'dart:convert';
import 'dart:io';

import 'package:class_generate/dto.dart';

void main() async {
  String filePath = 'order.json';


  String fileContent = await File(filePath).readAsString();
  ClassInfoList classInfoList = ClassInfoList();

  Map<String, dynamic> jsonMap = jsonDecode(fileContent);
  String phpClass = generatePHPClass(jsonMap['properties'], classInfoList);
  print(phpClass);
}

String generatePHPClass(
    Map<String, dynamic> properties, ClassInfoList classInfoList) {
  ClassInfo classInfo = ClassInfo('Order');
  classInfoList.classes.add(classInfo);

  properties.forEach((key, value) {
    if (key != 'relationships') {
      if (value['type'] == 'object' && value['properties'] != null) {
        String name = key[0].toUpperCase() + key.substring(1);
        ClassInfo subClassInfo = ClassInfo('Order$name');

        value['properties'].forEach((key, value) {
          String type = getPHPType(value['type']);
          if (type != 'mixed') {
            PropertyInfo propertyInfo = PropertyInfo(key, type);
            subClassInfo.properties.add(propertyInfo);
          }
        });

        classInfoList.classes.add(subClassInfo);

        PropertyInfo propertyInfo = PropertyInfo(key, subClassInfo.name);
        classInfo.properties.add(propertyInfo);
      }

      if (value['type'] != 'object') {
        String type = getPHPType(value['type']);
        if (type != 'mixed') {
          PropertyInfo propertyInfo = PropertyInfo(key, type);
          classInfo.properties.add(propertyInfo);
        }
      }
    }
  });

  print(classInfo.properties);

  return '';
}

String getPHPType(String jsonType) {
  switch (jsonType) {
    case 'string':
      return 'string';
    case 'integer':
      return 'int';
    case 'number':
      return 'float';
    case 'object':
    case 'array':
      return 'array';
    default:
      return 'mixed';
  }
}
