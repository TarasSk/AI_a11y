// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overlay_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OverlayState {

 bool get hasOverlayPermission; bool get hasAccessibilityPermission; bool get isOverlayActive; bool get isLoading; GemmaModelStatus get modelStatus; int get downloadProgress; bool get isGenerating; String? get aiResponse; String? get lastScreenshotPath; String? get error;
/// Create a copy of OverlayState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverlayStateCopyWith<OverlayState> get copyWith => _$OverlayStateCopyWithImpl<OverlayState>(this as OverlayState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverlayState&&(identical(other.hasOverlayPermission, hasOverlayPermission) || other.hasOverlayPermission == hasOverlayPermission)&&(identical(other.hasAccessibilityPermission, hasAccessibilityPermission) || other.hasAccessibilityPermission == hasAccessibilityPermission)&&(identical(other.isOverlayActive, isOverlayActive) || other.isOverlayActive == isOverlayActive)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.modelStatus, modelStatus) || other.modelStatus == modelStatus)&&(identical(other.downloadProgress, downloadProgress) || other.downloadProgress == downloadProgress)&&(identical(other.isGenerating, isGenerating) || other.isGenerating == isGenerating)&&(identical(other.aiResponse, aiResponse) || other.aiResponse == aiResponse)&&(identical(other.lastScreenshotPath, lastScreenshotPath) || other.lastScreenshotPath == lastScreenshotPath)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,hasOverlayPermission,hasAccessibilityPermission,isOverlayActive,isLoading,modelStatus,downloadProgress,isGenerating,aiResponse,lastScreenshotPath,error);

@override
String toString() {
  return 'OverlayState(hasOverlayPermission: $hasOverlayPermission, hasAccessibilityPermission: $hasAccessibilityPermission, isOverlayActive: $isOverlayActive, isLoading: $isLoading, modelStatus: $modelStatus, downloadProgress: $downloadProgress, isGenerating: $isGenerating, aiResponse: $aiResponse, lastScreenshotPath: $lastScreenshotPath, error: $error)';
}


}

