// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diary_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiaryEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DiaryEvent()';
}


}

/// @nodoc
class $DiaryEventCopyWith<$Res>  {
$DiaryEventCopyWith(DiaryEvent _, $Res Function(DiaryEvent) __);
}


/// Adds pattern-matching-related methods to [DiaryEvent].
extension DiaryEventPatterns on DiaryEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _DiaryStarted value)?  started,TResult Function( _DiaryReloadRequested value)?  reloadRequested,TResult Function( _DiaryDateSelected value)?  dateSelected,TResult Function( _DiaryPreviousDayRequested value)?  previousDayRequested,TResult Function( _DiaryNextDayRequested value)?  nextDayRequested,TResult Function( _DiaryTodayRequested value)?  todayRequested,TResult Function( _DiaryRefreshRequested value)?  refreshRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryStarted() when started != null:
return started(_that);case _DiaryReloadRequested() when reloadRequested != null:
return reloadRequested(_that);case _DiaryDateSelected() when dateSelected != null:
return dateSelected(_that);case _DiaryPreviousDayRequested() when previousDayRequested != null:
return previousDayRequested(_that);case _DiaryNextDayRequested() when nextDayRequested != null:
return nextDayRequested(_that);case _DiaryTodayRequested() when todayRequested != null:
return todayRequested(_that);case _DiaryRefreshRequested() when refreshRequested != null:
return refreshRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _DiaryStarted value)  started,required TResult Function( _DiaryReloadRequested value)  reloadRequested,required TResult Function( _DiaryDateSelected value)  dateSelected,required TResult Function( _DiaryPreviousDayRequested value)  previousDayRequested,required TResult Function( _DiaryNextDayRequested value)  nextDayRequested,required TResult Function( _DiaryTodayRequested value)  todayRequested,required TResult Function( _DiaryRefreshRequested value)  refreshRequested,}){
final _that = this;
switch (_that) {
case _DiaryStarted():
return started(_that);case _DiaryReloadRequested():
return reloadRequested(_that);case _DiaryDateSelected():
return dateSelected(_that);case _DiaryPreviousDayRequested():
return previousDayRequested(_that);case _DiaryNextDayRequested():
return nextDayRequested(_that);case _DiaryTodayRequested():
return todayRequested(_that);case _DiaryRefreshRequested():
return refreshRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _DiaryStarted value)?  started,TResult? Function( _DiaryReloadRequested value)?  reloadRequested,TResult? Function( _DiaryDateSelected value)?  dateSelected,TResult? Function( _DiaryPreviousDayRequested value)?  previousDayRequested,TResult? Function( _DiaryNextDayRequested value)?  nextDayRequested,TResult? Function( _DiaryTodayRequested value)?  todayRequested,TResult? Function( _DiaryRefreshRequested value)?  refreshRequested,}){
final _that = this;
switch (_that) {
case _DiaryStarted() when started != null:
return started(_that);case _DiaryReloadRequested() when reloadRequested != null:
return reloadRequested(_that);case _DiaryDateSelected() when dateSelected != null:
return dateSelected(_that);case _DiaryPreviousDayRequested() when previousDayRequested != null:
return previousDayRequested(_that);case _DiaryNextDayRequested() when nextDayRequested != null:
return nextDayRequested(_that);case _DiaryTodayRequested() when todayRequested != null:
return todayRequested(_that);case _DiaryRefreshRequested() when refreshRequested != null:
return refreshRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  reloadRequested,TResult Function( DateTime date)?  dateSelected,TResult Function()?  previousDayRequested,TResult Function()?  nextDayRequested,TResult Function()?  todayRequested,TResult Function( Completer<void>? completer)?  refreshRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryStarted() when started != null:
return started();case _DiaryReloadRequested() when reloadRequested != null:
return reloadRequested();case _DiaryDateSelected() when dateSelected != null:
return dateSelected(_that.date);case _DiaryPreviousDayRequested() when previousDayRequested != null:
return previousDayRequested();case _DiaryNextDayRequested() when nextDayRequested != null:
return nextDayRequested();case _DiaryTodayRequested() when todayRequested != null:
return todayRequested();case _DiaryRefreshRequested() when refreshRequested != null:
return refreshRequested(_that.completer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  reloadRequested,required TResult Function( DateTime date)  dateSelected,required TResult Function()  previousDayRequested,required TResult Function()  nextDayRequested,required TResult Function()  todayRequested,required TResult Function( Completer<void>? completer)  refreshRequested,}) {final _that = this;
switch (_that) {
case _DiaryStarted():
return started();case _DiaryReloadRequested():
return reloadRequested();case _DiaryDateSelected():
return dateSelected(_that.date);case _DiaryPreviousDayRequested():
return previousDayRequested();case _DiaryNextDayRequested():
return nextDayRequested();case _DiaryTodayRequested():
return todayRequested();case _DiaryRefreshRequested():
return refreshRequested(_that.completer);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  reloadRequested,TResult? Function( DateTime date)?  dateSelected,TResult? Function()?  previousDayRequested,TResult? Function()?  nextDayRequested,TResult? Function()?  todayRequested,TResult? Function( Completer<void>? completer)?  refreshRequested,}) {final _that = this;
switch (_that) {
case _DiaryStarted() when started != null:
return started();case _DiaryReloadRequested() when reloadRequested != null:
return reloadRequested();case _DiaryDateSelected() when dateSelected != null:
return dateSelected(_that.date);case _DiaryPreviousDayRequested() when previousDayRequested != null:
return previousDayRequested();case _DiaryNextDayRequested() when nextDayRequested != null:
return nextDayRequested();case _DiaryTodayRequested() when todayRequested != null:
return todayRequested();case _DiaryRefreshRequested() when refreshRequested != null:
return refreshRequested(_that.completer);case _:
  return null;

}
}

}

