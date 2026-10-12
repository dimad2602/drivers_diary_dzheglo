import 'package:flutter_test/flutter_test.dart';

import '../helpers/fixtures.dart';

void main() {
  test('длительность и «на руки» считаются из полей поездки', () {
    final trip = makeTrip(amount: 2400, commission: 360);

    expect(trip.duration, const Duration(minutes: 22));
    expect(trip.net, 2040);
  });

  test('длительность считается по моментам, а не по часам на стене', () {
    final trip = makeTrip(start: at(1, 23, 50), end: at(2, 0, 20));

    expect(trip.duration, const Duration(minutes: 30));
  });
}
