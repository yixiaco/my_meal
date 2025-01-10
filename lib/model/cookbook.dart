import 'package:freezed_annotation/freezed_annotation.dart';

// 必要的：关联到 Freezed 代码生成器
part 'cookbook.freezed.dart';

// json
part 'cookbook.g.dart';

/// 菜谱
@unfreezed
class Cookbook with _$Cookbook {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory Cookbook({
    /// 菜谱id
    int? cookbookId,

    /// 菜谱标题
    @Default("") String title,

    /// 菜谱副标题
    String? subtitle,

    /// 菜谱封面
    String? coverImagePath,

    /// 配料json
    ///
    /// seek [CookbookIngredients]
    @Default("[]") String ingredientsJson,

    /// 步骤json
    ///
    /// seek [CookbookStep]
    @Default("[]") String stepJson,

    /// 更新时间
    DateTime? updateTime,

    /// 创建时间
    DateTime? createTime,
  }) = _Cookbook;

  factory Cookbook.fromJson(Map<String, Object?> json) => _$CookbookFromJson(json);
}

/// 菜谱配料
@unfreezed
class CookbookIngredients with _$CookbookIngredients {
  factory CookbookIngredients({
    /// 食材名称
    @Default("") String name,

    /// 食材用量
    @Default("") String dosage,
  }) = _CookbookIngredients;

  factory CookbookIngredients.fromJson(Map<String, Object?> json) => _$CookbookIngredientsFromJson(json);
}

/// 菜谱步骤
@unfreezed
class CookbookStep with _$CookbookStep {
  factory CookbookStep({
    /// 步骤图路径
    String? imagePath,

    /// 步骤描述
    @Default("") String description,
  }) = _CookbookStep;

  factory CookbookStep.fromJson(Map<String, Object?> json) => _$CookbookStepFromJson(json);
}