/// @nodoc


class _DiaryStarted implements DiaryEvent {
  const _DiaryStarted();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DiaryEvent.started()';
}


}




/// @nodoc


class _DiaryReloadRequested implements DiaryEvent {
  const _DiaryReloadRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryReloadRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DiaryEvent.reloadRequested()';
}


}




/// @nodoc


class _DiaryDateSelected implements DiaryEvent {
  const _DiaryDateSelected(this.date);
  

 final  DateTime date;

/// Create a copy of DiaryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryDateSelectedCopyWith<_DiaryDateSelected> get copyWith => __$DiaryDateSelectedCopyWithImpl<_DiaryDateSelected>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryDateSelected&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date);
}

@override
String toString() {
    return 'DiaryEvent.dateSelected(date: $date)';
}


}

/// @nodoc
abstract mixin class _$DiaryDateSelectedCopyWith<$Res> implements $DiaryEventCopyWith<$Res> {
  factory _$DiaryDateSelectedCopyWith(_DiaryDateSelected value, $Res Function(_DiaryDateSelected) _then) = __$DiaryDateSelectedCopyWithImpl;
@useResult
$Res call({
 DateTime date
});




}
/// @nodoc
class __$DiaryDateSelectedCopyWithImpl<$Res>
    implements _$DiaryDateSelectedCopyWith<$Res> {
  __$DiaryDateSelectedCopyWithImpl(this._self, this._then);

  final _DiaryDateSelected _self;
  final $Res Function(_DiaryDateSelected) _then;

/// Create a copy of DiaryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? date = null,}) {
  return _then(_DiaryDateSelected(
null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class _DiaryPreviousDayRequested implements DiaryEvent {
  const _DiaryPreviousDayRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryPreviousDayRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DiaryEvent.previousDayRequested()';
}


}




/// @nodoc


class _DiaryNextDayRequested implements DiaryEvent {
  const _DiaryNextDayRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryNextDayRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DiaryEvent.nextDayRequested()';
}


}




/// @nodoc


class _DiaryTodayRequested implements DiaryEvent {
  const _DiaryTodayRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryTodayRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DiaryEvent.todayRequested()';
}


}




/// @nodoc


class _DiaryRefreshRequested implements DiaryEvent {
  const _DiaryRefreshRequested({this.completer});
  

 final  Completer<void>? completer;

/// Create a copy of DiaryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryRefreshRequestedCopyWith<_DiaryRefreshRequested> get copyWith => __$DiaryRefreshRequestedCopyWithImpl<_DiaryRefreshRequested>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryRefreshRequested&&(identical(other.completer, completer) || other.completer == completer));
}


@override
int get hashCode {
    return Object.hash(runtimeType,completer);
}

@override
String toString() {
    return 'DiaryEvent.refreshRequested(completer: $completer)';
}


}

