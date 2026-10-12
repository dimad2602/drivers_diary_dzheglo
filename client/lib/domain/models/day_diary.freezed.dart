// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_diary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DayDiary {

 DaySummary get summary; List<Trip> get trips;
/// Create a copy of DayDiary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayDiaryCopyWith<DayDiary> get copyWith => _$DayDiaryCopyWithImpl<DayDiary>(this as DayDiary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DayDiary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayDiary&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&const DeepCollectionEquality().equals(other.trips, _this.trips));
}


@override
int get hashCode {
  final _this = this as DayDiary;
  return Object.hash(runtimeType,_this.summary,const DeepCollectionEquality().hash(_this.trips));
}

@override
String toString() {
  final _this = this as DayDiary;
  return 'DayDiary(summary: ${_this.summary}, trips: ${_this.trips})';
}


}

/// @nodoc
abstract mixin class $DayDiaryCopyWith<$Res>  {
  factory $DayDiaryCopyWith(DayDiary value, $Res Function(DayDiary) _then) = _$DayDiaryCopyWithImpl;
@useResult
$Res call({
 DaySummary summary, List<Trip> trips
});


$DaySummaryCopyWith<$Res> get summary;

}
/// @nodoc
class _$DayDiaryCopyWithImpl<$Res>
    implements $DayDiaryCopyWith<$Res> {
  _$DayDiaryCopyWithImpl(this._self, this._then);

  final DayDiary _self;
  final $Res Function(DayDiary) _then;

/// Create a copy of DayDiary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summary = null,Object? trips = null,}) {
  return _then(DayDiary(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as DaySummary,trips: null == trips ? _self.trips : trips // ignore: cast_nullable_to_non_nullable
as List<Trip>,
  ));
}
/// Create a copy of DayDiary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DaySummaryCopyWith<$Res> get summary {
  
  return $DaySummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [DayDiary].
extension DayDiaryPatterns on DayDiary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayDiary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayDiary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayDiary value)  $default,){
final _that = this;
switch (_that) {
case _DayDiary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayDiary value)?  $default,){
final _that = this;
switch (_that) {
case _DayDiary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DaySummary summary,  List<Trip> trips)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayDiary() when $default != null:
return $default(_that.summary,_that.trips);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DaySummary summary,  List<Trip> trips)  $default,) {final _that = this;
switch (_that) {
case _DayDiary():
return $default(_that.summary,_that.trips);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DaySummary summary,  List<Trip> trips)?  $default,) {final _that = this;
switch (_that) {
case _DayDiary() when $default != null:
return $default(_that.summary,_that.trips);case _:
  return null;

}
}

}

/// @nodoc


class _DayDiary implements DayDiary {
  const _DayDiary({required this.summary, required  List<Trip> trips}): _trips = trips;
  

@override final  DaySummary summary;
 final  List<Trip> _trips;
@override List<Trip> get trips {
  if (_trips is EqualUnmodifiableListView) return _trips;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_trips);
}


/// Create a copy of DayDiary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayDiaryCopyWith<_DayDiary> get copyWith => __$DayDiaryCopyWithImpl<_DayDiary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayDiary&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.trips, _trips));
}


@override
int get hashCode {
    return Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(_trips));
}

@override
String toString() {
    return 'DayDiary(summary: $summary, trips: $trips)';
}


}

/// @nodoc
abstract mixin class _$DayDiaryCopyWith<$Res> implements $DayDiaryCopyWith<$Res> {
  factory _$DayDiaryCopyWith(_DayDiary value, $Res Function(_DayDiary) _then) = __$DayDiaryCopyWithImpl;
@override @useResult
$Res call({
 DaySummary summary, List<Trip> trips
});


@override $DaySummaryCopyWith<$Res> get summary;

}
/// @nodoc
class __$DayDiaryCopyWithImpl<$Res>
    implements _$DayDiaryCopyWith<$Res> {
  __$DayDiaryCopyWithImpl(this._self, this._then);

  final _DayDiary _self;
  final $Res Function(_DayDiary) _then;

/// Create a copy of DayDiary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? trips = null,}) {
  return _then(_DayDiary(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as DaySummary,trips: null == trips ? _self._trips : trips // ignore: cast_nullable_to_non_nullable
as List<Trip>,
  ));
}

/// Create a copy of DayDiary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DaySummaryCopyWith<$Res> get summary {
  
  return $DaySummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

// dart format on
