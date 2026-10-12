// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offset_date_time.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OffsetDateTime {

 DateTime get instant; Duration get offset;
/// Create a copy of OffsetDateTime
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OffsetDateTimeCopyWith<OffsetDateTime> get copyWith => _$OffsetDateTimeCopyWithImpl<OffsetDateTime>(this as OffsetDateTime, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OffsetDateTime;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OffsetDateTime&&(identical(other.instant, _this.instant) || other.instant == _this.instant)&&(identical(other.offset, _this.offset) || other.offset == _this.offset));
}


@override
int get hashCode {
  final _this = this as OffsetDateTime;
  return Object.hash(runtimeType,_this.instant,_this.offset);
}

@override
String toString() {
  final _this = this as OffsetDateTime;
  return 'OffsetDateTime(instant: ${_this.instant}, offset: ${_this.offset})';
}


}

/// @nodoc
abstract mixin class $OffsetDateTimeCopyWith<$Res>  {
  factory $OffsetDateTimeCopyWith(OffsetDateTime value, $Res Function(OffsetDateTime) _then) = _$OffsetDateTimeCopyWithImpl;
@useResult
$Res call({
 DateTime instant, Duration offset
});




}
/// @nodoc
class _$OffsetDateTimeCopyWithImpl<$Res>
    implements $OffsetDateTimeCopyWith<$Res> {
  _$OffsetDateTimeCopyWithImpl(this._self, this._then);

  final OffsetDateTime _self;
  final $Res Function(OffsetDateTime) _then;

/// Create a copy of OffsetDateTime
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? instant = null,Object? offset = null,}) {
  return _then(OffsetDateTime(
instant: null == instant ? _self.instant : instant // ignore: cast_nullable_to_non_nullable
as DateTime,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}

}


/// Adds pattern-matching-related methods to [OffsetDateTime].
extension OffsetDateTimePatterns on OffsetDateTime {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OffsetDateTime value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OffsetDateTime() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OffsetDateTime value)  $default,){
final _that = this;
switch (_that) {
case _OffsetDateTime():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OffsetDateTime value)?  $default,){
final _that = this;
switch (_that) {
case _OffsetDateTime() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime instant,  Duration offset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OffsetDateTime() when $default != null:
return $default(_that.instant,_that.offset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime instant,  Duration offset)  $default,) {final _that = this;
switch (_that) {
case _OffsetDateTime():
return $default(_that.instant,_that.offset);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime instant,  Duration offset)?  $default,) {final _that = this;
switch (_that) {
case _OffsetDateTime() when $default != null:
return $default(_that.instant,_that.offset);case _:
  return null;

}
}

}

/// @nodoc


class _OffsetDateTime extends OffsetDateTime {
  const _OffsetDateTime({required this.instant, required this.offset}): super._();
  

@override final  DateTime instant;
@override final  Duration offset;

/// Create a copy of OffsetDateTime
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OffsetDateTimeCopyWith<_OffsetDateTime> get copyWith => __$OffsetDateTimeCopyWithImpl<_OffsetDateTime>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OffsetDateTime&&(identical(other.instant, instant) || other.instant == instant)&&(identical(other.offset, offset) || other.offset == offset));
}


@override
int get hashCode {
    return Object.hash(runtimeType,instant,offset);
}

@override
String toString() {
    return 'OffsetDateTime(instant: $instant, offset: $offset)';
}


}

/// @nodoc
abstract mixin class _$OffsetDateTimeCopyWith<$Res> implements $OffsetDateTimeCopyWith<$Res> {
  factory _$OffsetDateTimeCopyWith(_OffsetDateTime value, $Res Function(_OffsetDateTime) _then) = __$OffsetDateTimeCopyWithImpl;
@override @useResult
$Res call({
 DateTime instant, Duration offset
});




}
/// @nodoc
class __$OffsetDateTimeCopyWithImpl<$Res>
    implements _$OffsetDateTimeCopyWith<$Res> {
  __$OffsetDateTimeCopyWithImpl(this._self, this._then);

  final _OffsetDateTime _self;
  final $Res Function(_OffsetDateTime) _then;

/// Create a copy of OffsetDateTime
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? instant = null,Object? offset = null,}) {
  return _then(_OffsetDateTime(
instant: null == instant ? _self.instant : instant // ignore: cast_nullable_to_non_nullable
as DateTime,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

// dart format on