/// @nodoc
abstract mixin class _$DiaryRefreshRequestedCopyWith<$Res> implements $DiaryEventCopyWith<$Res> {
  factory _$DiaryRefreshRequestedCopyWith(_DiaryRefreshRequested value, $Res Function(_DiaryRefreshRequested) _then) = __$DiaryRefreshRequestedCopyWithImpl;
@useResult
$Res call({
 Completer<void>? completer
});




}
/// @nodoc
class __$DiaryRefreshRequestedCopyWithImpl<$Res>
    implements _$DiaryRefreshRequestedCopyWith<$Res> {
  __$DiaryRefreshRequestedCopyWithImpl(this._self, this._then);

  final _DiaryRefreshRequested _self;
  final $Res Function(_DiaryRefreshRequested) _then;

/// Create a copy of DiaryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? completer = freezed,}) {
  return _then(_DiaryRefreshRequested(
completer: freezed == completer ? _self.completer : completer // ignore: cast_nullable_to_non_nullable
as Completer<void>?,
  ));
}


}

/// @nodoc
mixin _$DiaryState {

 DateTime get date;
/// Create a copy of DiaryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryStateCopyWith<DiaryState> get copyWith => _$DiaryStateCopyWithImpl<DiaryState>(this as DiaryState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DiaryState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryState&&(identical(other.date, _this.date) || other.date == _this.date));
}


@override
int get hashCode {
  final _this = this as DiaryState;
  return Object.hash(runtimeType,_this.date);
}

@override
String toString() {
  final _this = this as DiaryState;
  return 'DiaryState(date: ${_this.date})';
}


}

