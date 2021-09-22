// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoItem _$TodoItemFromJson(Map<String, dynamic> json) {
  return TodoItem(
    id: json['id'] as int,
    title: json['title'] as String,
    isCompleted: json['isCompleted'] as bool,
    userId: json['userId'] as int,
    openDate: DateTime.parse(json['openDate'] as String),
    closeDate: DateTime.parse(json['closeDate'] as String),
  );
}

Map<String, dynamic> _$TodoItemToJson(TodoItem instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isCompleted': instance.isCompleted,
      'userId': instance.userId,
      'openDate': instance.openDate.toIso8601String(),
      'closeDate': instance.closeDate.toIso8601String(),
    };
