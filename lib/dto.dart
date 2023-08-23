class ClassInfoList {
  List<ClassInfo> classes = [];
}

class ClassInfo {
  final String name;
  List<PropertyInfo> properties = [];

  ClassInfo(this.name);
}

class PropertyInfo{
  final String name;
  final String type;

  PropertyInfo(this.name, this.type);
}