/// @nodoc
abstract mixin class $DiaryStateCopyWith<$Res>  {
  factory $DiaryStateCopyWith(DiaryState value, $Res Function(DiaryState) _then) = _$DiaryStateCopyWithImpl;
@useResult
$Res call({
 DateTime date
});




}
/// @nodoc
class _$DiaryStateCopyWithImpl<$Res>
    implements $DiaryStateCopyWith<$Res> {
  _$DiaryStateCopyWithImpl(this._self, this._then);

  final DiaryState _self;
  final $Res Function(DiaryState) _then;

/// Create a copy of DiaryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DiaryState].
extension DiaryStatePatterns on DiaryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _DiaryLoading value)?  loading,TResult Function( _DiarySuccess value)?  success,TResult Function( _DiaryFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryLoading() when loading != null:
return loading(_that);case _DiarySuccess() when success != null:
return success(_that);case _DiaryFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _DiaryLoading value)  loading,required TResult Function( _DiarySuccess value)  success,required TResult Function( _DiaryFailure value)  failure,}){
final _that = this;
switch (_that) {
case _DiaryLoading():
return loading(_that);case _DiarySuccess():
return success(_that);case _DiaryFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _DiaryLoading value)?  loading,TResult? Function( _DiarySuccess value)?  success,TResult? Function( _DiaryFailure value)?  failure,}){
final _that = this;
switch (_that) {
case _DiaryLoading() when loading != null:
return loading(_that);case _DiarySuccess() when success != null:
return success(_that);case _DiaryFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( DateTime date)?  loading,TResult Function( DateTime date,  DayDiary diary,  bool isRefreshing,  TripsError? lastError)?  success,TResult Function( DateTime date,  TripsError error)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryLoading() when loading != null:
return loading(_that.date);case _DiarySuccess() when success != null:
return success(_that.date,_that.diary,_that.isRefreshing,_that.lastError);case _DiaryFailure() when failure != null:
return failure(_that.date,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( DateTime date)  loading,required TResult Function( DateTime date,  DayDiary diary,  bool isRefreshing,  TripsError? lastError)  success,required TResult Function( DateTime date,  TripsError error)  failure,}) {final _that = this;
switch (_that) {
case _DiaryLoading():
return loading(_that.date);case _DiarySuccess():
return success(_that.date,_that.diary,_that.isRefreshing,_that.lastError);case _DiaryFailure():
return failure(_that.date,_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( DateTime date)?  loading,TResult? Function( DateTime date,  DayDiary diary,  bool isRefreshing,  TripsError? lastError)?  success,TResult? Function( DateTime date,  TripsError error)?  failure,}) {final _that = this;
switch (_that) {
case _DiaryLoading() when loading != null:
return loading(_that.date);case _DiarySuccess() when success != null:
return success(_that.date,_that.diary,_that.isRefreshing,_that.lastError);case _DiaryFailure() when failure != null:
return failure(_that.date,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _DiaryLoading implements DiaryState {
  const _DiaryLoading({required this.date});
  

@override final  DateTime date;

/// Create a copy of DiaryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryLoadingCopyWith<_DiaryLoading> get copyWith => __$DiaryLoadingCopyWithImpl<_DiaryLoading>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryLoading&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date);
}

@override
String toString() {
    return 'DiaryState.loading(date: $date)';
}


}

/// @nodoc
abstract mixin class _$DiaryLoadingCopyWith<$Res> implements $DiaryStateCopyWith<$Res> {
  factory _$DiaryLoadingCopyWith(_DiaryLoading value, $Res Function(_DiaryLoading) _then) = __$DiaryLoadingCopyWithImpl;
@override @useResult
$Res call({
 DateTime date
});




}
/// @nodoc
class __$DiaryLoadingCopyWithImpl<$Res>
    implements _$DiaryLoadingCopyWith<$Res> {
  __$DiaryLoadingCopyWithImpl(this._self, this._then);

  final _DiaryLoading _self;
  final $Res Function(_DiaryLoading) _then;

/// Create a copy of DiaryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,}) {
  return _then(_DiaryLoading(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class _DiarySuccess implements DiaryState {
  const _DiarySuccess({required this.date, required this.diary, this.isRefreshing = false, this.lastError});
  

@override final  DateTime date;
 final  DayDiary diary;
@JsonKey() final  bool isRefreshing;
 final  TripsError? lastError;

/// Create a copy of DiaryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiarySuccessCopyWith<_DiarySuccess> get copyWith => __$DiarySuccessCopyWithImpl<_DiarySuccess>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiarySuccess&&(identical(other.date, date) || other.date == date)&&(identical(other.diary, diary) || other.diary == diary)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.lastError, lastError) || other.lastError == lastError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,diary,isRefreshing,lastError);
}

@override
String toString() {
    return 'DiaryState.success(date: $date, diary: $diary, isRefreshing: $isRefreshing, lastError: $lastError)';
}


}

/// @nodoc
abstract mixin class _$DiarySuccessCopyWith<$Res> implements $DiaryStateCopyWith<$Res> {
  factory _$DiarySuccessCopyWith(_DiarySuccess value, $Res Function(_DiarySuccess) _then) = __$DiarySuccessCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, DayDiary diary, bool isRefreshing, TripsError? lastError
});


$DayDiaryCopyWith<$Res> get diary;

}
/// @nodoc
class __$DiarySuccessCopyWithImpl<$Res>
    implements _$DiarySuccessCopyWith<$Res> {
  __$DiarySuccessCopyWithImpl(this._self, this._then);

  final _DiarySuccess _self;
  final $Res Function(_DiarySuccess) _then;

/// Create a copy of DiaryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? diary = null,Object? isRefreshing = null,Object? lastError = freezed,}) {
  return _then(_DiarySuccess(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,diary: null == diary ? _self.diary : diary // ignore: cast_nullable_to_non_nullable
as DayDiary,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as TripsError?,
  ));
}

/// Create a copy of DiaryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DayDiaryCopyWith<$Res> get diary {
  
  return $DayDiaryCopyWith<$Res>(_self.diary, (value) {
    return _then(_self.copyWith(diary: value));
  });
}
}

/// @nodoc


class _DiaryFailure implements DiaryState {
  const _DiaryFailure({required this.date, required this.error});
  

@override final  DateTime date;
 final  TripsError error;

/// Create a copy of DiaryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryFailureCopyWith<_DiaryFailure> get copyWith => __$DiaryFailureCopyWithImpl<_DiaryFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryFailure&&(identical(other.date, date) || other.date == date)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,error);
}

@override
String toString() {
    return 'DiaryState.failure(date: $date, error: $error)';
}


}

/// @nodoc
abstract mixin class _$DiaryFailureCopyWith<$Res> implements $DiaryStateCopyWith<$Res> {
  factory _$DiaryFailureCopyWith(_DiaryFailure value, $Res Function(_DiaryFailure) _then) = __$DiaryFailureCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, TripsError error
});




}
/// @nodoc
class __$DiaryFailureCopyWithImpl<$Res>
    implements _$DiaryFailureCopyWith<$Res> {
  __$DiaryFailureCopyWithImpl(this._self, this._then);

  final _DiaryFailure _self;
  final $Res Function(_DiaryFailure) _then;

/// Create a copy of DiaryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? error = null,}) {
  return _then(_DiaryFailure(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as TripsError,
  ));
}


}

// dart format on
