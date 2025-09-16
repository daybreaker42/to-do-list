import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../config/theme.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import 'task_form_page.dart';

/// 태스크 상세 페이지
/// 태스크의 상세 정보를 보여주고 편집할 수 있는 페이지
class TaskDetailPage extends StatefulWidget {
  final Map<String, dynamic>? taskData;

  const TaskDetailPage({
    Key? key,
    this.taskData,
  }) : super(key: key);

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final TaskService _taskService = TaskService();
  TaskModel? task;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  void _loadTask() {
    if (widget.taskData != null) {
      task = TaskModel.fromMap(widget.taskData!);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.highlight),
        ),
      );
    }

    if (task == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text('할 일을 찾을 수 없음', style: TextStyles.mainTitle),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.highlight),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64.sp,
                color: AppColors.secondaryText,
              ),
              SizedBox(height: 16.h),
              Text(
                '할 일을 찾을 수 없습니다',
                style: TextStyles.subTitle.copyWith(color: AppColors.secondaryText),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('할 일 상세', style: TextStyles.mainTitle),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.highlight),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: AppColors.highlight),
            onPressed: _editTask,
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: AppColors.secondaryText),
            color: AppColors.surface,
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: _showDeleteDialog,
                child: Row(
                  children: [
                    Icon(Icons.delete, color: AppColors.error, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      '삭제',
                      style: TextStyles.small.copyWith(color: AppColors.error),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: _togglePin,
                child: Row(
                  children: [
                    Icon(
                      task!.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                      color: AppColors.highlight,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      task!.isPinned ? '고정 해제' : '고정하기',
                      style: TextStyles.small.copyWith(color: AppColors.primaryText),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 우선순위 표시
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: task!.priority.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: task!.priority.color),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: task!.priority.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    task!.priority.displayName,
                    style: TextStyles.small.copyWith(
                      color: task!.priority.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // 제목
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _toggleCompletion,
                  child: Container(
                    width: 24.w,
                    height: 24.w,
                    margin: EdgeInsets.only(right: 12.w, top: 2.h),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: task!.isCompleted 
                            ? task!.priority.color 
                            : AppColors.secondaryText,
                        width: 2,
                      ),
                      color: task!.isCompleted
                          ? task!.priority.color
                          : Colors.transparent,
                    ),
                    child: task!.isCompleted
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16.sp,
                          )
                        : null,
                  ),
                ),
                Expanded(
                  child: Text(
                    task!.title,
                    style: TextStyles.detailTitle.copyWith(
                      color: task!.isCompleted 
                          ? AppColors.secondaryText 
                          : AppColors.primaryText,
                      decoration: task!.isCompleted 
                          ? TextDecoration.lineThrough 
                          : null,
                    ),
                  ),
                ),
                if (task!.isPinned)
                  Icon(
                    Icons.push_pin,
                    color: task!.priority.color,
                    size: 20.sp,
                  ),
              ],
            ),

            SizedBox(height: 24.h),

            // 설명
            if (task!.description.isNotEmpty) ...[
              _buildSectionTitle('설명'),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  task!.description,
                  style: TextStyles.caption.copyWith(color: AppColors.primaryText),
                ),
              ),
              SizedBox(height: 24.h),
            ],

            // 태그
            if (task!.tags.isNotEmpty) ...[
              _buildSectionTitle('태그'),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: task!.tags.map((tag) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: task!.priority.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    tag,
                    style: TextStyles.small.copyWith(
                      color: task!.priority.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )).toList(),
              ),
              SizedBox(height: 24.h),
            ],

            // 마감일
            if (task!.dueDate != null) ...[
              _buildSectionTitle('마감일'),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: _getDueDateColor(),
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDate(task!.dueDate!),
                          style: TextStyles.subTitle.copyWith(
                            color: _getDueDateColor(),
                          ),
                        ),
                        Text(
                          _getDueDateStatus(),
                          style: TextStyles.small.copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
            ],

            // 생성 정보
            _buildSectionTitle('생성 정보'),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, color: AppColors.secondaryText, size: 16.sp),
                      SizedBox(width: 8.w),
                      Text(
                        '생성일: ${_formatDate(task!.createdAt)}',
                        style: TextStyles.small.copyWith(color: AppColors.secondaryText),
                      ),
                    ],
                  ),
                  if (task!.isCompleted) ...[
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16.sp),
                        SizedBox(width: 8.w),
                        Text(
                          '완료됨',
                          style: TextStyles.small.copyWith(color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: 40.h),

            // 액션 버튼들
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _toggleCompletion,
                    icon: Icon(
                      task!.isCompleted ? Icons.undo : Icons.check,
                      size: 20.sp,
                    ),
                    label: Text(
                      task!.isCompleted ? '완료 취소' : '완료 처리',
                      style: TextStyles.subTitle.copyWith(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: task!.isCompleted 
                          ? AppColors.secondaryText 
                          : Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _editTask,
                    icon: Icon(Icons.edit, size: 20.sp),
                    label: Text('수정', style: TextStyles.subTitle.copyWith(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyles.subTitle.copyWith(color: AppColors.primaryText),
    );
  }

  Color _getDueDateColor() {
    if (task!.dueDate == null) return AppColors.secondaryText;
    
    final now = DateTime.now();
    final difference = task!.dueDate!.difference(now).inHours;
    
    if (difference < 0) return AppColors.error; // 지난 마감일
    if (difference < 24) return AppColors.warning; // 24시간 이내
    return AppColors.secondaryText; // 여유 있음
  }

  String _getDueDateStatus() {
    if (task!.dueDate == null) return '';
    
    final now = DateTime.now();
    final difference = task!.dueDate!.difference(now);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}일 남음';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 남음';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 남음';
    } else if (difference.inMinutes >= 0) {
      return '곧 마감';
    } else {
      return '마감 지남';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _toggleCompletion() {
    setState(() {
      _taskService.toggleTaskCompletion(task!.id);
      task = _taskService.getTaskById(task!.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          task!.isCompleted ? '할 일이 완료되었습니다' : '할 일 완료가 취소되었습니다',
          style: TextStyles.small.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _togglePin() {
    setState(() {
      final updatedTask = task!.copyWith(isPinned: !task!.isPinned);
      _taskService.updateTask(updatedTask);
      task = updatedTask;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          task!.isPinned ? '할 일이 고정되었습니다' : '할 일 고정이 해제되었습니다',
          style: TextStyles.small.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _editTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormPage(existingTask: task),
      ),
    ).then((_) {
      // 수정 후 돌아왔을 때 데이터 새로고침
      setState(() {
        task = _taskService.getTaskById(task!.id);
      });
    });
  }

  void _showDeleteDialog() {
    showDialog(
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
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '취소',
              style: TextStyles.small.copyWith(color: AppColors.secondaryText),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteTask();
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

  void _deleteTask() {
    _taskService.deleteTask(task!.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '할 일이 삭제되었습니다',
          style: TextStyles.small.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.success,
      ),
       );
       if (mounted) {
         context.pop();
       }
  }
}