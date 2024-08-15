//Edit by Connor - Flutter 扩展实例
extension StringEx on String?{

  bool get isNullOrEmpty{
    return this==null||this!.isEmpty;
  }

  String? get firstUpperCase{

    if (this == null || this!.isEmpty) return this;
    return '${this![0].toUpperCase()}${this!.substring(1)}';
  }

  bool get hasData{
    if(this==null) {
      return false;
    }
    return this!=null&&this!.isNotEmpty;
  }

}