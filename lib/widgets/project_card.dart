import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/theme/portfolio_theme.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

/// Displays a tappable portfolio navigation or authentication action.
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
        onTap: () => _handleTap(context),
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

  Future<void> _handleTap(BuildContext context) async {
    switch (item.action) {
      case PortfolioAction.viewProjects:
        _open(context, const ProjectListScreen());
      case PortfolioAction.addProject:
        if (await ensureLoggedIn(context) && context.mounted) {
          _open(context, const ProjectFormPage());
        }
      case PortfolioAction.addExperience:
        _open(context, const ExperienceFormPage());
      case PortfolioAction.authentication:
        final authState = context.read<AuthState>();
        if (!authState.isLoggedIn) {
          _open(context, const LoginScreen());
          return;
        }

        try {
          await authState.logout();
          if (context.mounted) _showMessage(context, 'You are now logged out.');
        } on ApiException catch (error) {
          if (context.mounted) _showMessage(context, error.message);
        }
    }
  }

  void _open(BuildContext context, Widget destination) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
