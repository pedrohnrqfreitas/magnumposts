import 'package:flutter/material.dart';
import 'skeleton_box.dart';

class SkeletonText extends StatelessWidget {
  final double? width;
  final double height;
  final int lines;
  final double spacing;

  const SkeletonText({
    super.key,
    this.width,
    this.height = 16,
    this.lines = 1,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        lines,
            (index) => Padding(
          padding: EdgeInsets.only(
            bottom: index < lines - 1 ? spacing : 0,
          ),
          child: SkeletonBox(
            width: index == lines - 1 && lines > 1
                ? (width ?? double.infinity) * 0.7
                : width,
            height: height,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}