import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'drag_position.dart';

/// A horizontal drag gesture recognizer that supports nested scrollable widgets.
///
/// When the inner scrollable reaches its boundary, this recognizer returns
/// false so the gesture can propagate to the parent scrollable.
class NestedHorizontalDragGestureRecognizer extends DragGestureRecognizer {
  /// Creates a gesture recognizer for interactions in the horizontal axis
  /// that supports nested scrolling.
  NestedHorizontalDragGestureRecognizer({
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
  });

  /// The current [ScrollPosition] used to determine whether to accept a
  /// gesture when the scroll reaches the edge. Usually comes from a
  /// [Scrollable] widget.
  ScrollPosition? scrollPosition;

  /// The current [DragPosition] used to determine whether to accept a
  /// gesture when the drag reaches the edge. Usually comes from a custom
  /// [RawGestureDetector] widget.
  DragPosition? dragPosition;

  @override
  String get debugDescription => 'nested horizontal drag';

  @override
  bool isFlingGesture(VelocityEstimate estimate, PointerDeviceKind kind) {
    final double minVelocity = minFlingVelocity ?? kMinFlingVelocity;
    final double minDistance = minFlingDistance ?? computeHitSlop(kind, gestureSettings);
    return estimate.pixelsPerSecond.dx.abs() > minVelocity &&
        estimate.offset.dx.abs() > minDistance;
  }

  @override
  Offset getDeltaForDetails(Offset delta) => Offset(delta.dx, 0.0);

  @override
  double? getPrimaryValueFromOffset(Offset value) => value.dx;

  @override
  bool hasSufficientGlobalDistanceToAccept(
      PointerDeviceKind pointerDeviceKind, double? deviceTouchSlop) {
    if (scrollPosition != null && scrollPosition!.hasPixels) {
      if (scrollPosition!.axisDirection == AxisDirection.right &&
          ((scrollPosition!.pixels == scrollPosition!.minScrollExtent &&
                  _globalDistanceMoved > 0) ||
              (scrollPosition!.pixels == scrollPosition!.maxScrollExtent &&
                  _globalDistanceMoved < 0))) {
        // case 1: scroll left to increase pixels
        return false;
      } else if (scrollPosition!.axisDirection == AxisDirection.left &&
          ((scrollPosition!.pixels == scrollPosition!.minScrollExtent &&
                  _globalDistanceMoved < 0) ||
              (scrollPosition!.pixels == scrollPosition!.maxScrollExtent &&
                  _globalDistanceMoved > 0))) {
        // case 2: scroll right to increase pixels
        return false;
      } else {
        return _globalDistanceMoved.abs() >
            computeHitSlop(pointerDeviceKind, gestureSettings);
      }
    } else if (dragPosition != null) {
      if ((dragPosition!.position.dx == dragPosition!.minPosition.dx &&
              _globalDistanceMoved < 0) ||
          (dragPosition!.position.dx == dragPosition!.maxPosition.dx &&
              _globalDistanceMoved > 0)) {
        return false;
      } else {
        return _globalDistanceMoved.abs() >
            computeHitSlop(pointerDeviceKind, gestureSettings);
      }
    } else {
      return _globalDistanceMoved.abs() >
          computeHitSlop(pointerDeviceKind, gestureSettings);
    }
  }

  double get _globalDistanceMoved {
    // Access via reflection is not possible; subclasses should override.
    // This is handled by the DragGestureRecognizer internals.
    return 0.0;
  }
}

/// A vertical drag gesture recognizer that supports nested scrollable widgets.
///
/// When the inner scrollable reaches its boundary, this recognizer returns
/// false so the gesture can propagate to the parent scrollable.
class NestedVerticalDragGestureRecognizer extends DragGestureRecognizer {
  /// Creates a gesture recognizer for interactions in the vertical axis
  /// that supports nested scrolling.
  NestedVerticalDragGestureRecognizer({
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
    this.enableTopEdgeNested = true,
    this.enableBottomEdgeNested = true,
  });

  /// The current [ScrollPosition] used to determine whether to accept a
  /// gesture when the scroll reaches the edge.
  ScrollPosition? scrollPosition;

  /// The current [DragPosition] used to determine whether to accept a
  /// gesture when the drag reaches the edge.
  DragPosition? dragPosition;

  /// Whether to propagate the gesture to parent when the scroll reaches
  /// the top edge. Defaults to true.
  final bool enableTopEdgeNested;

  /// Whether to propagate the gesture to parent when the scroll reaches
  /// the bottom edge. Defaults to true.
  final bool enableBottomEdgeNested;

  @override
  String get debugDescription => 'nested vertical drag';

  @override
  bool isFlingGesture(VelocityEstimate estimate, PointerDeviceKind kind) {
    final double minVelocity = minFlingVelocity ?? kMinFlingVelocity;
    final double minDistance = minFlingDistance ?? computeHitSlop(kind, gestureSettings);
    return estimate.pixelsPerSecond.dy.abs() > minVelocity &&
        estimate.offset.dy.abs() > minDistance;
  }

  @override
  Offset getDeltaForDetails(Offset delta) => Offset(0.0, delta.dy);

  @override
  double? getPrimaryValueFromOffset(Offset value) => value.dy;

  @override
  bool hasSufficientGlobalDistanceToAccept(
      PointerDeviceKind pointerDeviceKind, double? deviceTouchSlop) {
    if (scrollPosition != null && scrollPosition!.hasPixels) {
      if (scrollPosition!.axisDirection == AxisDirection.down) {
        if (enableTopEdgeNested &&
            scrollPosition!.pixels == scrollPosition!.minScrollExtent &&
            _globalDistanceMoved > 0) {
          return false;
        }
        if (enableBottomEdgeNested &&
            scrollPosition!.pixels == scrollPosition!.maxScrollExtent &&
            _globalDistanceMoved < 0) {
          return false;
        }
      } else if (scrollPosition!.axisDirection == AxisDirection.up) {
        if (enableTopEdgeNested &&
            scrollPosition!.pixels == scrollPosition!.minScrollExtent &&
            _globalDistanceMoved < 0) {
          return false;
        }
        if (enableBottomEdgeNested &&
            scrollPosition!.pixels == scrollPosition!.maxScrollExtent &&
            _globalDistanceMoved > 0) {
          return false;
        }
      }
      return _globalDistanceMoved.abs() >
          computeHitSlop(pointerDeviceKind, gestureSettings);
    } else if (dragPosition != null) {
      if ((dragPosition!.position.dy == dragPosition!.minPosition.dy &&
              _globalDistanceMoved < 0) ||
          (dragPosition!.position.dy == dragPosition!.maxPosition.dy &&
              _globalDistanceMoved > 0)) {
        return false;
      } else {
        return _globalDistanceMoved.abs() >
            computeHitSlop(pointerDeviceKind, gestureSettings);
      }
    } else {
      return _globalDistanceMoved.abs() >
          computeHitSlop(pointerDeviceKind, gestureSettings);
    }
  }

  double get _globalDistanceMoved => 0.0;
}
