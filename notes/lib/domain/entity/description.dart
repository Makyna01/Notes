import 'package:hive/hive.dart';

part 'description.g.dart';

@HiveType(typeId: 2)
class Description extends HiveObject{

  @HiveField(0)
  String taskName;

  @HiveField(1)
  bool isDone;

  Description({
    required this.taskName,
    required this.isDone,
  });
}
