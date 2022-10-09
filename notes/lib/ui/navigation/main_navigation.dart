import 'package:flutter/material.dart';
import 'package:notes/ui/widgets/description_create_page/description_create_widget.dart';
import 'package:notes/ui/widgets/description_page/description_widget.dart';
import 'package:notes/ui/widgets/main_page/main_page_widget.dart';
import 'package:notes/ui/widgets/notes_create/notes_create_widget.dart';

abstract class MainNavigationRouteNames {
  static const mainPage = '/';
  static const createNotesPage = '/create_page';
  static const descriptionPage = '/description_page';
  static const descriptionCreatePage =
      '/description_page/description_create_page';
}

class MainNavigation {
  final initialRoute = MainNavigationRouteNames.mainPage;
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.mainPage: (context) => const MainPage(),
    MainNavigationRouteNames.createNotesPage: (context) =>
        const NotesCreateWidget(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.descriptionPage:
        final configuration =
            settings.arguments as DescriptionPageConfiguration;
        return MaterialPageRoute(
          builder: (context) =>
              DescritionPageWidget(configuration: configuration),
        );

      case MainNavigationRouteNames.descriptionCreatePage:
        final notesKey = settings.arguments as int;
        return MaterialPageRoute(
            builder: (context) =>
                DescriptionCreatePageWidget(notesKey: notesKey));
      default:
        const widget = Text('error');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}
