import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/theme.dart';
import '../models/task_model.dart';

/// 개별 Task 카드 위젯 (스와이프 제스처 포함)
class TaskCardWidget extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onTap;
  final VoidCallback onComplete;
  final VoidCallback onDelete;
  final bool isBeingDragged;

  const TaskCardWidget({
    Key? key,
    required this.task,
    required this.onTap,
    required this.onComplete,
    required this.onDelete,
    this.isBeingDragged = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: Dismissible(
        key: Key(task.id),
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            // 왼쪽으로 스와이프 - 삭제
            return await _showDeleteConfirmDialog(context);
          } else if (direction == DismissDirection.startToEnd) {
            // 오른쪽으로 스와이프 - 완료
            onComplete();
            return false; // 실제로 dismiss하지 않고 완료 처리만
          }
          return false;
        },
        background: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 16.w),
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 24.sp,
          ),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 16.w),
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 24.sp,
          ),
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isBeingDragged 
                  ? AppColors.surface.withOpacity(0.8)
                  : AppColors.darkBackground,
              borderRadius: BorderRadius.circular(8.r),
              border: task.isPinned
                  ? Border.all(color: task.priority.color, width: 1)
                  : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 체크박스
                GestureDetector(
                  onTap: onComplete,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    margin: EdgeInsets.only(right: 12.w, top: 2.h),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: task.isCompleted 
                            ? task.priority.color 
                            : AppColors.secondaryText,
                        width: 1.5.w,
                      ),
                      color: task.isCompleted
                          ? task.priority.color
                          : Colors.transparent,
                    ),
                    child: task.isCompleted
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14.sp,
                          )
                        : null,
                  ),
                ),

                // 태스크 내용
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 제목
                      Text(
                        task.title,
                        style: TextStyles.small.copyWith(
                          color: task.isCompleted 
                              ? AppColors.secondaryText 
                              : AppColors.primaryText,
                          decoration: task.isCompleted 
                              ? TextDecoration.lineThrough 
                              : null,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // 설명 (있는 경우)
                      if (task.description.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          task.description,
                          style: TextStyles.caption.copyWith(
                            color: AppColors.secondaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      // 태그들
                      if (task.tags.isNotEmpty) ...[
                        SizedBox(height: 6.h),
                        Wrap(
                          spacing: 4.w,
                          runSpacing: 2.h,
                          children: task.tags.take(2).map((tag) => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: task.priority.color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: task.priority.color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )).toList(),
                        ),
                      ],

                      // 마감일 (있는 경우)
                      if (task.dueDate != null) ...[
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 12.sp,
                              color: _getDueDateColor(),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              _formatDueDate(task.dueDate!),
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: _getDueDateColor(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // 고정 아이콘
                if (task.isPinned)
                  Icon(
                    Icons.push_pin,
                    size: 16.sp,
                    color: task.priority.color,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getDueDateColor() {
    if (task.dueDate == null) return AppColors.secondaryText;
    
    final now = DateTime.now();
    final difference = task.dueDate!.difference(now).inHours;
    
    if (difference < 0) return AppColors.error; // 지난 마감일
    if (difference < 24) return AppColors.warning; // 24시간 이내
    return AppColors.secondaryText; // 여유 있음
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}일 후';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 후';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 후';
    } else if (difference.inMinutes >= 0) {
      return '곧 마감';
    } else {
      return '마감됨';
    }
  }

  Future<bool?> _showDeleteConfirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          '할 일 삭제',
          style: TextStyles.subTitle.copyWith(color: AppColors.primaryText),
        ),
        content: Text(
          '이 할 일을 삭제하시겠습니까?',
          style: TextStyles.caption.copyWith(color: AppColors.secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              '취소',
              style: TextStyles.small.copyWith(color: AppColors.secondaryText),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              onDelete();
            },
            child: Text(
              '삭제',
              style: TextStyles.small.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
