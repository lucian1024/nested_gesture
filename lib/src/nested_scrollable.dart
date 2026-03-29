import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'nested_drag_gesture_recognizer.dart';

/// A scrollable widget that supports nested scrolling.
///
/// This is a drop-in replacement for [Scrollable] that uses
/// [NestedVerticalDragGestureRecognizer] and
/// [NestedHorizontalDragGestureRecognizer] instead of the default ones.
/// When the inner scrollable reaches its boundary, the gesture is passed
/// to the parent scrollable.
///
/// Usage: replace [Scrollable] (or [ListView], [CustomScrollView], etc.) with
/// the nested variant built on top of [NestedScrollable].
class NestedScrollable extends Scrollable {
  const NestedScrollable({
    super.key,
    super.axisDirection = AxisDirection.down,
    super.controller,
    super.physics,
    required super.viewportBuilder,
    super.incrementCalculator,
    super.excludeFromSemantics = false,
    super.semanticChildCount,
    super.dragStartBehavior = DragStartBehavior.start,
    super.restorationId,
    super.scrollBehavior,
    this.enableTopEdgeNestedScroll = true,
    this.enableBottomEdgeNestedScroll = true,
  });

  /// Whether to propagate the vertical gesture to parent when the scroll
  /// reaches the top edge. Defaults to true.
  final bool enableTopEdgeNestedScroll;

  /// Whether to propagate the vertical gesture to parent when the scroll
  /// reaches the bottom edge. Defaults to true.
  final bool enableBottomEdgeNestedScroll;

  @override
  ScrollableState createState() => _NestedScrollableState();
}

class _NestedScrollableState extends ScrollableState {
  @override
  NestedScrollable get widget => super.widget as NestedScrollable;

  @override
  @protected
  void setCanDrag(bool value) {
    if (!value) {
      // Let the parent handle disabling drag.
      super.setCanDrag(value);
      return;
    }

    final axis = widget.axis;
    Map<Type, GestureRecognizerFactory> gestureRecognizers;

    switch (axis) {
      case Axis.vertical:
        gestureRecognizers = <Type, GestureRecognizerFactory>{
          NestedVerticalDragGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<
                  NestedVerticalDragGestureRecognizer>(
            () => NestedVerticalDragGestureRecognizer(
              supportedDevices: ScrollConfiguration.of(context)
                  .dragDevices,
              enableTopEdgeNested: widget.enableTopEdgeNestedScroll,
              enableBottomEdgeNested: widget.enableBottomEdgeNestedScroll,
            ),
            (NestedVerticalDragGestureRecognizer instance) {
              instance
                ..scrollPosition = position
                ..onDown = handleDragDown
                ..onStart = handleDragStart
                ..onUpdate = handleDragUpdate
                ..onEnd = handleDragEnd
                ..onCancel = handleDragCancel
                ..minFlingDistance = physics.minFlingDistance
                ..minFlingVelocity = physics.minFlingVelocity
                ..maxFlingVelocity = physics.maxFlingVelocity
                ..dragStartBehavior = widget.dragStartBehavior;
            },
          ),
        };
        break;
      case Axis.horizontal:
        gestureRecognizers = <Type, GestureRecognizerFactory>{
          NestedHorizontalDragGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<
                  NestedHorizontalDragGestureRecognizer>(
            () => NestedHorizontalDragGestureRecognizer(
              supportedDevices: ScrollConfiguration.of(context)
                  .dragDevices,
            ),
            (NestedHorizontalDragGestureRecognizer instance) {
              instance
                ..scrollPosition = position
                ..onDown = handleDragDown
                ..onStart = handleDragStart
                ..onUpdate = handleDragUpdate
                ..onEnd = handleDragEnd
                ..onCancel = handleDragCancel
                ..minFlingDistance = physics.minFlingDistance
                ..minFlingVelocity = physics.minFlingVelocity
                ..maxFlingVelocity = physics.maxFlingVelocity
                ..dragStartBehavior = widget.dragStartBehavior;
            },
          ),
        };
        break;
    }

    // Replace gesture recognizers via the RawGestureDetector key.
    gestureDetectorKey.currentState
        ?.replaceGestureRecognizers(gestureRecognizers);
  }
}
