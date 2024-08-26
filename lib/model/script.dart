import 'package:freezed_annotation/freezed_annotation.dart';

part 'script.freezed.dart';
part 'script.g.dart';

@freezed
sealed class Script with _$Script {
  factory Script({
    String? docId,
    String? title,
    String? content,
    List<String>? videoUrls,
    int? timestamp,
  }) = _Script;

  factory Script.fromJson(Map<String, dynamic> json) => _$ScriptFromJson(json);
}
