// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gemini_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GeminiResult {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeminiResult);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GeminiResult()';
}


}

/// @nodoc
class $GeminiResultCopyWith<$Res>  {
$GeminiResultCopyWith(GeminiResult _, $Res Function(GeminiResult) __);
}


/// Adds pattern-matching-related methods to [GeminiResult].
extension GeminiResultPatterns on GeminiResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GeminiResultSuccess value)?  success,TResult Function( GeminiResultFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GeminiResultSuccess() when success != null:
return success(_that);case GeminiResultFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GeminiResultSuccess value)  success,required TResult Function( GeminiResultFailure value)  failure,}){
final _that = this;
switch (_that) {
case GeminiResultSuccess():
return success(_that);case GeminiResultFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GeminiResultSuccess value)?  success,TResult? Function( GeminiResultFailure value)?  failure,}){
final _that = this;
switch (_that) {
case GeminiResultSuccess() when success != null:
return success(_that);case GeminiResultFailure() when failure != null:
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
case GeminiResultSuccess() when success != null:
return success(_that.description);case GeminiResultFailure() when failure != null:
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
case GeminiResultSuccess():
return success(_that.description);case GeminiResultFailure():
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
case GeminiResultSuccess() when success != null:
return success(_that.description);case GeminiResultFailure() when failure != null:
return failure(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class GeminiResultSuccess implements GeminiResult {
  const GeminiResultSuccess({required this.description});
  

 final  String description;

/// Create a copy of GeminiResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeminiResultSuccessCopyWith<GeminiResultSuccess> get copyWith => _$GeminiResultSuccessCopyWithImpl<GeminiResultSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeminiResultSuccess&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,description);

@override
String toString() {
  return 'GeminiResult.success(description: $description)';
}


}

/// @nodoc
abstract mixin class $GeminiResultSuccessCopyWith<$Res> implements $GeminiResultCopyWith<$Res> {
  factory $GeminiResultSuccessCopyWith(GeminiResultSuccess value, $Res Function(GeminiResultSuccess) _then) = _$GeminiResultSuccessCopyWithImpl;
@useResult
$Res call({
 String description
});




}
/// @nodoc
class _$GeminiResultSuccessCopyWithImpl<$Res>
    implements $GeminiResultSuccessCopyWith<$Res> {
  _$GeminiResultSuccessCopyWithImpl(this._self, this._then);

  final GeminiResultSuccess _self;
  final $Res Function(GeminiResultSuccess) _then;

/// Create a copy of GeminiResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? description = null,}) {
  return _then(GeminiResultSuccess(
description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class GeminiResultFailure implements GeminiResult {
  const GeminiResultFailure({required this.error});
  

 final  String error;

/// Create a copy of GeminiResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeminiResultFailureCopyWith<GeminiResultFailure> get copyWith => _$GeminiResultFailureCopyWithImpl<GeminiResultFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeminiResultFailure&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'GeminiResult.failure(error: $error)';
}


}

/// @nodoc
abstract mixin class $GeminiResultFailureCopyWith<$Res> implements $GeminiResultCopyWith<$Res> {
  factory $GeminiResultFailureCopyWith(GeminiResultFailure value, $Res Function(GeminiResultFailure) _then) = _$GeminiResultFailureCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class _$GeminiResultFailureCopyWithImpl<$Res>
    implements $GeminiResultFailureCopyWith<$Res> {
  _$GeminiResultFailureCopyWithImpl(this._self, this._then);

  final GeminiResultFailure _self;
  final $Res Function(GeminiResultFailure) _then;

/// Create a copy of GeminiResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(GeminiResultFailure(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
