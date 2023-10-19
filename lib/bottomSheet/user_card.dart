import 'package:flutter/material.dart';

class ExpandedEventItem extends StatelessWidget {
  final double topMargin;
  final double leftMargin;
  final double height;
  final bool isVisible;
  final double borderRadius;
  final String title;
  final String date;

  const ExpandedEventItem(
      {super.key,
      required this.topMargin,
      required this.height,
      required this.isVisible,
      required this.borderRadius,
      required this.title,
      required this.date,
      required this.leftMargin});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topMargin,
      left: leftMargin,
      right: 0,
      height: height,
      child: AnimatedOpacity(
        opacity: isVisible ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: Colors.white,
          ),
          padding: EdgeInsets.only(left: height).add(const EdgeInsets.all(8)),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 8),
        Text(
          date,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const Spacer(),
        Row(
          children: <Widget>[
            Icon(Icons.place, color: Colors.grey.shade400, size: 16),
            Text(
              'India',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            )
          ],
        )
      ],
    );
  }
}
