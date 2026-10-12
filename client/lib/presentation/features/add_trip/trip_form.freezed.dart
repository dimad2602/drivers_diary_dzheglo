// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TripFormInput {

 DateTime get date; String get start; String get end; String get amount; String get commission; PaymentMethod get payment;
/// Create a copy of TripFormInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripFormInputCopyWith<TripFormInput> get copyWith => _$TripFormInputCopyWithImpl<TripFormInput>(this as TripFormInput, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TripFormInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripFormInput&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.start, _this.start) || other.start == _this.start)&&(identical(other.end, _this.end) || other.end == _this.end)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.commission, _this.commission) || other.commission == _this.commission)&&(identical(other.payment, _this.payment) || other.payment == _this.payment));
}


@override
int get hashCode {
  final _this = this as TripFormInput;
  return Object.hash(runtimeType,_this.date,_this.start,_this.end,_this.amount,_this.commission,_this.payment);
}

@override
String toString() {
  final _this = this as TripFormInput;
  return 'TripFormInput(date: ${_this.date}, start: ${_this.start}, end: ${_this.end}, amount: ${_this.amount}, commission: ${_this.commission}, payment: ${_this.payment})';
}


}

/// @nodoc
abstract mixin class $TripFormInputCopyWith<$Res>  {
  factory $TripFormInputCopyWith(TripFormInput value, $Res Function(TripFormInput) _then) = _$TripFormInputCopyWithImpl;
@useResult
$Res call({
 DateTime date, String start, String end, String amount, String commission, PaymentMethod payment
});




}
/// @nodoc
class _$TripFormInputCopyWithImpl<$Res>
    implements $TripFormInputCopyWith<$Res> {
  _$TripFormInputCopyWithImpl(this._self, this._then);

  final TripFormInput _self;
  final $Res Function(TripFormInput) _then;

/// Create a copy of TripFormInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? start = null,Object? end = null,Object? amount = null,Object? commission = null,Object? payment = null,}) {
  return _then(TripFormInput(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,commission: null == commission ? _self.commission : commission // ignore: cast_nullable_to_non_nullable
as String,payment: null == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as PaymentMethod,
  ));
}

}


/// Adds pattern-matching-related methods to [TripFormInput].
extension TripFormInputPatterns on TripFormInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripFormInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripFormInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripFormInput value)  $default,){
final _that = this;
switch (_that) {
case _TripFormInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripFormInput value)?  $default,){
final _that = this;
switch (_that) {
case _TripFormInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  String start,  String end,  String amount,  String commission,  PaymentMethod payment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripFormInput() when $default != null:
return $default(_that.date,_that.start,_that.end,_that.amount,_that.commission,_that.payment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  String start,  String end,  String amount,  String commission,  PaymentMethod payment)  $default,) {final _that = this;
switch (_that) {
case _TripFormInput():
return $default(_that.date,_that.start,_that.end,_that.amount,_that.commission,_that.payment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  String start,  String end,  String amount,  String commission,  PaymentMethod payment)?  $default,) {final _that = this;
switch (_that) {
case _TripFormInput() when $default != null:
return $default(_that.date,_that.start,_that.end,_that.amount,_that.commission,_that.payment);case _:
  return null;

}
}

}

/// @nodoc


class _TripFormInput implements TripFormInput {
  const _TripFormInput({required this.date, this.start = '', this.end = '', this.amount = '', this.commission = '', this.payment = PaymentMethod.card});
  

@override final  DateTime date;
@override@JsonKey() final  String start;
@override@JsonKey() final  String end;
@override@JsonKey() final  String amount;
@override@JsonKey() final  String commission;
@override@JsonKey() final  PaymentMethod payment;

/// Create a copy of TripFormInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripFormInputCopyWith<_TripFormInput> get copyWith => __$TripFormInputCopyWithImpl<_TripFormInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripFormInput&&(identical(other.date, date) || other.date == date)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.commission, commission) || other.commission == commission)&&(identical(other.payment, payment) || other.payment == payment));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,start,end,amount,commission,payment);
}

@override
String toString() {
    return 'TripFormInput(date: $date, start: $start, end: $end, amount: $amount, commission: $commission, payment: $payment)';
}


}

/// @nodoc
abstract mixin class _$TripFormInputCopyWith<$Res> implements $TripFormInputCopyWith<$Res> {
  factory _$TripFormInputCopyWith(_TripFormInput value, $Res Function(_TripFormInput) _then) = __$TripFormInputCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, String start, String end, String amount, String commission, PaymentMethod payment
});




}
/// @nodoc
class __$TripFormInputCopyWithImpl<$Res>
    implements _$TripFormInputCopyWith<$Res> {
  __$TripFormInputCopyWithImpl(this._self, this._then);

  final _TripFormInput _self;
  final $Res Function(_TripFormInput) _then;

/// Create a copy of TripFormInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? start = null,Object? end = null,Object? amount = null,Object? commission = null,Object? payment = null,}) {
  return _then(_TripFormInput(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,commission: null == commission ? _self.commission : commission // ignore: cast_nullable_to_non_nullable
as String,payment: null == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as PaymentMethod,
  ));
}


}

