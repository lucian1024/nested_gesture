/// A Flutter package that provides nested gesture recognizers to support
/// nested scrollable widgets.
///
/// Flutter's native gesture handling processes from child to parent, but
/// native gesture components don't support nested usage. This package
/// introduces scroll boundary constraints to enable proper nested scrolling.
library nested_gesture;

export 'src/drag_position.dart';
export 'src/nested_drag_gesture_recognizer.dart';
export 'src/nested_scrollable.dart';
