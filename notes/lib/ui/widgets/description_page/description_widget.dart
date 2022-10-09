import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes/ui/widgets/description_page/description_model.dart';

class DescriptionPageConfiguration {
  final String title;
  final int notesKey;
  DescriptionPageConfiguration({required this.title, required this.notesKey});
}

class DescritionPageWidget extends StatefulWidget {
  final DescriptionPageConfiguration configuration;
  const DescritionPageWidget({Key? key, required this.configuration})
      : super(key: key);

  @override
  State<DescritionPageWidget> createState() => _DescritionPageWidgetState();
}

class _DescritionPageWidgetState extends State<DescritionPageWidget> {
  late final DescriptionPageModel _model;

  @override
  void initState() {
    super.initState();
    _model = DescriptionPageModel(configuration: widget.configuration);
  }

  @override
  Widget build(BuildContext context) {
    return DescriptionPageModelProvider(
      model: _model,
      child: const DescritionBodyWidget(),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await _model.dispose();
  }
}

class DescritionBodyWidget extends StatelessWidget {
  const DescritionBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = DescriptionPageModelProvider.watch(context)?.model;
    final title = model?.configuration.title ?? 'Task';
    return Scaffold(
      appBar: AppBar(
        title: Text('Note: $title'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model?.createTask(
          context,
        ),
        child: const Icon(Icons.add, size: 40),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListView.builder(
        itemCount: model?.description.length,
        itemBuilder: (context, index) => ItemDescriptionWidget(
          indexInList: index,
        ),
      ),
    );
  }
}

class ItemDescriptionWidget extends StatelessWidget {
  final int indexInList;
  const ItemDescriptionWidget({Key? key, required this.indexInList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = DescriptionPageModelProvider.watch(context)?.model;
    final description = model?.description[indexInList];
    final icon = description!.isDone ? Icons.done : Icons.cancel;
    final style = description.isDone
        ? const TextStyle(
            decoration: TextDecoration.lineThrough,
            decorationColor: Colors.red,
            fontSize: 24)
        : const TextStyle(fontSize: 24);
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 1,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.red,
            foregroundColor: Colors.black,
            onPressed: (BuildContext context) => model?.deleteTask(indexInList),
            icon: Icons.delete,
            label: 'Delete',
          )
        ],
      ),
      child: ListTile(
        trailing: GestureDetector(
          onTap: () => model?.toggleDone(indexInList),
          child: Icon(icon),
        ),
        title: Text(description.taskName, style: style),
      ),
    );
  }
}
