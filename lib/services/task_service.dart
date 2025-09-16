import 'dart:math';
import '../models/task_model.dart';

/// Task 관리 서비스 클래스
class TaskService {
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal();

  // 임시 데이터 저장소 (실제 앱에서는 데이터베이스나 API 사용)
  final List<TaskModel> _tasks = [];

  /// 모든 Task 조회
  List<TaskModel> getAllTasks() {
    return List.unmodifiable(_tasks);
  }

  /// 우선순위별 Task 조회 (완료된 것도 포함)
  List<TaskModel> getTasksByPriority(TaskPriority priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  /// 태그별 Task 조회 (완료된 것도 포함)
  List<TaskModel> getTasksByTag(String tag) {
    return _tasks.where((task) => task.tags.contains(tag)).toList();
  }

  /// 완료된 Task 조회
  List<TaskModel> getCompletedTasks() {
    return _tasks.where((task) => task.isCompleted).toList();
  }

  /// Task ID로 조회
  TaskModel? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 새 Task 생성
  TaskModel createTask({
    required String title,
    String description = '',
    required TaskPriority priority,
    List<String> tags = const [],
    DateTime? dueDate,
    bool isPinned = false,
  }) {
    final task = TaskModel(
      id: _generateId(),
      title: title,
      description: description,
      priority: priority,
      tags: List.from(tags),
      createdAt: DateTime.now(),
      dueDate: dueDate,
      isPinned: isPinned,
    );
    
    _tasks.add(task);
    return task;
  }

  /// Task 업데이트
  bool updateTask(TaskModel updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      return true;
    }
    return false;
  }

  /// Task 삭제
  bool deleteTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks.removeAt(index);
      return true;
    }
    return false;
  }

  /// Task 완료 상태 토글
  bool toggleTaskCompletion(String id) {
    final task = getTaskById(id);
    if (task != null) {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      return updateTask(updatedTask);
    }
    return false;
  }

  /// Task 우선순위 변경
  bool changeTaskPriority(String id, TaskPriority newPriority) {
    final task = getTaskById(id);
    if (task != null) {
      final updatedTask = task.copyWith(priority: newPriority);
      return updateTask(updatedTask);
    }
    return false;
  }

  /// 모든 태그 목록 조회
  List<String> getAllTags() {
    final allTags = <String>{};
    for (final task in _tasks) {
      allTags.addAll(task.tags);
    }
    return allTags.toList()..sort();
  }

  /// ID 생성기
  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }

  /// 샘플 데이터 초기화
  void initializeSampleData() {
    if (_tasks.isNotEmpty) return;

    // 샘플 태스크들 생성
    createTask(
      title: '프로젝트 기획서 작성',
      description: '새 프로젝트의 요구사항 분석 및 기획서 작성',
      priority: TaskPriority.veryImportant,
      tags: ['업무', '기획'],
      dueDate: DateTime.now().add(const Duration(days: 3)),
      isPinned: true,
    );
    
    createTask(
      title: '회의 준비',
      description: '오후 3시 팀 미팅 자료 준비',
      priority: TaskPriority.urgent,
      tags: ['회의', '업무'],
      dueDate: DateTime.now().add(const Duration(hours: 4)),
    );
    
    createTask(
      title: '운동하기',
      description: '헬스장에서 1시간 운동',
      priority: TaskPriority.important,
      tags: ['건강', '개인'],
    );
    
    createTask(
      title: '장보기',
      description: '마트에서 생필품 구매',
      priority: TaskPriority.other,
      tags: ['생활', '쇼핑'],
    );
    
    createTask(
      title: '독서',
      description: '새로 산 책 읽기',
      priority: TaskPriority.other,
      tags: ['독서', '개인'],
    );
  }
}
