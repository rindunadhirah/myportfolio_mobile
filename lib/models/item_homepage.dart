import 'package:material_ui/material_ui.dart';

enum PortfolioAction { viewProjects, addProject, addExperience, logout }

/// Stores the content and color displayed by a portfolio action card.
class ItemHomepage {
  const ItemHomepage(this.name, this.icon, this.color, this.action);

  final String name;
  final IconData icon;
  final Color color;
  final PortfolioAction action;
}
