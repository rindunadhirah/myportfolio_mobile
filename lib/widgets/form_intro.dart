import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/theme/portfolio_theme.dart';

/// Displays a compact branded introduction above a portfolio form.
class FormIntro extends StatelessWidget {
  const FormIntro({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: PortfolioPalette.navy,
        borderRadius: BorderRadius.circular(24),
        border: const Border(
          left: BorderSide(color: PortfolioPalette.brown, width: 6),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: PortfolioPalette.nudeCream,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: PortfolioPalette.brownDark),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: PortfolioPalette.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    color: PortfolioPalette.nudeCream.withValues(alpha: 0.88),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
