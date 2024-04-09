import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moto_mecanico/models/distance.dart';

// Tests are forcing errors, so drop the error logs.
void debugHandler(message, {wrapWidth}) {}

void main() {
  debugPrint = debugHandler;

  group('Distance Model Tests', () {
    test('distance isValid', () {
      const invalid = Distance(null);
      const valid = Distance(0);

      expect(invalid.isValid, equals(false));
      expect(valid.isValid, equals(true));
    });

    test('convert km to km', () {
      const km = Distance(100000, DistanceUnit.unitKm);
      expect(km.unit, equals(DistanceUnit.unitKm));
      expect(km.distance, equals(100000));

      final km2 = km.toUnit(DistanceUnit.unitKm);
      expect(km2.unit, equals(DistanceUnit.unitKm));
      expect(km2.distance, equals(100000));
    });

    test('convert km to miles', () {
      const km = Distance(100000, DistanceUnit.unitKm);

      final mile = km.toUnit(DistanceUnit.unitMile);
      expect(mile.unit, equals(DistanceUnit.unitMile));
      expect(mile.distance, equals(62137));
    });

    test('convert km to miles rounds value', () {
      const km = Distance(1, DistanceUnit.unitKm);

      final mile = km.toUnit(DistanceUnit.unitMile);
      expect(mile.unit, equals(DistanceUnit.unitMile));
      expect(mile.distance, equals(1));
    });

    test('convert miles to km', () {
      const miles = Distance(50, DistanceUnit.unitMile);

      final km = miles.toUnit(DistanceUnit.unitKm);
      expect(km.unit, equals(DistanceUnit.unitKm));
      expect(km.distance, equals(80));
    });

    test('add miles to km', () {
      const miles = Distance(50, DistanceUnit.unitMile);
      const km = Distance(80, DistanceUnit.unitKm);

      final result = km + miles;
      expect(result.unit, equals(DistanceUnit.unitKm));
      expect(result.distance, equals(160));
    });

    test('compare km and miles', () {
      const miles = Distance(50, DistanceUnit.unitMile);
      const km = Distance(80, DistanceUnit.unitKm);
      const small = Distance(1, DistanceUnit.unitKm);

      expect(small, lessThan(km));
      expect(small, lessThan(miles));
      expect(small, lessThanOrEqualTo(miles));
      expect(km, greaterThan(small));
      expect(km, greaterThanOrEqualTo(small));
      expect(miles, greaterThan(small));

      expect(km.compareTo(miles), equals(0));
      expect(km, equals(miles));
      expect(km, greaterThanOrEqualTo(miles));
      expect(km, lessThanOrEqualTo(miles));

      expect(small, isNot(equals(km)));
      expect(small.compareTo(km), equals(-1));
    });

    test('JSON round trip (miles)', () {
      const distance = Distance(32, DistanceUnit.unitMile);
      final distanceParsed = Distance.fromJson(distance.toJson());
      expect(distanceParsed, isNotNull);
      expect(distanceParsed.unit, equals(DistanceUnit.unitMile));
      expect(distanceParsed.distance, equals(32));
    });

    test('JSON round trip (km)', () {
      const distance = Distance(23, DistanceUnit.unitKm);
      final distanceParsed = Distance.fromJson(distance.toJson());
      expect(distanceParsed, isNotNull);
      expect(distanceParsed.unit, equals(DistanceUnit.unitKm));
      expect(distanceParsed.distance, equals(23));
    });

    test('JSON parse missing fields', () {
      var distance = Distance.fromJson(jsonDecode('{}'));
      expect(distance, equals(const Distance(null)));

      // Both distance and unit must be filled for a distance to be valid
      distance = Distance.fromJson(jsonDecode('{"distance": 12}'));
      expect(distance, equals(const Distance(null)));

      distance =
          Distance.fromJson(jsonDecode('{"distance": 12, "unit": "mile"}'));
      expect(distance.unit, equals(DistanceUnit.unitMile));
      expect(distance.distance, equals(12));
    });
  });
}
