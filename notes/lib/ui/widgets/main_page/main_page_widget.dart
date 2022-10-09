import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes/ui/widgets/main_page/main_page_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _model = NotesListModel();
  @override
  Widget build(BuildContext context) {
    return NotesListModelProvider(
      model: _model,
      child: const MainPageBody(),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await _model.dispose();
  }
}

class MainPageBody extends StatelessWidget {
  const MainPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listLength =
        NotesListModelProvider.watch(context)?.model.notes.length ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            NotesListModelProvider.read(context)?.model.createNotes(context),
        child: const Icon(Icons.add, size: 40),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListView.builder(
        itemCount: listLength,
        itemBuilder: (context, index) => ItemWidget(
          indexInList: index,
        ),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  final int indexInList;
  const ItemWidget({Key? key, required this.indexInList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notes =
        NotesListModelProvider.watch(context)!.model.notes[indexInList];
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 1,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.red,
            foregroundColor: Colors.black,
            onPressed: (BuildContext context) =>
                NotesListModelProvider.watch(context)
                    ?.model
                    .deleteNotes(indexInList),
            icon: Icons.delete,
            label: 'Delete',
          )
        ],
      ),
      child: ListTile(
        onTap: () => NotesListModelProvider.watch(context)
            ?.model
            .goToDescription(context, indexInList),
        trailing: const Icon(Icons.chevron_right),
        title: Text(
          notes.notes,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
