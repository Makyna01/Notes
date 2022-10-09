import 'package:flutter/material.dart';
import 'package:notes/domain/data_provider/box_manager.dart';
import 'package:notes/domain/entity/notes.dart';

class NotesCreateWidgetModel {
  var notesName = '';

  void saveNotes(BuildContext context) async {
    if (notesName.isEmpty) return;
    final box = await BoxManager.instance.openNotesBox();
    final notes = Notes(notes: notesName);
    box.add(notes);


    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }
}

class NotesCreateModelProvider extends InheritedWidget {
  final NotesCreateWidgetModel model;
  const NotesCreateModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  static NotesCreateModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<NotesCreateModelProvider>();
  }

  static NotesCreateModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<NotesCreateModelProvider>()
        ?.widget;
    return widget is NotesCreateModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
