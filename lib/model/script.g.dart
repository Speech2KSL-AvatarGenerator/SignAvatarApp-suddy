// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'script.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScriptImpl _$$ScriptImplFromJson(Map<String, dynamic> json) => _$ScriptImpl(
      docId: json['docId'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      videoUrls: (json['videoUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      timestamp: (json['timestamp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ScriptImplToJson(_$ScriptImpl instance) =>
    <String, dynamic>{
      'docId': instance.docId,
      'title': instance.title,
      'content': instance.content,
      'videoUrls': instance.videoUrls,
      'timestamp': instance.timestamp,
    };
