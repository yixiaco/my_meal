import 'dart:convert';

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

  static List<CookbookIngredients> fromJsonArrayString(String json) {
    final List<dynamic> dataList = jsonDecode(json);
    return dataList.map((e) => CookbookIngredients.fromJson(e)).toList();
  }

  factory CookbookIngredients.fromJsonObjectString(String json) {
    final data = jsonDecode(json);
    return CookbookIngredients.fromJson(data);
  }

  static String toJsonArrayString(List<CookbookIngredients> dataList) {
    final jsonList = dataList.map((e) => e.toJson()).toList();
    return jsonEncode(jsonList);
  }
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

  static List<CookbookStep> fromJsonArrayString(String json) {
    final List<dynamic> dataList = jsonDecode(json);
    return dataList.map((e) => CookbookStep.fromJson(e)).toList();
  }

  factory CookbookStep.fromJsonObjectString(String json) {
    final data = jsonDecode(json);
    return CookbookStep.fromJson(data);
  }

  static String toJsonArrayString(List<CookbookStep> dataList) {
    final jsonList = dataList.map((e) => e.toJson()).toList();
    return jsonEncode(jsonList);
  }
}

/// 菜谱数据传输对象
class CookbookDto {
  /// 菜谱
  late Cookbook _cookbook;

  /// 配料
  late List<CookbookIngredients> ingredients;

  /// 步骤
  late List<CookbookStep> steps;

  CookbookDto({
    Cookbook? cookbook,
    List<CookbookIngredients>? ingredients,
    List<CookbookStep>? steps,
  }) {
    _cookbook = cookbook ?? Cookbook();
    this.ingredients = ingredients ?? [];
    this.steps = steps ?? [];
  }

  /// 生成有效菜谱
  Cookbook get cookbook {
    _cookbook.ingredientsJson = CookbookIngredients.toJsonArrayString(ingredients);
    _cookbook.stepJson = CookbookStep.toJsonArrayString(steps);
    return _cookbook;
  }

  /// 从菜谱生成
  static CookbookDto fromCookbook(Cookbook cookbook) {
    final ingredients = CookbookIngredients.fromJsonArrayString(cookbook.ingredientsJson);
    final steps = CookbookStep.fromJsonArrayString(cookbook.stepJson);
    return CookbookDto(cookbook: cookbook, ingredients: ingredients, steps: steps);
  }

  /// 生成Map
  Map<String, dynamic> toMap() {
    return cookbook.toJson();
  }

  /// 从Map生成
  static CookbookDto fromMap(Map<String, dynamic> map) {
    final cookbook = Cookbook.fromJson(map);
    final ingredients = CookbookIngredients.fromJsonArrayString(cookbook.ingredientsJson);
    final steps = CookbookStep.fromJsonArrayString(cookbook.stepJson);
    return CookbookDto(cookbook: cookbook, ingredients: ingredients, steps: steps);
  }

  /// 从json生成
  static CookbookDto fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  /// 生成json
  String toJson() {
    return jsonEncode(toMap());
  }
}
