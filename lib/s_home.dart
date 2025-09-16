import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart'; // GoRouter import 추가

// file imports
import 'config/theme.dart';
import 'models/task_model.dart';
import 'services/task_service.dart';
import 'widgets/priority_section_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TaskService _taskService = TaskService();
  String? _selectedTag; // 선택된 태그 필터
  
  @override
  void initState() {
    super.initState();
    // 샘플 데이터 초기화
    _taskService.initializeSampleData();
  }

  @override
  Widget build(BuildContext context) {
    // 시스템 UI 스타일 설정
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Priority Matrix', style: TextStyles.mainTitle),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColors.highlight),
          onPressed: () => context.push('/tags'),
        ),
        actions: [
          // 태그 필터 버튼
          PopupMenuButton<String>(
            icon: Icon(
              Icons.filter_list,
              color: _selectedTag != null ? AppColors.highlight : AppColors.secondaryText,
            ),
            color: AppColors.surface,
            onSelected: (tag) {
              setState(() {
                _selectedTag = _selectedTag == tag ? null : tag;
              });
            },
            itemBuilder: (context) {
              final allTags = _taskService.getAllTags();
              return [
                ...allTags.map((tag) => PopupMenuItem<String>(
                  value: tag,
                  child: Row(
                    children: [
                      Icon(
                        Icons.tag,
                        color: AppColors.highlight,
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        tag,
                        style: TextStyles.small.copyWith(
                          color: AppColors.primaryText,
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ];
            },
          ),
          // 새 할 일 추가 버튼
          IconButton(
            icon: Icon(Icons.add, color: AppColors.highlight),
            onPressed: () => context.push('/task-create'),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          children: [
            // 선택된 태그 표시
            if (_selectedTag != null) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                margin: EdgeInsets.only(bottom: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.tag, color: AppColors.highlight, size: 16.sp),
                    SizedBox(width: 8.w),
                    Text(
                      '태그: $_selectedTag',
                      style: TextStyles.small.copyWith(color: AppColors.primaryText),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() => _selectedTag = null),
                      child: Icon(Icons.close, color: AppColors.secondaryText, size: 16.sp),
                    ),
                  ],
                ),
              ),
            ],
            
            // 2x2 그리드 레이아웃
            Expanded(
              child: Column(
                children: [
                  // 상단 행 (매우 중요 | 중요)
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: PrioritySectionWidget(
                            priority: TaskPriority.veryImportant,
                            tasks: _getFilteredTasks(TaskPriority.veryImportant),
                            onTaskTap: _onTaskTap,
                            onTaskComplete: _onTaskComplete,
                            onTaskDelete: _onTaskDelete,
                            onTaskPriorityChanged: _onTaskPriorityChanged,
                          ),
                        ),
                        Expanded(
                          child: PrioritySectionWidget(
                            priority: TaskPriority.important,
                            tasks: _getFilteredTasks(TaskPriority.important),
                            onTaskTap: _onTaskTap,
                            onTaskComplete: _onTaskComplete,
                            onTaskDelete: _onTaskDelete,
                            onTaskPriorityChanged: _onTaskPriorityChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // 하단 행 (긴급 | 기타)
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: PrioritySectionWidget(
                            priority: TaskPriority.urgent,
                            tasks: _getFilteredTasks(TaskPriority.urgent),
                            onTaskTap: _onTaskTap,
                            onTaskComplete: _onTaskComplete,
                            onTaskDelete: _onTaskDelete,
                            onTaskPriorityChanged: _onTaskPriorityChanged,
                          ),
                        ),
                        Expanded(
                          child: PrioritySectionWidget(
                            priority: TaskPriority.other,
                            tasks: _getFilteredTasks(TaskPriority.other),
                            onTaskTap: _onTaskTap,
                            onTaskComplete: _onTaskComplete,
                            onTaskDelete: _onTaskDelete,
                            onTaskPriorityChanged: _onTaskPriorityChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 필터링된 태스크 목록 반환
  List<TaskModel> _getFilteredTasks(TaskPriority priority) {
    if (_selectedTag != null) {
      return _taskService.getTasksByTag(_selectedTag!)
          .where((task) => task.priority == priority)
          .toList();
    }
    return _taskService.getTasksByPriority(priority);
  }

  /// 태스크 탭 처리
  void _onTaskTap(TaskModel task) {
    context.push('/task-detail', extra: task.toMap());
  }

  /// 태스크 완료 처리
  void _onTaskComplete(TaskModel task) {
    setState(() {
      _taskService.toggleTaskCompletion(task.id);
    });
  }

  /// 태스크 삭제 처리
  void _onTaskDelete(TaskModel task) {
    setState(() {
      _taskService.deleteTask(task.id);
    });
  }

  /// 태스크 우선순위 변경 처리
  void _onTaskPriorityChanged(TaskModel task, TaskPriority newPriority) {
    setState(() {
      final success = _taskService.changeTaskPriority(task.id, newPriority);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${task.title}이(가) ${newPriority.displayName} 섹션으로 이동되었습니다',
              style: TextStyles.small.copyWith(color: Colors.white),
            ),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '할 일 이동에 실패했습니다',
              style: TextStyles.small.copyWith(color: Colors.white),
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

}
