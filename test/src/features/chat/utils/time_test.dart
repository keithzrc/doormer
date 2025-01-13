import 'package:doormer/src/features/chat/utils/time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Time Utils', () {
    test('formatTime should format hour and minute correctly', () {
      final testTime = DateTime(2024, 1, 1, 9, 5);
      expect(formatTime(testTime), equals('9:05'));
    });

    test('formatTime should pad minutes with zero when needed', () {
      final testTime = DateTime(2024, 1, 1, 14, 2);
      expect(formatTime(testTime), equals('14:02'));
    });

    test('formatTime should handle midnight correctly', () {
      final testTime = DateTime(2024, 1, 1, 0, 0);
      expect(formatTime(testTime), equals('0:00'));
    });

    test('formatTime should handle noon correctly', () {
      final testTime = DateTime(2024, 1, 1, 12, 30);
      expect(formatTime(testTime), equals('12:30'));
    });
  });
} 