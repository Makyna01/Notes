import 'package:flutter/material.dart';
import 'package:notes/ui/widgets/description_create_page/description_create_model.dart';

class DescriptionCreatePageWidget extends StatefulWidget {
  final int notesKey;
  const DescriptionCreatePageWidget({Key? key, required this.notesKey})
      : super(key: key);

  @override
  State<DescriptionCreatePageWidget> createState() =>
      _DescriptionCreatePageWidgetState();
}

class _DescriptionCreatePageWidgetState
    extends State<DescriptionCreatePageWidget> {
  late final DescriptionCreateModel _model;
  @override
  void initState() {
    super.initState();
    _model = DescriptionCreateModel(notesKey: widget.notesKey);
  }

  @override
  Widget build(BuildContext context) {
    return DescriptionCreateModelProvider(
      model: _model,
      child: const DescriptionCreateBodyWidget(),
    );
  }
}

class DescriptionCreateBodyWidget extends StatelessWidget {
  const DescriptionCreateBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = DescriptionCreateModelProvider.watch(context)?.model;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CreateTask'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model?.saveTask(context),
        child: const Icon(
          Icons.done,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: TextField(
        autofocus: true,
        maxLines: null,
        minLines: null,
        expands: true,
        onChanged: (value) => model?.taskText = value,
        onEditingComplete: () => model?.saveTask(context),
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}
