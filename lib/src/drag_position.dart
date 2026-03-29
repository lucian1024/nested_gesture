import 'dart:ui';

/// Represents the drag boundary of a draggable widget.
///
/// Tracks the current drag position and clamps it within [minPosition] and
/// [maxPosition] bounds.
class DragPosition {
  DragPosition({
    Offset position = Offset.zero,
    Offset minPosition = Offset.zero,
    Offset maxPosition = Offset.infinite,
  })  : _position = position,
        _minPosition = minPosition,
        _maxPosition = maxPosition;

  /// The current drag position, clamped within [minPosition] and [maxPosition].
  Offset _position;
  Offset get position => _position;
  set position(Offset value) {
    if (_position == value) return;

    final double dx = value.dx < _minPosition.dx
        ? _minPosition.dx
        : (value.dx > _maxPosition.dx ? _maxPosition.dx : value.dx);
    final double dy = value.dy < _minPosition.dy
        ? _minPosition.dy
        : (value.dy > _maxPosition.dy ? _maxPosition.dy : value.dy);
    _position = Offset(dx, dy);
  }

  /// The minimum drag position.
  Offset _minPosition;
  Offset get minPosition => _minPosition;
  set minPosition(Offset value) {
    if (_minPosition == value) return;
    if (value.dx > _maxPosition.dx || value.dy > _maxPosition.dy) return;
    _minPosition = value;
  }

  /// The maximum drag position.
  Offset _maxPosition;
  Offset get maxPosition => _maxPosition;
  set maxPosition(Offset value) {
    if (_maxPosition == value) return;
    if (value.dx < _minPosition.dx || value.dy < _minPosition.dy) return;
    _maxPosition = value;
  }
}
