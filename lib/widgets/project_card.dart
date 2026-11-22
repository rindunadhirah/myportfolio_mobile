import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/theme/portfolio_theme.dart';

/// Displays a tappable portfolio action and its feedback message.
class ProjectCard extends StatelessWidget {
  const ProjectCard(this.item, {super.key});

  final ItemHomepage item;

  @override
  Widget build(BuildContext context) {
    final isDark =
        ThemeData.estimateBrightnessForColor(item.color) == Brightness.dark;
    final foregroundColor = isDark
        ? PortfolioPalette.white
        : PortfolioPalette.navy;

    return Material(
      color: item.color,
      elevation: 1,
      shadowColor: PortfolioPalette.navy.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text('${item.name} selected.')));

          final Widget? destination = switch (item.action) {
            PortfolioAction.addProject => const ProjectFormPage(),
            PortfolioAction.addExperience => const ExperienceFormPage(),
            _ => null,
          };

          if (destination != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: foregroundColor, size: 30),
                const SizedBox(height: 6),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: foregroundColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
