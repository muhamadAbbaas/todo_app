import 'package:flutter/material.dart';
import 'package:toda_app/shared/cubit/app_cubit.dart';

Widget buildTaskItems(Map model, context) {
  return Dismissible(
    key: Key(
      model['id'].toString(),
    ),
    onDismissed: (direction) {
      AppCubit.get(context).deleteDate(id: model['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text('${model['time']}'),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${model['title']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${model['date']}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateDate(status: 'done', id: model['id']);
            },
            icon: const Icon(Icons.check_box),
            color: Colors.blue,
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context)
                  .updateDate(status: 'archived', id: model['id']);
            },
            icon: const Icon(Icons.archive_outlined),
            color: Colors.blueGrey,
          ),
        ],
      ),
    ),
  );
}

Widget buildFallbackCondation() {
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.sentiment_neutral_outlined,
          color: Colors.grey,
          size: 100,
        ),
        Text(
          'No tasks to preview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}
