import 'dart:math';

class Point {
  double x, y;

  Point(this.x, this.y);

  @override
  String toString() {
    return '($x, $y)';
  }

  // Distance to another point.
  double distanceTo(Point other) {
    // d = sqrt((x2 - x1)^2 + (y2 - y1)^2)
    return sqrt((other.x - x) * (other.x - x) + (other.y - y) * (other.y - y));
  }
}
