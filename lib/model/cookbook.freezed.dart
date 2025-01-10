// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cookbook.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Cookbook _$CookbookFromJson(Map<String, dynamic> json) {
  return _Cookbook.fromJson(json);
}

/// @nodoc
mixin _$Cookbook {
  /// 菜谱id
  int? get cookbookId => throw _privateConstructorUsedError;

  /// 菜谱id
  set cookbookId(int? value) => throw _privateConstructorUsedError;

  /// 菜谱标题
  String get title => throw _privateConstructorUsedError;

  /// 菜谱标题
  set title(String value) => throw _privateConstructorUsedError;

  /// 菜谱副标题
  String? get subtitle => throw _privateConstructorUsedError;

  /// 菜谱副标题
  set subtitle(String? value) => throw _privateConstructorUsedError;

  /// 菜谱封面
  String? get coverImagePath => throw _privateConstructorUsedError;

  /// 菜谱封面
  set coverImagePath(String? value) => throw _privateConstructorUsedError;

  /// 配料json
  ///
  /// seek [CookbookIngredients]
  String get ingredientsJson => throw _privateConstructorUsedError;

  /// 配料json
  ///
  /// seek [CookbookIngredients]
  set ingredientsJson(String value) => throw _privateConstructorUsedError;

  /// 步骤json
  ///
  /// seek [CookbookStep]
  String get stepJson => throw _privateConstructorUsedError;

  /// 步骤json
  ///
  /// seek [CookbookStep]
  set stepJson(String value) => throw _privateConstructorUsedError;

  /// 更新时间
  DateTime? get updateTime => throw _privateConstructorUsedError;

  /// 更新时间
  set updateTime(DateTime? value) => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime? get createTime => throw _privateConstructorUsedError;

  /// 创建时间
  set createTime(DateTime? value) => throw _privateConstructorUsedError;

  /// Serializes this Cookbook to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Cookbook
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CookbookCopyWith<Cookbook> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CookbookCopyWith<$Res> {
  factory $CookbookCopyWith(Cookbook value, $Res Function(Cookbook) then) =
      _$CookbookCopyWithImpl<$Res, Cookbook>;
  @useResult
  $Res call(
      {int? cookbookId,
      String title,
      String? subtitle,
      String? coverImagePath,
      String ingredientsJson,
      String stepJson,
      DateTime? updateTime,
      DateTime? createTime});
}

/// @nodoc
class _$CookbookCopyWithImpl<$Res, $Val extends Cookbook>
    implements $CookbookCopyWith<$Res> {
  _$CookbookCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Cookbook
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cookbookId = freezed,
    Object? title = null,
    Object? subtitle = freezed,
    Object? coverImagePath = freezed,
    Object? ingredientsJson = null,
    Object? stepJson = null,
    Object? updateTime = freezed,
    Object? createTime = freezed,
  }) {
    return _then(_value.copyWith(
      cookbookId: freezed == cookbookId
          ? _value.cookbookId
          : cookbookId // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImagePath: freezed == coverImagePath
          ? _value.coverImagePath
          : coverImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      ingredientsJson: null == ingredientsJson
          ? _value.ingredientsJson
          : ingredientsJson // ignore: cast_nullable_to_non_nullable
              as String,
      stepJson: null == stepJson
          ? _value.stepJson
          : stepJson // ignore: cast_nullable_to_non_nullable
              as String,
      updateTime: freezed == updateTime
          ? _value.updateTime
          : updateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createTime: freezed == createTime
          ? _value.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CookbookImplCopyWith<$Res>
    implements $CookbookCopyWith<$Res> {
  factory _$$CookbookImplCopyWith(
          _$CookbookImpl value, $Res Function(_$CookbookImpl) then) =
      __$$CookbookImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? cookbookId,
      String title,
      String? subtitle,
      String? coverImagePath,
      String ingredientsJson,
      String stepJson,
      DateTime? updateTime,
      DateTime? createTime});
}

/// @nodoc
class __$$CookbookImplCopyWithImpl<$Res>
    extends _$CookbookCopyWithImpl<$Res, _$CookbookImpl>
    implements _$$CookbookImplCopyWith<$Res> {
  __$$CookbookImplCopyWithImpl(
      _$CookbookImpl _value, $Res Function(_$CookbookImpl) _then)
      : super(_value, _then);

  /// Create a copy of Cookbook
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cookbookId = freezed,
    Object? title = null,
    Object? subtitle = freezed,
    Object? coverImagePath = freezed,
    Object? ingredientsJson = null,
    Object? stepJson = null,
    Object? updateTime = freezed,
    Object? createTime = freezed,
  }) {
    return _then(_$CookbookImpl(
      cookbookId: freezed == cookbookId
          ? _value.cookbookId
          : cookbookId // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImagePath: freezed == coverImagePath
          ? _value.coverImagePath
          : coverImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      ingredientsJson: null == ingredientsJson
          ? _value.ingredientsJson
          : ingredientsJson // ignore: cast_nullable_to_non_nullable
              as String,
      stepJson: null == stepJson
          ? _value.stepJson
          : stepJson // ignore: cast_nullable_to_non_nullable
              as String,
      updateTime: freezed == updateTime
          ? _value.updateTime
          : updateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createTime: freezed == createTime
          ? _value.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$CookbookImpl implements _Cookbook {
  _$CookbookImpl(
      {this.cookbookId,
      this.title = "",
      this.subtitle,
      this.coverImagePath,
      this.ingredientsJson = "[]",
      this.stepJson = "[]",
      this.updateTime,
      this.createTime});

  factory _$CookbookImpl.fromJson(Map<String, dynamic> json) =>
      _$$CookbookImplFromJson(json);

  /// 菜谱id
  @override
  int? cookbookId;

  /// 菜谱标题
  @override
  @JsonKey()
  String title;

  /// 菜谱副标题
  @override
  String? subtitle;

  /// 菜谱封面
  @override
  String? coverImagePath;

  /// 配料json
  ///
  /// seek [CookbookIngredients]
  @override
  @JsonKey()
  String ingredientsJson;

  /// 步骤json
  ///
  /// seek [CookbookStep]
  @override
  @JsonKey()
  String stepJson;

  /// 更新时间
  @override
  DateTime? updateTime;

  /// 创建时间
  @override
  DateTime? createTime;

  @override
  String toString() {
    return 'Cookbook(cookbookId: $cookbookId, title: $title, subtitle: $subtitle, coverImagePath: $coverImagePath, ingredientsJson: $ingredientsJson, stepJson: $stepJson, updateTime: $updateTime, createTime: $createTime)';
  }

  /// Create a copy of Cookbook
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CookbookImplCopyWith<_$CookbookImpl> get copyWith =>
      __$$CookbookImplCopyWithImpl<_$CookbookImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CookbookImplToJson(
      this,
    );
  }
}

abstract class _Cookbook implements Cookbook {
  factory _Cookbook(
      {int? cookbookId,
      String title,
      String? subtitle,
      String? coverImagePath,
      String ingredientsJson,
      String stepJson,
      DateTime? updateTime,
      DateTime? createTime}) = _$CookbookImpl;

  factory _Cookbook.fromJson(Map<String, dynamic> json) =
      _$CookbookImpl.fromJson;

  /// 菜谱id
  @override
  int? get cookbookId;

  /// 菜谱id
  set cookbookId(int? value);

  /// 菜谱标题
  @override
  String get title;

  /// 菜谱标题
  set title(String value);

  /// 菜谱副标题
  @override
  String? get subtitle;

  /// 菜谱副标题
  set subtitle(String? value);

  /// 菜谱封面
  @override
  String? get coverImagePath;

  /// 菜谱封面
  set coverImagePath(String? value);

  /// 配料json
  ///
  /// seek [CookbookIngredients]
  @override
  String get ingredientsJson;

  /// 配料json
  ///
  /// seek [CookbookIngredients]
  set ingredientsJson(String value);

  /// 步骤json
  ///
  /// seek [CookbookStep]
  @override
  String get stepJson;

  /// 步骤json
  ///
  /// seek [CookbookStep]
  set stepJson(String value);

  /// 更新时间
  @override
  DateTime? get updateTime;

  /// 更新时间
  set updateTime(DateTime? value);

  /// 创建时间
  @override
  DateTime? get createTime;

  /// 创建时间
  set createTime(DateTime? value);

  /// Create a copy of Cookbook
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CookbookImplCopyWith<_$CookbookImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CookbookIngredients _$CookbookIngredientsFromJson(Map<String, dynamic> json) {
  return _CookbookIngredients.fromJson(json);
}

/// @nodoc
mixin _$CookbookIngredients {
  /// 食材名称
  String get name => throw _privateConstructorUsedError;

  /// 食材名称
  set name(String value) => throw _privateConstructorUsedError;

  /// 食材用量
  String get dosage => throw _privateConstructorUsedError;

  /// 食材用量
  set dosage(String value) => throw _privateConstructorUsedError;

  /// Serializes this CookbookIngredients to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CookbookIngredients
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CookbookIngredientsCopyWith<CookbookIngredients> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CookbookIngredientsCopyWith<$Res> {
  factory $CookbookIngredientsCopyWith(
          CookbookIngredients value, $Res Function(CookbookIngredients) then) =
      _$CookbookIngredientsCopyWithImpl<$Res, CookbookIngredients>;
  @useResult
  $Res call({String name, String dosage});
}

/// @nodoc
class _$CookbookIngredientsCopyWithImpl<$Res, $Val extends CookbookIngredients>
    implements $CookbookIngredientsCopyWith<$Res> {
  _$CookbookIngredientsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CookbookIngredients
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? dosage = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dosage: null == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CookbookIngredientsImplCopyWith<$Res>
    implements $CookbookIngredientsCopyWith<$Res> {
  factory _$$CookbookIngredientsImplCopyWith(_$CookbookIngredientsImpl value,
          $Res Function(_$CookbookIngredientsImpl) then) =
      __$$CookbookIngredientsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String dosage});
}

/// @nodoc
class __$$CookbookIngredientsImplCopyWithImpl<$Res>
    extends _$CookbookIngredientsCopyWithImpl<$Res, _$CookbookIngredientsImpl>
    implements _$$CookbookIngredientsImplCopyWith<$Res> {
  __$$CookbookIngredientsImplCopyWithImpl(_$CookbookIngredientsImpl _value,
      $Res Function(_$CookbookIngredientsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CookbookIngredients
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? dosage = null,
  }) {
    return _then(_$CookbookIngredientsImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dosage: null == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CookbookIngredientsImpl implements _CookbookIngredients {
  _$CookbookIngredientsImpl({this.name = "", this.dosage = ""});

  factory _$CookbookIngredientsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CookbookIngredientsImplFromJson(json);

  /// 食材名称
  @override
  @JsonKey()
  String name;

  /// 食材用量
  @override
  @JsonKey()
  String dosage;

  @override
  String toString() {
    return 'CookbookIngredients(name: $name, dosage: $dosage)';
  }

  /// Create a copy of CookbookIngredients
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CookbookIngredientsImplCopyWith<_$CookbookIngredientsImpl> get copyWith =>
      __$$CookbookIngredientsImplCopyWithImpl<_$CookbookIngredientsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CookbookIngredientsImplToJson(
      this,
    );
  }
}

abstract class _CookbookIngredients implements CookbookIngredients {
  factory _CookbookIngredients({String name, String dosage}) =
      _$CookbookIngredientsImpl;

  factory _CookbookIngredients.fromJson(Map<String, dynamic> json) =
      _$CookbookIngredientsImpl.fromJson;

  /// 食材名称
  @override
  String get name;

  /// 食材名称
  set name(String value);

  /// 食材用量
  @override
  String get dosage;

  /// 食材用量
  set dosage(String value);

  /// Create a copy of CookbookIngredients
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CookbookIngredientsImplCopyWith<_$CookbookIngredientsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CookbookStep _$CookbookStepFromJson(Map<String, dynamic> json) {
  return _CookbookStep.fromJson(json);
}

/// @nodoc
mixin _$CookbookStep {
  /// 步骤图路径
  String? get imagePath => throw _privateConstructorUsedError;

  /// 步骤图路径
  set imagePath(String? value) => throw _privateConstructorUsedError;

  /// 步骤描述
  String get description => throw _privateConstructorUsedError;

  /// 步骤描述
  set description(String value) => throw _privateConstructorUsedError;

  /// Serializes this CookbookStep to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CookbookStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CookbookStepCopyWith<CookbookStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CookbookStepCopyWith<$Res> {
  factory $CookbookStepCopyWith(
          CookbookStep value, $Res Function(CookbookStep) then) =
      _$CookbookStepCopyWithImpl<$Res, CookbookStep>;
  @useResult
  $Res call({String? imagePath, String description});
}

/// @nodoc
class _$CookbookStepCopyWithImpl<$Res, $Val extends CookbookStep>
    implements $CookbookStepCopyWith<$Res> {
  _$CookbookStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CookbookStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imagePath = freezed,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CookbookStepImplCopyWith<$Res>
    implements $CookbookStepCopyWith<$Res> {
  factory _$$CookbookStepImplCopyWith(
          _$CookbookStepImpl value, $Res Function(_$CookbookStepImpl) then) =
      __$$CookbookStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? imagePath, String description});
}

/// @nodoc
class __$$CookbookStepImplCopyWithImpl<$Res>
    extends _$CookbookStepCopyWithImpl<$Res, _$CookbookStepImpl>
    implements _$$CookbookStepImplCopyWith<$Res> {
  __$$CookbookStepImplCopyWithImpl(
      _$CookbookStepImpl _value, $Res Function(_$CookbookStepImpl) _then)
      : super(_value, _then);

  /// Create a copy of CookbookStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imagePath = freezed,
    Object? description = null,
  }) {
    return _then(_$CookbookStepImpl(
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CookbookStepImpl implements _CookbookStep {
  _$CookbookStepImpl({this.imagePath, this.description = ""});

  factory _$CookbookStepImpl.fromJson(Map<String, dynamic> json) =>
      _$$CookbookStepImplFromJson(json);

  /// 步骤图路径
  @override
  String? imagePath;

  /// 步骤描述
  @override
  @JsonKey()
  String description;

  @override
  String toString() {
    return 'CookbookStep(imagePath: $imagePath, description: $description)';
  }

  /// Create a copy of CookbookStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CookbookStepImplCopyWith<_$CookbookStepImpl> get copyWith =>
      __$$CookbookStepImplCopyWithImpl<_$CookbookStepImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CookbookStepImplToJson(
      this,
    );
  }
}

abstract class _CookbookStep implements CookbookStep {
  factory _CookbookStep({String? imagePath, String description}) =
      _$CookbookStepImpl;

  factory _CookbookStep.fromJson(Map<String, dynamic> json) =
      _$CookbookStepImpl.fromJson;

  /// 步骤图路径
  @override
  String? get imagePath;

  /// 步骤图路径
  set imagePath(String? value);

  /// 步骤描述
  @override
  String get description;

  /// 步骤描述
  set description(String value);

  /// Create a copy of CookbookStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CookbookStepImplCopyWith<_$CookbookStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
