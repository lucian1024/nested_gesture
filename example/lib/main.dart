import 'package:flutter/material.dart';
import 'package:nested_gesture/nested_gesture.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'nested_gesture example',
      home: Scaffold(
        appBar: AppBar(title: const Text('Nested Gesture Demo')),
        body: _buildNestedScroll(),
      ),
    );
  }

  /// Demonstrates a horizontal outer scroll wrapping a vertical inner scroll.
  /// When the inner list reaches its top/bottom boundary, the outer list takes
  /// over the gesture.
  Widget _buildNestedScroll() {
    return NestedScrollable(
      axisDirection: AxisDirection.right,
      viewportBuilder: (context, offset) {
        return Viewport(
          axisDirection: AxisDirection.right,
          offset: offset,
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                width: 300,
                height: double.infinity,
                child: NestedScrollable(
                  axisDirection: AxisDirection.down,
                  viewportBuilder: (context, innerOffset) {
                    return Viewport(
                      axisDirection: AxisDirection.down,
                      offset: innerOffset,
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => ListTile(
                              title: Text('Inner Item $index'),
                            ),
                            childCount: 30,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
