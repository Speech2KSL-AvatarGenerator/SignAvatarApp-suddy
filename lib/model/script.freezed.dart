// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'script.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Script _$ScriptFromJson(Map<String, dynamic> json) {
  return _Script.fromJson(json);
}

/// @nodoc
mixin _$Script {
  String? get docId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  List<String>? get videoUrls => throw _privateConstructorUsedError;
  int? get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScriptCopyWith<Script> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScriptCopyWith<$Res> {
  factory $ScriptCopyWith(Script value, $Res Function(Script) then) =
      _$ScriptCopyWithImpl<$Res, Script>;
  @useResult
  $Res call(
      {String? docId,
      String? title,
      String? content,
      List<String>? videoUrls,
      int? timestamp});
}

/// @nodoc
class _$ScriptCopyWithImpl<$Res, $Val extends Script>
    implements $ScriptCopyWith<$Res> {
  _$ScriptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? docId = freezed,
    Object? title = freezed,
    Object? content = freezed,
    Object? videoUrls = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_value.copyWith(
      docId: freezed == docId
          ? _value.docId
          : docId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      videoUrls: freezed == videoUrls
          ? _value.videoUrls
          : videoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScriptImplCopyWith<$Res> implements $ScriptCopyWith<$Res> {
  factory _$$ScriptImplCopyWith(
          _$ScriptImpl value, $Res Function(_$ScriptImpl) then) =
      __$$ScriptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? docId,
      String? title,
      String? content,
      List<String>? videoUrls,
      int? timestamp});
}

/// @nodoc
class __$$ScriptImplCopyWithImpl<$Res>
    extends _$ScriptCopyWithImpl<$Res, _$ScriptImpl>
    implements _$$ScriptImplCopyWith<$Res> {
  __$$ScriptImplCopyWithImpl(
      _$ScriptImpl _value, $Res Function(_$ScriptImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? docId = freezed,
    Object? title = freezed,
    Object? content = freezed,
    Object? videoUrls = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_$ScriptImpl(
      docId: freezed == docId
          ? _value.docId
          : docId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      videoUrls: freezed == videoUrls
          ? _value._videoUrls
          : videoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScriptImpl implements _Script {
  _$ScriptImpl(
      {this.docId,
      this.title,
      this.content,
      final List<String>? videoUrls,
      this.timestamp})
      : _videoUrls = videoUrls;

  factory _$ScriptImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScriptImplFromJson(json);

  @override
  final String? docId;
  @override
  final String? title;
  @override
  final String? content;
  final List<String>? _videoUrls;
  @override
  List<String>? get videoUrls {
    final value = _videoUrls;
    if (value == null) return null;
    if (_videoUrls is EqualUnmodifiableListView) return _videoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? timestamp;

  @override
  String toString() {
    return 'Script(docId: $docId, title: $title, content: $content, videoUrls: $videoUrls, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScriptImpl &&
            (identical(other.docId, docId) || other.docId == docId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality()
                .equals(other._videoUrls, _videoUrls) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, docId, title, content,
      const DeepCollectionEquality().hash(_videoUrls), timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScriptImplCopyWith<_$ScriptImpl> get copyWith =>
      __$$ScriptImplCopyWithImpl<_$ScriptImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScriptImplToJson(
      this,
    );
  }
}

abstract class _Script implements Script {
  factory _Script(
      {final String? docId,
      final String? title,
      final String? content,
      final List<String>? videoUrls,
      final int? timestamp}) = _$ScriptImpl;

  factory _Script.fromJson(Map<String, dynamic> json) = _$ScriptImpl.fromJson;

  @override
  String? get docId;
  @override
  String? get title;
  @override
  String? get content;
  @override
  List<String>? get videoUrls;
  @override
  int? get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$ScriptImplCopyWith<_$ScriptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
