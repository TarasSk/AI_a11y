// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'process_screenshot_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProcessScreenshotResult {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProcessScreenshotResult);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProcessScreenshotResult()';
}


}

/// @nodoc
class $ProcessScreenshotResultCopyWith<$Res>  {
$ProcessScreenshotResultCopyWith(ProcessScreenshotResult _, $Res Function(ProcessScreenshotResult) __);
}


/// Adds pattern-matching-related methods to [ProcessScreenshotResult].
extension ProcessScreenshotResultPatterns on ProcessScreenshotResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProcessScreenshotSuccess value)?  success,TResult Function( ProcessScreenshotFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProcessScreenshotSuccess() when success != null:
return success(_that);case ProcessScreenshotFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProcessScreenshotSuccess value)  success,required TResult Function( ProcessScreenshotFailure value)  failure,}){
final _that = this;
switch (_that) {
case ProcessScreenshotSuccess():
return success(_that);case ProcessScreenshotFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProcessScreenshotSuccess value)?  success,TResult? Function( ProcessScreenshotFailure value)?  failure,}){
final _that = this;
switch (_that) {
case ProcessScreenshotSuccess() when success != null:
return success(_that);case ProcessScreenshotFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String description)?  success,TResult Function( String error)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProcessScreenshotSuccess() when success != null:
return success(_that.description);case ProcessScreenshotFailure() when failure != null:
return failure(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String description)  success,required TResult Function( String error)  failure,}) {final _that = this;
switch (_that) {
case ProcessScreenshotSuccess():
return success(_that.description);case ProcessScreenshotFailure():
return failure(_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String description)?  success,TResult? Function( String error)?  failure,}) {final _that = this;
switch (_that) {
case ProcessScreenshotSuccess() when success != null:
return success(_that.description);case ProcessScreenshotFailure() when failure != null:
return failure(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class ProcessScreenshotSuccess implements ProcessScreenshotResult {
  const ProcessScreenshotSuccess({required this.description});
  

 final  String description;

/// Create a copy of ProcessScreenshotResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProcessScreenshotSuccessCopyWith<ProcessScreenshotSuccess> get copyWith => _$ProcessScreenshotSuccessCopyWithImpl<ProcessScreenshotSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProcessScreenshotSuccess&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,description);

@override
String toString() {
  return 'ProcessScreenshotResult.success(description: $description)';
}


}

/// @nodoc
abstract mixin class $ProcessScreenshotSuccessCopyWith<$Res> implements $ProcessScreenshotResultCopyWith<$Res> {
  factory $ProcessScreenshotSuccessCopyWith(ProcessScreenshotSuccess value, $Res Function(ProcessScreenshotSuccess) _then) = _$ProcessScreenshotSuccessCopyWithImpl;
@useResult
$Res call({
 String description
});




}
/// @nodoc
class _$ProcessScreenshotSuccessCopyWithImpl<$Res>
    implements $ProcessScreenshotSuccessCopyWith<$Res> {
  _$ProcessScreenshotSuccessCopyWithImpl(this._self, this._then);

  final ProcessScreenshotSuccess _self;
  final $Res Function(ProcessScreenshotSuccess) _then;

/// Create a copy of ProcessScreenshotResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? description = null,}) {
  return _then(ProcessScreenshotSuccess(
description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ProcessScreenshotFailure implements ProcessScreenshotResult {
  const ProcessScreenshotFailure({required this.error});
  

 final  String error;

/// Create a copy of ProcessScreenshotResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProcessScreenshotFailureCopyWith<ProcessScreenshotFailure> get copyWith => _$ProcessScreenshotFailureCopyWithImpl<ProcessScreenshotFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProcessScreenshotFailure&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'ProcessScreenshotResult.failure(error: $error)';
}


}

/// @nodoc
abstract mixin class $ProcessScreenshotFailureCopyWith<$Res> implements $ProcessScreenshotResultCopyWith<$Res> {
  factory $ProcessScreenshotFailureCopyWith(ProcessScreenshotFailure value, $Res Function(ProcessScreenshotFailure) _then) = _$ProcessScreenshotFailureCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class _$ProcessScreenshotFailureCopyWithImpl<$Res>
    implements $ProcessScreenshotFailureCopyWith<$Res> {
  _$ProcessScreenshotFailureCopyWithImpl(this._self, this._then);

  final ProcessScreenshotFailure _self;
  final $Res Function(ProcessScreenshotFailure) _then;

/// Create a copy of ProcessScreenshotResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(ProcessScreenshotFailure(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
