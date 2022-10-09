import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/domain/data_provider/box_manager.dart';
import 'package:notes/domain/entity/notes.dart';
import 'package:notes/ui/navigation/main_navigation.dart';
import 'package:notes/ui/widgets/description_page/description_widget.dart';

class NotesListModel extends ChangeNotifier {
  late final Future<Box<Notes>> _box;
  ValueListenable<Object>? _listenableBox;
  var notes = <Notes>[];

  NotesListModel() {
    _setup();
  }

  void createNotes(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.createNotesPage);
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openNotesBox();
    await _readNotesFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readNotesFromHive);
  }

  Future<void> _readNotesFromHive() async {
    notes = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> deleteNotes(int notesIndex) async {
    final box = await _box;
    final notesKey = (await _box).keyAt(notesIndex) as int;
    final taskBoxName = BoxManager.instance.makeTaskBoxName(notesKey);
    await Hive.deleteBoxFromDisk(taskBoxName);
    await box.deleteAt(notesIndex);
  }

  Future<void> goToDescription(BuildContext context, int notesIndex) async {
    final notes = (await _box).getAt(notesIndex);
    if (notes != null) {
      final configuration =
          DescriptionPageConfiguration(notesKey: notes.key, title: notes.notes);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamed(MainNavigationRouteNames.descriptionPage,
          arguments: configuration);
    }
  }

  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readNotesFromHive);
    await BoxManager.instance.closeBox((await _box));
    super.dispose();
  }
}

class NotesListModelProvider extends InheritedNotifier {
  final NotesListModel model;
  const NotesListModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
          key: key,
          notifier: model,
          child: child,
        );

  static NotesListModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NotesListModelProvider>();
  }

  static NotesListModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<NotesListModelProvider>()
        ?.widget;
    return widget is NotesListModelProvider ? widget : null;
  }
}
