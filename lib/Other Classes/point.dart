import 'dart:math';

class Point {
  double x, y;

  Point(this.x, this.y);

  @override
  String toString() {
    // Round the coordinates to 2 decimal places.
    return '(${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)})';
  }

  // Distance to another point.
  double distanceTo(Point other) {
    // d = sqrt((x2 - x1)^2 + (y2 - y1)^2)
    return sqrt((other.x - x) * (other.x - x) + (other.y - y) * (other.y - y));
  }
}
