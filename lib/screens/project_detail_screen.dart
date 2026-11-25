import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/theme/portfolio_theme.dart';
import 'package:provider/provider.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final imageUrl = context.read<ApiClient>().resolveMediaUrl(
      project.imagePath,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Project Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _imageFallback(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                Text(
                  project.role.toUpperCase(),
                  style: const TextStyle(
                    color: PortfolioPalette.brown,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  project.title,
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  project.summary,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 24),
                _DetailSection(title: 'Context', content: project.context),
                _ListSection(
                  title: 'My Contributions',
                  items: project.contributions,
                ),
                const Text(
                  'Technologies',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: project.technologies
                      .map((technology) => Chip(label: Text(technology)))
                      .toList(),
                ),
                const SizedBox(height: 24),
                _DetailSection(
                  title: 'Timeline',
                  content:
                      '${project.startedOn} to ${project.endedOn ?? 'Present'}',
                ),
                if (project.achievement.trim().isNotEmpty)
                  _DetailSection(
                    title: 'Highlight',
                    content: project.achievement,
                  ),
                _DetailSection(
                  title: 'Project Link',
                  content: project.projectUrl,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageFallback() {
    return const ColoredBox(
      color: PortfolioPalette.nudeCream,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: PortfolioPalette.brownDark,
          size: 42,
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(height: 1.5)),
        ],
      ),
    );
  }
}

class _ListSection extends StatelessWidget {
  const _ListSection({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•  '),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
