import 'package:driver_diary/domain/models/trip.dart';
import 'package:driver_diary/generated/l10n.dart';
import 'package:driver_diary/presentation/features/diary/widgets/trip_tile.dart';
import 'package:driver_diary/shared/ui/app_card_section.dart';
import 'package:flutter/material.dart';

class TripsList extends StatelessWidget {
  const TripsList({required this.trips, super.key});

  final List<Trip> trips;

  @override
  Widget build(BuildContext context) {
    return AppCardSection(
      header: S.of(context).diaryTripsHeader,
      children: [
        for (final trip in trips) TripTile(key: ValueKey(trip.id), trip: trip),
      ],
    );
  }
}
