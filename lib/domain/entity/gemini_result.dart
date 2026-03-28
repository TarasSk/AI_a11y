import 'package:freezed_annotation/freezed_annotation.dart';

part 'gemini_result.freezed.dart';

@freezed
sealed class GeminiResult with _$GeminiResult {
  const factory GeminiResult.success({required String description}) =
      GeminiResultSuccess;

  const factory GeminiResult.failure({required String error}) =
      GeminiResultFailure;
}
