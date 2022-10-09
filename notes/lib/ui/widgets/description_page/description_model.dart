import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/domain/data_provider/box_manager.dart';
import 'package:notes/domain/entity/description.dart';
import 'package:notes/ui/navigation/main_navigation.dart';
import 'package:notes/ui/widgets/description_page/description_widget.dart';

class DescriptionPageModel extends ChangeNotifier {
  DescriptionPageConfiguration configuration;
  late final Future<Box<Description>> _box;
  ValueListenable<Object>? _listenableBox;
  var description = <Description>[];

  DescriptionPageModel({required this.configuration}) {
    _setup();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openDescriptionBox(configuration.notesKey);
    await _readDescriptionFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readDescriptionFromHive);
  }

  Future<void> _readDescriptionFromHive() async {
    description = (await _box).values.toList();
    notifyListeners();
  }

  void createTask(BuildContext context) {
    Navigator.of(context).pushNamed(
        MainNavigationRouteNames.descriptionCreatePage,
        arguments: configuration.notesKey);
  }

  Future<void> deleteTask(int descriprionIndex) async {
    await (await _box).deleteAt(descriprionIndex);
  }

  Future<void> toggleDone(int descriprionIndex) async {
    final task = (await _box).getAt(descriprionIndex);
    task?.isDone = !task.isDone;
    task?.save();
  }

  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readDescriptionFromHive);
    await BoxManager.instance.closeBox((await _box));
    super.dispose();
  }
}

class DescriptionPageModelProvider extends InheritedNotifier {
  final DescriptionPageModel model;
  const DescriptionPageModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
          key: key,
          notifier: model,
          child: child,
        );

  static DescriptionPageModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DescriptionPageModelProvider>();
  }

  static DescriptionPageModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<DescriptionPageModelProvider>()
        ?.widget;
    return widget is DescriptionPageModelProvider ? widget : null;
  }
}
