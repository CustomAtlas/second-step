import 'package:flutter/material.dart';
import 'package:second_step/user/model.dart';

class ListWidget extends StatelessWidget {
  const ListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 40, 15, 15),
        child: Column(
          children: [
            Expanded(flex: 7, child: _ListViewWidget()),
            Expanded(child: _ButtonsWidget()),
          ],
        ),
      ),
    );
  }
}

class _ListViewWidget extends StatelessWidget {
  const _ListViewWidget();

  @override
  Widget build(BuildContext context) {
    final model = ModelProvider.watch(context)?.model;
    return ListView.builder(
        itemCount: model?.users.length,
        itemBuilder: (context, index) {
          return _UserNameWidget(index: index);
        });
  }
}

class _UserNameWidget extends StatelessWidget {
  final int index;
  const _UserNameWidget({required this.index});

  @override
  Widget build(BuildContext context) {
    final model = ModelProvider.read(context)?.model;
    final decoration = BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(width: 2.5, color: Colors.black54));
    return ListTile(
      onTap: () => showDialog(
        context: context,
        builder: (context) => _UserAlertDialog(index: index),
      ),
      title: DecoratedBox(
          decoration: decoration,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(model?.users[index].userName ?? ''),
          )),
    );
  }
}

class _UserAlertDialog extends StatelessWidget {
  final int index;
  const _UserAlertDialog({required this.index});

  @override
  Widget build(BuildContext context) {
    final model = ModelProvider.read(context)?.model;
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Username: ${model?.users[index].userName}'),
          Text('Фамилия: ${model?.users[index].secName}'),
          Text('Имя: ${model?.users[index].firstName}'),
          Text('Телефон: ${model?.users[index].number}'),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => model?.deleteUserOfIndex(context, index),
            child: const Text(
              'Delete',
              style: TextStyle(fontSize: 18),
            )),
        TextButton(
            onPressed: () => model?.toEditInfo(context, index),
            child: const Text(
              'Edit',
              style: TextStyle(fontSize: 18),
            )),
      ],
    );
  }
}

class _ButtonsWidget extends StatelessWidget {
  const _ButtonsWidget();

  @override
  Widget build(BuildContext context) {
    final model = ModelProvider.read(context)?.model;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => model?.deleteLastUser(),
          child: const Text('Delete', style: TextStyle(fontSize: 20)),
        ),
        TextButton(
          onPressed: () => model?.toInfoWidget(context),
          child: const Text('Add', style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }
}
