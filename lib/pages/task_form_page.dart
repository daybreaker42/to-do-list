import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_list/config/theme.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/services/task_service.dart';

/// Task 생성/수정 폼 페이지
class TaskFormPage extends StatefulWidget {
  final TaskModel? existingTask; // null이면 새 Task 생성, 값이 있으면 수정

  const TaskFormPage({
    Key? key,
    this.existingTask,
  }) : super(key: key);

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final TaskService _taskService = TaskService();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagController = TextEditingController();
  
  TaskPriority _selectedPriority = TaskPriority.other;
  List<String> _tags = [];
  DateTime? _dueDate;
  bool _isPinned = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingTask != null) {
      _initializeWithExistingTask();
    }
  }

  void _initializeWithExistingTask() {
    final task = widget.existingTask!;
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _selectedPriority = task.priority;
    _tags = List.from(task.tags);
    _dueDate = task.dueDate;
    _isPinned = task.isPinned;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingTask != null;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          isEditing ? '할 일 수정' : '새 할 일',
          style: TextStyles.mainTitle,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.highlight),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (isEditing)
            TextButton(
              onPressed: _showDeleteDialog,
              child: Text(
                '삭제',
                style: TextStyles.subTitle.copyWith(color: AppColors.error),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(8.w),
          children: [
            // 제목 입력
            _buildSectionTitle('제목'),
            SizedBox(height: 8.h),
            TextFormField(
              controller: _titleController,
              style: TextStyles.taskTitle.copyWith(color: AppColors.primaryText),
              decoration: _buildInputDecoration('할 일 제목을 입력하세요'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '제목을 입력해주세요';
                }
                return null;
              },
            ),
            
            SizedBox(height: 24.h),
            
            // 설명 입력
            _buildSectionTitle('설명'),
            SizedBox(height: 8.h),
            TextFormField(
              controller: _descriptionController,
              style: TextStyles.caption.copyWith(color: AppColors.primaryText),
              decoration: _buildInputDecoration('상세 설명을 입력하세요 (선택사항)'),
              maxLines: 3,
            ),
            
            SizedBox(height: 24.h),
            
            // 우선순위 선택
            _buildSectionTitle('우선순위'),
            SizedBox(height: 8.h),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: TaskPriority.values.map((priority) {
                  return ListTile(
                    leading: Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: priority.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    title: Text(
                      priority.displayName,
                      style: TextStyles.subTitle.copyWith(
                        color: AppColors.primaryText,
                      ),
                    ),
                    trailing: Radio<TaskPriority>(
                      value: priority,
                      groupValue: _selectedPriority,
                      activeColor: priority.color,
                      onChanged: (value) {
                        setState(() {
                          _selectedPriority = value!;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _selectedPriority = priority;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // 태그 관리
            _buildSectionTitle('태그'),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _tagController,
                    style: TextStyles.caption.copyWith(color: AppColors.primaryText),
                    decoration: _buildInputDecoration('태그를 입력하세요'),
                    onFieldSubmitted: _addTag,
                  ),
                ),
                SizedBox(width: 8.w),
                ElevatedButton(
                  onPressed: () => _addTag(_tagController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.highlight,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  ),
                  child: Text('추가', style: TextStyles.small),
                ),
              ],
            ),
            
            SizedBox(height: 12.h),
            
            // 태그 목록
            if (_tags.isNotEmpty) ...[
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: _tags.map((tag) => Chip(
                  label: Text(
                    tag,
                    style: TextStyles.small.copyWith(color: AppColors.primaryText),
                  ),
                  backgroundColor: _selectedPriority.color.withOpacity(0.2),
                  deleteIcon: Icon(
                    Icons.close,
                    size: 16.sp,
                    color: AppColors.secondaryText,
                  ),
                  onDeleted: () => _removeTag(tag),
                )).toList(),
              ),
            ],
            
            SizedBox(height: 24.h),
            
            // 마감일 설정
            _buildSectionTitle('마감일'),
            SizedBox(height: 8.h),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              tileColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              leading: Icon(Icons.schedule, color: AppColors.highlight),
              title: Text(
                _dueDate != null 
                    ? _formatDate(_dueDate!)
                    : '마감일 설정 (선택사항)',
                style: TextStyles.subTitle.copyWith(
                  color: _dueDate != null 
                      ? AppColors.primaryText 
                      : AppColors.secondaryText,
                ),
              ),
              trailing: _dueDate != null 
                  ? IconButton(
                      icon: Icon(Icons.clear, color: AppColors.secondaryText),
                      onPressed: () => setState(() => _dueDate = null),
                    )
                  : Icon(Icons.chevron_right, color: AppColors.secondaryText),
              onTap: _selectDueDate,
            ),
            
            SizedBox(height: 24.h),
            
            // 고정 설정
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              tileColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              leading: Icon(
                Icons.push_pin,
                color: _isPinned ? _selectedPriority.color : AppColors.secondaryText,
              ),
              title: Text(
                '중요한 할 일로 고정',
                style: TextStyles.subTitle.copyWith(color: AppColors.primaryText),
              ),
              trailing: Switch(
                value: _isPinned,
                activeColor: _selectedPriority.color,
                onChanged: (value) => setState(() => _isPinned = value),
              ),
              onTap: () => setState(() => _isPinned = !_isPinned),
            ),
            
            SizedBox(height: 40.h),
            
            // 저장 버튼
            ElevatedButton(
              onPressed: _isLoading ? null : _saveTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedPriority.color,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      isEditing ? '수정 완료' : '할 일 추가',
                      style: TextStyles.subTitle.copyWith(color: Colors.white),
                    ),
            ),
            SizedBox(height: 40.h),
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

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyles.caption.copyWith(color: AppColors.secondaryText),
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: _selectedPriority.color, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    );
  }

  void _addTag(String tag) {
    final trimmedTag = tag.trim();
    if (trimmedTag.isNotEmpty && !_tags.contains(trimmedTag)) {
      setState(() {
        _tags.add(trimmedTag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: _selectedPriority.color,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDate ?? DateTime.now()),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.dark(
                primary: _selectedPriority.color,
                surface: AppColors.surface,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _dueDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays == 0) {
      return '오늘 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return '내일 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.month}/${date.day} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (widget.existingTask != null) {
        // 기존 Task 수정
        final updatedTask = widget.existingTask!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          priority: _selectedPriority,
          tags: _tags,
          dueDate: _dueDate,
          isPinned: _isPinned,
        );
        _taskService.updateTask(updatedTask);
      } else {
        // 새 Task 생성
        _taskService.createTask(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          priority: _selectedPriority,
          tags: _tags,
          dueDate: _dueDate,
          isPinned: _isPinned,
        );
      }

       // 성공 메시지 표시
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text(
             widget.existingTask != null ? '할 일이 수정되었습니다' : '할 일이 추가되었습니다',
             style: TextStyles.small.copyWith(color: Colors.white),
           ),
           backgroundColor: AppColors.success,
         ),
       );

       // 홈 화면으로 돌아가기
       if (mounted) {
         context.pop();
       }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '오류가 발생했습니다: $e',
            style: TextStyles.small.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
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
    if (widget.existingTask != null) {
      _taskService.deleteTask(widget.existingTask!.id);
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text(
             '할 일이 삭제되었습니다',
             style: TextStyles.small.copyWith(color: Colors.white),
           ),
           backgroundColor: AppColors.success,
         ),
       );
      context.go('/home');
    }
  }
}
