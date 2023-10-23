import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:global_chat/models/user.dart';
import 'package:global_chat/screens/chat_screen.dart';

const double minHeight = 120;
const double iconStartSize = 44;
const double iconEndSize = 120;
const double iconStartMarginTop = 36;
const double iconEndMarginTop = 80;
const double iconsVerticalSpacing = 24;
const double iconsHorizontalSpacing = 16;

class BottomSheetModal extends StatefulWidget {
  const BottomSheetModal({super.key, required this.users});
  final List<User> users;

  @override
  State<BottomSheetModal> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheetModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double get maxHeight => MediaQuery.of(context).size.height - 170;

  double get headerTopMargin =>
      lerp(20, 20 + MediaQuery.of(context).padding.top);

  double get headerFontSize => lerp(14, 24);

  double get itemBorderRadius => lerp(8, 24);

  double get iconLeftBorderRadius => itemBorderRadius;

  double get iconRightBorderRadius => lerp(8, 0);

  double get iconSize => lerp(iconStartSize, iconEndSize);

  double iconTopMargin(int index) =>
      lerp(iconStartMarginTop,
          iconEndMarginTop + index * (iconsVerticalSpacing + iconEndSize)) +
      headerTopMargin;

  double iconLeftMargin(int index) =>
      lerp(index * (iconsHorizontalSpacing + iconStartSize), 0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double lerp(double min, double max) =>
      lerpDouble(min, max, _controller.value)!;

  @override
  Widget build(BuildContext context) {
    final users = widget.users;

    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withRed(140),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SheetHeader(
              fontSize: headerFontSize,
              topMargin: headerTopMargin,
            ),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  for (User user in users) _buildIcon(user),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(User user) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(toUser: user),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        width: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withBlue(240),
            width: 2,
          ),
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(user.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: user.imageUrl == 'null'
            ? Align(
                alignment: Alignment.center,
                child: Text(
                  user.userName[0],
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : null,
      ),
    );
  }
}

class SheetHeader extends StatelessWidget {
  final double fontSize;
  final double topMargin;

  const SheetHeader(
      {super.key, required this.fontSize, required this.topMargin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 12,
      ),
      child: Text(
        'Online Friends',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      right: 0,
      bottom: 24,
      child: Icon(
        Icons.menu,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}
