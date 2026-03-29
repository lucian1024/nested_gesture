import 'package:flutter_test/flutter_test.dart';
import 'package:nested_gesture/nested_gesture.dart';

void main() {
  group('DragPosition', () {
    test('initial position is Offset.zero', () {
      final dp = DragPosition();
      expect(dp.position, Offset.zero);
    });

    test('position is clamped within bounds', () {
      final dp = DragPosition(
        minPosition: const Offset(0, 0),
        maxPosition: const Offset(100, 100),
      );
      dp.position = const Offset(200, 200);
      expect(dp.position, const Offset(100, 100));

      dp.position = const Offset(-10, -10);
      expect(dp.position, const Offset(0, 0));
    });

    test('minPosition cannot be greater than maxPosition', () {
      final dp = DragPosition(
        minPosition: const Offset(0, 0),
        maxPosition: const Offset(100, 100),
      );
      dp.minPosition = const Offset(200, 200);
      // Should be ignored
      expect(dp.minPosition, const Offset(0, 0));
    });
  });
}
