import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/theme.dart';
import '../models/task_model.dart';
import 'task_card_widget.dart';

/// 우선순위별 섹션 위젯
class PrioritySectionWidget extends StatelessWidget {
  final TaskPriority priority;
  final List<TaskModel> tasks;
  final Function(TaskModel) onTaskTap;
  final Function(TaskModel) onTaskComplete;
  final Function(TaskModel) onTaskDelete;
  final Function(TaskModel, TaskPriority) onTaskPriorityChanged;

  const PrioritySectionWidget({
    Key? key,
    required this.priority,
    required this.tasks,
    required this.onTaskTap,
    required this.onTaskComplete,
    required this.onTaskDelete,
    required this.onTaskPriorityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: priority.color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // 섹션 헤더
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: priority.color.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: priority.color,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    priority.displayName,
                    style: TextStyles.small.copyWith(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '${tasks.length}',
                  style: TextStyles.small.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          
          // 태스크 리스트
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Text(
                      '할 일이 없습니다',
                      style: TextStyles.caption.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  )
                : DragTarget<TaskModel>(
                    onWillAccept: (task) => task != null && task.priority != priority,
                    onAccept: (task) {
                      onTaskPriorityChanged(task, priority);
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        decoration: candidateData.isNotEmpty
                            ? BoxDecoration(
                                color: priority.color.withOpacity(0.1),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12.r),
                                  bottomRight: Radius.circular(12.r),
                                ),
                              )
                            : null,
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return Draggable<TaskModel>(
                              data: task,
                              feedback: Material(
                                child: Container(
                                  width: 150.w,
                                  child: TaskCardWidget(
                                    task: task,
                                    onTap: () {},
                                    onComplete: () {},
                                    onDelete: () {},
                                    isBeingDragged: true,
                                  ),
                                ),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.5,
                                child: TaskCardWidget(
                                  task: task,
                                  onTap: () => onTaskTap(task),
                                  onComplete: () => onTaskComplete(task),
                                  onDelete: () => onTaskDelete(task),
                                ),
                              ),
                              child: TaskCardWidget(
                                task: task,
                                onTap: () => onTaskTap(task),
                                onComplete: () => onTaskComplete(task),
                                onDelete: () => onTaskDelete(task),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
