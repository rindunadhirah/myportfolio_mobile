import 'package:flutter/material.dart';

/// Stores the content and color displayed by a portfolio action card.
class ItemHomepage {
  const ItemHomepage(this.name, this.icon, this.color);

  final String name;
  final IconData icon;
  final Color color;
}
