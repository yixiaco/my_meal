// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cookbook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CookbookImpl _$$CookbookImplFromJson(Map<String, dynamic> json) =>
    _$CookbookImpl(
      cookbookId: (json['cookbook_id'] as num?)?.toInt(),
      title: json['title'] as String? ?? "",
      subtitle: json['subtitle'] as String?,
      coverImagePath: json['cover_image_path'] as String?,
      ingredientsJson: json['ingredients_json'] as String? ?? "[]",
      stepJson: json['step_json'] as String? ?? "[]",
      updateTime: json['update_time'] == null
          ? null
          : DateTime.parse(json['update_time'] as String),
      createTime: json['create_time'] == null
          ? null
          : DateTime.parse(json['create_time'] as String),
    );

Map<String, dynamic> _$$CookbookImplToJson(_$CookbookImpl instance) =>
    <String, dynamic>{
      'cookbook_id': instance.cookbookId,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'cover_image_path': instance.coverImagePath,
      'ingredients_json': instance.ingredientsJson,
      'step_json': instance.stepJson,
      'update_time': instance.updateTime?.toIso8601String(),
      'create_time': instance.createTime?.toIso8601String(),
    };

_$CookbookIngredientsImpl _$$CookbookIngredientsImplFromJson(
        Map<String, dynamic> json) =>
    _$CookbookIngredientsImpl(
      name: json['name'] as String? ?? "",
      dosage: json['dosage'] as String? ?? "",
    );

Map<String, dynamic> _$$CookbookIngredientsImplToJson(
        _$CookbookIngredientsImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'dosage': instance.dosage,
    };

_$CookbookStepImpl _$$CookbookStepImplFromJson(Map<String, dynamic> json) =>
    _$CookbookStepImpl(
      imagePath: json['imagePath'] as String?,
      description: json['description'] as String? ?? "",
    );

Map<String, dynamic> _$$CookbookStepImplToJson(_$CookbookStepImpl instance) =>
    <String, dynamic>{
      'imagePath': instance.imagePath,
      'description': instance.description,
    };
