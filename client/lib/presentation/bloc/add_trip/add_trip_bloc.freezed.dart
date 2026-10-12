// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_trip_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddTripEvent {

 TripDraft get draft;
/// Create a copy of AddTripEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddTripEventCopyWith<AddTripEvent> get copyWith => _$AddTripEventCopyWithImpl<AddTripEvent>(this as AddTripEvent, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AddTripEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddTripEvent&&(identical(other.draft, _this.draft) || other.draft == _this.draft));
}


@override
int get hashCode {
  final _this = this as AddTripEvent;
  return Object.hash(runtimeType,_this.draft);
}

@override
String toString() {
  final _this = this as AddTripEvent;
  return 'AddTripEvent(draft: ${_this.draft})';
}


}

/// @nodoc
abstract mixin class $AddTripEventCopyWith<$Res>  {
  factory $AddTripEventCopyWith(AddTripEvent value, $Res Function(AddTripEvent) _then) = _$AddTripEventCopyWithImpl;
@useResult
$Res call({
 TripDraft draft
});


$TripDraftCopyWith<$Res> get draft;

}
/// @nodoc
class _$AddTripEventCopyWithImpl<$Res>
    implements $AddTripEventCopyWith<$Res> {
  _$AddTripEventCopyWithImpl(this._self, this._then);

  final AddTripEvent _self;
  final $Res Function(AddTripEvent) _then;

/// Create a copy of AddTripEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? draft = null,}) {
  return _then(AddTripEvent.submitted(
null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as TripDraft,
  ));
}
/// Create a copy of AddTripEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TripDraftCopyWith<$Res> get draft {
  
  return $TripDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}


/// Adds pattern-matching-related methods to [AddTripEvent].
extension AddTripEventPatterns on AddTripEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AddTripSubmitted value)?  submitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddTripSubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AddTripSubmitted value)  submitted,}){
final _that = this;
switch (_that) {
case _AddTripSubmitted():
return submitted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AddTripSubmitted value)?  submitted,}){
final _that = this;
switch (_that) {
case _AddTripSubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( TripDraft draft)?  submitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddTripSubmitted() when submitted != null:
return submitted(_that.draft);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( TripDraft draft)  submitted,}) {final _that = this;
switch (_that) {
case _AddTripSubmitted():
return submitted(_that.draft);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( TripDraft draft)?  submitted,}) {final _that = this;
switch (_that) {
case _AddTripSubmitted() when submitted != null:
return submitted(_that.draft);case _:
  return null;

}
}

}

/// @nodoc


class _AddTripSubmitted implements AddTripEvent {
  const _AddTripSubmitted(this.draft);
  

@override final  TripDraft draft;

/// Create a copy of AddTripEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddTripSubmittedCopyWith<_AddTripSubmitted> get copyWith => __$AddTripSubmittedCopyWithImpl<_AddTripSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddTripSubmitted&&(identical(other.draft, draft) || other.draft == draft));
}


@override
int get hashCode {
    return Object.hash(runtimeType,draft);
}

@override
String toString() {
    return 'AddTripEvent.submitted(draft: $draft)';
}


}

/// @nodoc
abstract mixin class _$AddTripSubmittedCopyWith<$Res> implements $AddTripEventCopyWith<$Res> {
  factory _$AddTripSubmittedCopyWith(_AddTripSubmitted value, $Res Function(_AddTripSubmitted) _then) = __$AddTripSubmittedCopyWithImpl;
@override @useResult
$Res call({
 TripDraft draft
});


@override $TripDraftCopyWith<$Res> get draft;

}
/// @nodoc
class __$AddTripSubmittedCopyWithImpl<$Res>
    implements _$AddTripSubmittedCopyWith<$Res> {
  __$AddTripSubmittedCopyWithImpl(this._self, this._then);

  final _AddTripSubmitted _self;
  final $Res Function(_AddTripSubmitted) _then;

/// Create a copy of AddTripEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? draft = null,}) {
  return _then(_AddTripSubmitted(
null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as TripDraft,
  ));
}

/// Create a copy of AddTripEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TripDraftCopyWith<$Res> get draft {
  
  return $TripDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

/// @nodoc
mixin _$AddTripState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AddTripState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AddTripState()';
}


}

/// @nodoc
class $AddTripStateCopyWith<$Res>  {
$AddTripStateCopyWith(AddTripState _, $Res Function(AddTripState) __);
}


