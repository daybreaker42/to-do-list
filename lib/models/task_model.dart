import 'package:flutter/material.dart';

/// Task의 우선순위를 나타내는 열거형
enum TaskPriority {
  veryImportant('매우 중요', Color(0xFFFF6B6B)), // 빨간색 계열
  important('중요', Color(0xFFFF9F43)),        // 주황색 계열
  urgent('긴급', Color(0xFFFFD93D)),           // 노란색 계열
  other('기타', Color(0xFF74B9FF));            // 파란색 계열

  const TaskPriority(this.displayName, this.color);
  
  final String displayName;
  final Color color;
}

/// Task 데이터 모델
class TaskModel {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime? dueDate;
  final bool isCompleted;
  final bool isPinned;

  TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.priority,
    this.tags = const [],
    required this.createdAt,
    this.dueDate,
    this.isCompleted = false,
    this.isPinned = false,
  });

  /// Map에서 TaskModel 생성
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      priority: TaskPriority.values.firstWhere(
        (p) => p.name == map['priority'],
        orElse: () => TaskPriority.other,
      ),
      tags: List<String>.from(map['tags'] ?? []),
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
      dueDate: map['dueDate'] != null 
          ? DateTime.parse(map['dueDate']) 
          : null,
      isCompleted: map['isCompleted'] ?? false,
      isPinned: map['isPinned'] ?? false,
    );
  }

  /// TaskModel을 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.name,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted,
      'isPinned': isPinned,
    };
  }

  /// TaskModel 복사 (일부 필드 변경)
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? dueDate,
    bool? isCompleted,
    bool? isPinned,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TaskModel{id: $id, title: $title, priority: ${priority.displayName}}';
  }
}
