import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/theme/portfolio_theme.dart';

/// Displays one piece of portfolio owner information.
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
    required this.width,
  });

  final String title;
  final String content;
  final IconData icon;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: PortfolioPalette.nudeCream.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: PortfolioPalette.brown.withValues(alpha: 0.34),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: PortfolioPalette.brownDark),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: PortfolioPalette.brownDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(content, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
