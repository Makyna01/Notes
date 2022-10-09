import 'package:flutter/material.dart';
import 'package:notes/domain/data_provider/box_manager.dart';
import 'package:notes/domain/entity/description.dart';

class DescriptionCreateModel {
  var taskText = '';
  int notesKey;

  DescriptionCreateModel({required this.notesKey});

  Future<void> saveTask(BuildContext context) async {
    if (taskText.isEmpty) return;
    final description = Description(taskName: taskText, isDone: false);
    final box = await BoxManager.instance.openDescriptionBox(notesKey);
    await box.add(description);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }
}

class DescriptionCreateModelProvider extends InheritedWidget {
  final DescriptionCreateModel model;
  const DescriptionCreateModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  static DescriptionCreateModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DescriptionCreateModelProvider>();
  }

  static DescriptionCreateModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<
            DescriptionCreateModelProvider>()
        ?.widget;
    return widget is DescriptionCreateModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
