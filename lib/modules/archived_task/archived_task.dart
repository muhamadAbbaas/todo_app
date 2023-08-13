import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/app_cubit.dart';

class ArchivedTask extends StatelessWidget {
  const ArchivedTask({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var archivedTasks = AppCubit.get(context).archivedTasks;
        if (archivedTasks.isNotEmpty) {
          return ListView.separated(
            itemCount: archivedTasks.length,
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 2.0,
                width: double.infinity,
                color: Colors.grey,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return buildTaskItems(archivedTasks[index], context);
            },
          );
        }
        return buildFallbackCondation();
      },
    );
  }
}
