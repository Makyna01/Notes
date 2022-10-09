import 'package:flutter/material.dart';
import 'package:notes/ui/widgets/notes_create/notes_create_model.dart';

class NotesCreateWidget extends StatefulWidget {
  const NotesCreateWidget({Key? key}) : super(key: key);

  @override
  State<NotesCreateWidget> createState() => _NotesCreateWidgetState();
}

class _NotesCreateWidgetState extends State<NotesCreateWidget> {
  final _model = NotesCreateWidgetModel();
  @override
  Widget build(BuildContext context) {
    return NotesCreateModelProvider(
      model: _model,
      child: const NotesCreateBodyWidget(),
    );
  }
}

class NotesCreateBodyWidget extends StatelessWidget {
  const NotesCreateBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotesCreateModelProvider.watch(context)?.model;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Notes"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model?.saveNotes(context),
        child: const Icon(
          Icons.done,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: TextField(
          autofocus: true,
          onChanged: (value) => model?.notesName = value,
          onEditingComplete: () => model?.saveNotes(context),
          decoration: const InputDecoration(
            label: Text(
              'Notes name',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
