import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/domain/entity/description.dart';
import 'package:notes/domain/entity/notes.dart';

class BoxManager {
  static final BoxManager instance = BoxManager._();
  BoxManager._();

  Future<Box<Notes>> openNotesBox() async {
    return _openBox('notes_box', 1, NotesAdapter());
  }

  Future<Box<Description>> openDescriptionBox(int notesKey) async {
    return _openBox(makeTaskBoxName(notesKey), 2, DescriptionAdapter());
  }

  Future<void> closeBox<T>(Box<T> box) async {
    await box.compact();
    await box.close();
  }

  String makeTaskBoxName(int notesKey) => 'task_box_$notesKey';

  Future<Box<T>> _openBox<T>(
      String name, int typeId, TypeAdapter<T> adapter) async {
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(adapter);
    }
    return Hive.openBox<T>(name);
  }
}