/// @nodoc
abstract mixin class $OverlayStateCopyWith<$Res>  {
  factory $OverlayStateCopyWith(OverlayState value, $Res Function(OverlayState) _then) = _$OverlayStateCopyWithImpl;
@useResult
$Res call({
 bool hasOverlayPermission, bool hasAccessibilityPermission, bool isOverlayActive, bool isLoading, GemmaModelStatus modelStatus, int downloadProgress, bool isGenerating, String? aiResponse, String? lastScreenshotPath, String? error
});




}
/// @nodoc
class _$OverlayStateCopyWithImpl<$Res>
    implements $OverlayStateCopyWith<$Res> {
  _$OverlayStateCopyWithImpl(this._self, this._then);

  final OverlayState _self;
  final $Res Function(OverlayState) _then;

/// Create a copy of OverlayState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hasOverlayPermission = null,Object? hasAccessibilityPermission = null,Object? isOverlayActive = null,Object? isLoading = null,Object? modelStatus = null,Object? downloadProgress = null,Object? isGenerating = null,Object? aiResponse = freezed,Object? lastScreenshotPath = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
hasOverlayPermission: null == hasOverlayPermission ? _self.hasOverlayPermission : hasOverlayPermission // ignore: cast_nullable_to_non_nullable
as bool,hasAccessibilityPermission: null == hasAccessibilityPermission ? _self.hasAccessibilityPermission : hasAccessibilityPermission // ignore: cast_nullable_to_non_nullable
as bool,isOverlayActive: null == isOverlayActive ? _self.isOverlayActive : isOverlayActive // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,modelStatus: null == modelStatus ? _self.modelStatus : modelStatus // ignore: cast_nullable_to_non_nullable
as GemmaModelStatus,downloadProgress: null == downloadProgress ? _self.downloadProgress : downloadProgress // ignore: cast_nullable_to_non_nullable
as int,isGenerating: null == isGenerating ? _self.isGenerating : isGenerating // ignore: cast_nullable_to_non_nullable
as bool,aiResponse: freezed == aiResponse ? _self.aiResponse : aiResponse // ignore: cast_nullable_to_non_nullable
as String?,lastScreenshotPath: freezed == lastScreenshotPath ? _self.lastScreenshotPath : lastScreenshotPath // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OverlayState].
extension OverlayStatePatterns on OverlayState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OverlayState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OverlayState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OverlayState value)  $default,){
final _that = this;
switch (_that) {
case _OverlayState():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OverlayState value)?  $default,){
final _that = this;
switch (_that) {
case _OverlayState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool hasOverlayPermission,  bool hasAccessibilityPermission,  bool isOverlayActive,  bool isLoading,  GemmaModelStatus modelStatus,  int downloadProgress,  bool isGenerating,  String? aiResponse,  String? lastScreenshotPath,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OverlayState() when $default != null:
return $default(_that.hasOverlayPermission,_that.hasAccessibilityPermission,_that.isOverlayActive,_that.isLoading,_that.modelStatus,_that.downloadProgress,_that.isGenerating,_that.aiResponse,_that.lastScreenshotPath,_that.error);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool hasOverlayPermission,  bool hasAccessibilityPermission,  bool isOverlayActive,  bool isLoading,  GemmaModelStatus modelStatus,  int downloadProgress,  bool isGenerating,  String? aiResponse,  String? lastScreenshotPath,  String? error)  $default,) {final _that = this;
switch (_that) {
case _OverlayState():
return $default(_that.hasOverlayPermission,_that.hasAccessibilityPermission,_that.isOverlayActive,_that.isLoading,_that.modelStatus,_that.downloadProgress,_that.isGenerating,_that.aiResponse,_that.lastScreenshotPath,_that.error);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool hasOverlayPermission,  bool hasAccessibilityPermission,  bool isOverlayActive,  bool isLoading,  GemmaModelStatus modelStatus,  int downloadProgress,  bool isGenerating,  String? aiResponse,  String? lastScreenshotPath,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _OverlayState() when $default != null:
return $default(_that.hasOverlayPermission,_that.hasAccessibilityPermission,_that.isOverlayActive,_that.isLoading,_that.modelStatus,_that.downloadProgress,_that.isGenerating,_that.aiResponse,_that.lastScreenshotPath,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _OverlayState implements OverlayState {
  const _OverlayState({this.hasOverlayPermission = false, this.hasAccessibilityPermission = false, this.isOverlayActive = false, this.isLoading = false, this.modelStatus = GemmaModelStatus.notInstalled, this.downloadProgress = 0, this.isGenerating = false, this.aiResponse, this.lastScreenshotPath, this.error});
  

@override@JsonKey() final  bool hasOverlayPermission;
@override@JsonKey() final  bool hasAccessibilityPermission;
@override@JsonKey() final  bool isOverlayActive;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  GemmaModelStatus modelStatus;
@override@JsonKey() final  int downloadProgress;
@override@JsonKey() final  bool isGenerating;
@override final  String? aiResponse;
@override final  String? lastScreenshotPath;
@override final  String? error;

/// Create a copy of OverlayState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OverlayStateCopyWith<_OverlayState> get copyWith => __$OverlayStateCopyWithImpl<_OverlayState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OverlayState&&(identical(other.hasOverlayPermission, hasOverlayPermission) || other.hasOverlayPermission == hasOverlayPermission)&&(identical(other.hasAccessibilityPermission, hasAccessibilityPermission) || other.hasAccessibilityPermission == hasAccessibilityPermission)&&(identical(other.isOverlayActive, isOverlayActive) || other.isOverlayActive == isOverlayActive)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.modelStatus, modelStatus) || other.modelStatus == modelStatus)&&(identical(other.downloadProgress, downloadProgress) || other.downloadProgress == downloadProgress)&&(identical(other.isGenerating, isGenerating) || other.isGenerating == isGenerating)&&(identical(other.aiResponse, aiResponse) || other.aiResponse == aiResponse)&&(identical(other.lastScreenshotPath, lastScreenshotPath) || other.lastScreenshotPath == lastScreenshotPath)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,hasOverlayPermission,hasAccessibilityPermission,isOverlayActive,isLoading,modelStatus,downloadProgress,isGenerating,aiResponse,lastScreenshotPath,error);

@override
String toString() {
  return 'OverlayState(hasOverlayPermission: $hasOverlayPermission, hasAccessibilityPermission: $hasAccessibilityPermission, isOverlayActive: $isOverlayActive, isLoading: $isLoading, modelStatus: $modelStatus, downloadProgress: $downloadProgress, isGenerating: $isGenerating, aiResponse: $aiResponse, lastScreenshotPath: $lastScreenshotPath, error: $error)';
}


}

/// @nodoc
abstract mixin class _$OverlayStateCopyWith<$Res> implements $OverlayStateCopyWith<$Res> {
  factory _$OverlayStateCopyWith(_OverlayState value, $Res Function(_OverlayState) _then) = __$OverlayStateCopyWithImpl;
@override @useResult
$Res call({
 bool hasOverlayPermission, bool hasAccessibilityPermission, bool isOverlayActive, bool isLoading, GemmaModelStatus modelStatus, int downloadProgress, bool isGenerating, String? aiResponse, String? lastScreenshotPath, String? error
});




}
/// @nodoc
class __$OverlayStateCopyWithImpl<$Res>
    implements _$OverlayStateCopyWith<$Res> {
  __$OverlayStateCopyWithImpl(this._self, this._then);

  final _OverlayState _self;
  final $Res Function(_OverlayState) _then;

/// Create a copy of OverlayState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hasOverlayPermission = null,Object? hasAccessibilityPermission = null,Object? isOverlayActive = null,Object? isLoading = null,Object? modelStatus = null,Object? downloadProgress = null,Object? isGenerating = null,Object? aiResponse = freezed,Object? lastScreenshotPath = freezed,Object? error = freezed,}) {
  return _then(_OverlayState(
hasOverlayPermission: null == hasOverlayPermission ? _self.hasOverlayPermission : hasOverlayPermission // ignore: cast_nullable_to_non_nullable
as bool,hasAccessibilityPermission: null == hasAccessibilityPermission ? _self.hasAccessibilityPermission : hasAccessibilityPermission // ignore: cast_nullable_to_non_nullable
as bool,isOverlayActive: null == isOverlayActive ? _self.isOverlayActive : isOverlayActive // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,modelStatus: null == modelStatus ? _self.modelStatus : modelStatus // ignore: cast_nullable_to_non_nullable
as GemmaModelStatus,downloadProgress: null == downloadProgress ? _self.downloadProgress : downloadProgress // ignore: cast_nullable_to_non_nullable
as int,isGenerating: null == isGenerating ? _self.isGenerating : isGenerating // ignore: cast_nullable_to_non_nullable
as bool,aiResponse: freezed == aiResponse ? _self.aiResponse : aiResponse // ignore: cast_nullable_to_non_nullable
as String?,lastScreenshotPath: freezed == lastScreenshotPath ? _self.lastScreenshotPath : lastScreenshotPath // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
