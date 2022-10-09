import 'package:hive_flutter/hive_flutter.dart';

part 'notes.g.dart';

@HiveType(typeId: 1)
class Notes extends HiveObject {
  //1,2 - hiveField used

  @HiveField(0)
  String notes;

  Notes({
    required this.notes,
  });
}
