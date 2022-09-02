
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_application/features/tasks/domain/entities/task_entity.dart';
import 'package:todo_application/features/tasks/presentation/controller/tasks_cubit/tasks_cubit.dart';
import 'package:todo_application/features/tasks/presentation/controller/tasks_cubit/tasks_states.dart';
import 'package:todo_application/features/tasks/presentation/resources/assets_manager.dart';
import 'package:todo_application/features/tasks/presentation/resources/color_manager.dart';
import 'package:todo_application/features/tasks/presentation/resources/routes_manager.dart';
import "package:todo_application/features/tasks/presentation/widgets/list_view_builder.dart";

import '../../../../../core/widgets/fluuter_toast.dart';
import '../../controller/edit_cubit/edit_cubit.dart';
import '../../controller/edit_cubit/edit_states.dart';
import '../../widgets/empty_data_base_body.dart';
import '../../widgets/empty_list_body.dart';
class ArchivedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener< EditCubit,EditCubitStates>(
      listener: (context,state){
        if(state is UpdateTaskSuccessState){
          showMyToast(message: "Task Moved to ${state.movedTo}");
        }
        if(state is DeleteTaskSuccessState){
          showMyToast(message: "Task removed successfully");
        }
        if( state is UpdateTaskFailedState ||  state is DeleteTaskFailedState){
          showMyToast(message: "There is a problem , Please try again",isGreen: false);
        }
      },
      child: BlocBuilder<TasksCubit,TasksStates>(
      builder: ((context, state) {        
        return _chooseTheCorrectBody(state, context);
        }),     
      ),
    );
  }

  Widget _chooseTheCorrectBody(TasksStates state, BuildContext context) {
    if( state is GetTasksSuccessState){
      if(state.archivedTasks.isEmpty){
        return emptyListBody(listName: "archived");
      }else{
        print(state.archivedTasks);
        return buildListView(state.archivedTasks, context);
      }
      
    }
    else if (state is GetTasksFailedState){
      return noTasksAtDataBase();
    }
    else{
      return Center(child: CircularProgressIndicator(color: ColorManager.primary),);
    }

  }
  
}