/// @nodoc
mixin _$TripFormResult {

 TripDraft? get draft; Map<TripFormField, TripFormError> get errors;
/// Create a copy of TripFormResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripFormResultCopyWith<TripFormResult> get copyWith => _$TripFormResultCopyWithImpl<TripFormResult>(this as TripFormResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TripFormResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripFormResult&&(identical(other.draft, _this.draft) || other.draft == _this.draft)&&const DeepCollectionEquality().equals(other.errors, _this.errors));
}


@override
int get hashCode {
  final _this = this as TripFormResult;
  return Object.hash(runtimeType,_this.draft,const DeepCollectionEquality().hash(_this.errors));
}

@override
String toString() {
  final _this = this as TripFormResult;
  return 'TripFormResult(draft: ${_this.draft}, errors: ${_this.errors})';
}


}

/// @nodoc
abstract mixin class $TripFormResultCopyWith<$Res>  {
  factory $TripFormResultCopyWith(TripFormResult value, $Res Function(TripFormResult) _then) = _$TripFormResultCopyWithImpl;
@useResult
$Res call({
 TripDraft? draft, Map<TripFormField, TripFormError> errors
});


$TripDraftCopyWith<$Res>? get draft;

}
/// @nodoc
class _$TripFormResultCopyWithImpl<$Res>
    implements $TripFormResultCopyWith<$Res> {
  _$TripFormResultCopyWithImpl(this._self, this._then);

  final TripFormResult _self;
  final $Res Function(TripFormResult) _then;

/// Create a copy of TripFormResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? draft = freezed,Object? errors = null,}) {
  return _then(TripFormResult(
draft: freezed == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as TripDraft?,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<TripFormField, TripFormError>,
  ));
}
/// Create a copy of TripFormResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TripDraftCopyWith<$Res>? get draft {
    if (_self.draft == null) {
    return null;
  }

  return $TripDraftCopyWith<$Res>(_self.draft!, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}


/// Adds pattern-matching-related methods to [TripFormResult].
extension TripFormResultPatterns on TripFormResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripFormResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripFormResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripFormResult value)  $default,){
final _that = this;
switch (_that) {
case _TripFormResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripFormResult value)?  $default,){
final _that = this;
switch (_that) {
case _TripFormResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TripDraft? draft,  Map<TripFormField, TripFormError> errors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripFormResult() when $default != null:
return $default(_that.draft,_that.errors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TripDraft? draft,  Map<TripFormField, TripFormError> errors)  $default,) {final _that = this;
switch (_that) {
case _TripFormResult():
return $default(_that.draft,_that.errors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TripDraft? draft,  Map<TripFormField, TripFormError> errors)?  $default,) {final _that = this;
switch (_that) {
case _TripFormResult() when $default != null:
return $default(_that.draft,_that.errors);case _:
  return null;

}
}

}

/// @nodoc


class _TripFormResult implements TripFormResult {
  const _TripFormResult({this.draft,  Map<TripFormField, TripFormError> errors = const {}}): _errors = errors;
  

@override final  TripDraft? draft;
 final  Map<TripFormField, TripFormError> _errors;
@override@JsonKey() Map<TripFormField, TripFormError> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}


/// Create a copy of TripFormResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripFormResultCopyWith<_TripFormResult> get copyWith => __$TripFormResultCopyWithImpl<_TripFormResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripFormResult&&(identical(other.draft, draft) || other.draft == draft)&&const DeepCollectionEquality().equals(other.errors, _errors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,draft,const DeepCollectionEquality().hash(_errors));
}

@override
String toString() {
    return 'TripFormResult(draft: $draft, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$TripFormResultCopyWith<$Res> implements $TripFormResultCopyWith<$Res> {
  factory _$TripFormResultCopyWith(_TripFormResult value, $Res Function(_TripFormResult) _then) = __$TripFormResultCopyWithImpl;
@override @useResult
$Res call({
 TripDraft? draft, Map<TripFormField, TripFormError> errors
});


@override $TripDraftCopyWith<$Res>? get draft;

}
/// @nodoc
class __$TripFormResultCopyWithImpl<$Res>
    implements _$TripFormResultCopyWith<$Res> {
  __$TripFormResultCopyWithImpl(this._self, this._then);

  final _TripFormResult _self;
  final $Res Function(_TripFormResult) _then;

/// Create a copy of TripFormResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? draft = freezed,Object? errors = null,}) {
  return _then(_TripFormResult(
draft: freezed == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as TripDraft?,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<TripFormField, TripFormError>,
  ));
}

/// Create a copy of TripFormResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TripDraftCopyWith<$Res>? get draft {
    if (_self.draft == null) {
    return null;
  }

  return $TripDraftCopyWith<$Res>(_self.draft!, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

// dart format on
