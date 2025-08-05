import 'package:flutter/material.dart';

class DrawerItemEntity {
  final String itemLabel;
  final bool clickable, highlight;
  final VoidCallback? callback;
  final Widget child;

  const DrawerItemEntity({
    required this.itemLabel,
    required this.child,
    this.clickable = false,
    this.highlight = false,
    this.callback,
  });
}