/// Adds pattern-matching-related methods to [AddTripState].
extension AddTripStatePatterns on AddTripState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AddTripInitial value)?  initial,TResult Function( _AddTripSubmitting value)?  submitting,TResult Function( _AddTripSuccess value)?  success,TResult Function( _AddTripFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddTripInitial() when initial != null:
return initial(_that);case _AddTripSubmitting() when submitting != null:
return submitting(_that);case _AddTripSuccess() when success != null:
return success(_that);case _AddTripFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AddTripInitial value)  initial,required TResult Function( _AddTripSubmitting value)  submitting,required TResult Function( _AddTripSuccess value)  success,required TResult Function( _AddTripFailure value)  failure,}){
final _that = this;
switch (_that) {
case _AddTripInitial():
return initial(_that);case _AddTripSubmitting():
return submitting(_that);case _AddTripSuccess():
return success(_that);case _AddTripFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AddTripInitial value)?  initial,TResult? Function( _AddTripSubmitting value)?  submitting,TResult? Function( _AddTripSuccess value)?  success,TResult? Function( _AddTripFailure value)?  failure,}){
final _that = this;
switch (_that) {
case _AddTripInitial() when initial != null:
return initial(_that);case _AddTripSubmitting() when submitting != null:
return submitting(_that);case _AddTripSuccess() when success != null:
return success(_that);case _AddTripFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  submitting,TResult Function( Trip trip)?  success,TResult Function( TripsError error)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddTripInitial() when initial != null:
return initial();case _AddTripSubmitting() when submitting != null:
return submitting();case _AddTripSuccess() when success != null:
return success(_that.trip);case _AddTripFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  submitting,required TResult Function( Trip trip)  success,required TResult Function( TripsError error)  failure,}) {final _that = this;
switch (_that) {
case _AddTripInitial():
return initial();case _AddTripSubmitting():
return submitting();case _AddTripSuccess():
return success(_that.trip);case _AddTripFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  submitting,TResult? Function( Trip trip)?  success,TResult? Function( TripsError error)?  failure,}) {final _that = this;
switch (_that) {
case _AddTripInitial() when initial != null:
return initial();case _AddTripSubmitting() when submitting != null:
return submitting();case _AddTripSuccess() when success != null:
return success(_that.trip);case _AddTripFailure() when failure != null:
return failure(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _AddTripInitial implements AddTripState {
  const _AddTripInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddTripInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AddTripState.initial()';
}


}




/// @nodoc


class _AddTripSubmitting implements AddTripState {
  const _AddTripSubmitting();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddTripSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AddTripState.submitting()';
}


}




/// @nodoc


class _AddTripSuccess implements AddTripState {
  const _AddTripSuccess(this.trip);
  

 final  Trip trip;

/// Create a copy of AddTripState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddTripSuccessCopyWith<_AddTripSuccess> get copyWith => __$AddTripSuccessCopyWithImpl<_AddTripSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddTripSuccess&&(identical(other.trip, trip) || other.trip == trip));
}


@override
int get hashCode {
    return Object.hash(runtimeType,trip);
}

@override
String toString() {
    return 'AddTripState.success(trip: $trip)';
}


}

/// @nodoc
abstract mixin class _$AddTripSuccessCopyWith<$Res> implements $AddTripStateCopyWith<$Res> {
  factory _$AddTripSuccessCopyWith(_AddTripSuccess value, $Res Function(_AddTripSuccess) _then) = __$AddTripSuccessCopyWithImpl;
@useResult
$Res call({
 Trip trip
});


$TripCopyWith<$Res> get trip;

}
/// @nodoc
class __$AddTripSuccessCopyWithImpl<$Res>
    implements _$AddTripSuccessCopyWith<$Res> {
  __$AddTripSuccessCopyWithImpl(this._self, this._then);

  final _AddTripSuccess _self;
  final $Res Function(_AddTripSuccess) _then;

/// Create a copy of AddTripState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? trip = null,}) {
  return _then(_AddTripSuccess(
null == trip ? _self.trip : trip // ignore: cast_nullable_to_non_nullable
as Trip,
  ));
}

/// Create a copy of AddTripState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TripCopyWith<$Res> get trip {
  
  return $TripCopyWith<$Res>(_self.trip, (value) {
    return _then(_self.copyWith(trip: value));
  });
}
}

/// @nodoc


class _AddTripFailure implements AddTripState {
  const _AddTripFailure(this.error);
  

 final  TripsError error;

/// Create a copy of AddTripState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddTripFailureCopyWith<_AddTripFailure> get copyWith => __$AddTripFailureCopyWithImpl<_AddTripFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddTripFailure&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,error);
}

@override
String toString() {
    return 'AddTripState.failure(error: $error)';
}


}

/// @nodoc
abstract mixin class _$AddTripFailureCopyWith<$Res> implements $AddTripStateCopyWith<$Res> {
  factory _$AddTripFailureCopyWith(_AddTripFailure value, $Res Function(_AddTripFailure) _then) = __$AddTripFailureCopyWithImpl;
@useResult
$Res call({
 TripsError error
});




}
/// @nodoc
class __$AddTripFailureCopyWithImpl<$Res>
    implements _$AddTripFailureCopyWith<$Res> {
  __$AddTripFailureCopyWithImpl(this._self, this._then);

  final _AddTripFailure _self;
  final $Res Function(_AddTripFailure) _then;

/// Create a copy of AddTripState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_AddTripFailure(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as TripsError,
  ));
}


}

// dart format on
