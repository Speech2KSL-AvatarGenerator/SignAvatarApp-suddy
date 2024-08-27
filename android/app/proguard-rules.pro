# Firebase 예외 처리 규칙
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# FFmpegKit 예외 처리 규칙
-keep class com.arthenica.ffmpegkit.** { *; }

# video_player 패키지 보호 규칙
-keep class io.flutter.plugins.video_player.** { *; }
-keep class com.google.android.exoplayer2.** { *; }
-keep class com.google.android.exoplayer2.source.** { *; }
-keep class com.google.android.exoplayer2.ui.** { *; }
-keep class com.google.android.exoplayer2.trackselection.** { *; }
-keep class com.google.android.exoplayer2.extractor.** { *; }
-keep class com.google.android.exoplayer2.upstream.** { *; }
-keep class com.google.android.exoplayer2.util.** { *; }
-keep class com.google.android.exoplayer2.audio.** { *; }
-keep class com.google.android.exoplayer2.video.** { *; }
-keep class com.google.android.exoplayer2.player.** { *; }
-keep class com.google.android.exoplayer2.transformer.** { *; }