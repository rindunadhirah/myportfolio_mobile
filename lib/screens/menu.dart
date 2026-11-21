import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  static const String npm = '2506587131';
  static const String nama = 'Rindu Maharani Nadhirah';
  static const String kelas = 'PBP D';

  static const List<ItemHomepage> items = [
    ItemHomepage(
      'Lihat Proyek',
      Icons.folder,
      Colors.indigo,
      PortfolioAction.viewProjects,
    ),
    ItemHomepage(
      'Tambah Proyek',
      Icons.add_circle,
      Colors.green,
      PortfolioAction.addProject,
    ),
    ItemHomepage(
      'Tambah Pengalaman',
      Icons.work_history_outlined,
      Colors.brown,
      PortfolioAction.addExperience,
    ),
    ItemHomepage('Logout', Icons.logout, Colors.red, PortfolioAction.logout),
  ];

  int _getColumnCount(double width) {
    if (width >= 900) return 4;
    if (width >= 600) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the page structure and SnackBar area.
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth < 600 ? 16.0 : 32.0;
          final availableWidth = constraints.maxWidth - (horizontalPadding * 2);
          final showInfoCardsInRow = availableWidth >= 700;
          final infoCardWidth = showInfoCardsInRow
              ? (availableWidth - 24) / 3
              : availableWidth;
          final columnCount = _getColumnCount(availableWidth);
          final itemAspectRatio = columnCount == 1 ? 2.4 : 1.2;

          // One scroll view keeps the page usable on short and narrow screens.
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    InfoCard(
                      title: 'NPM',
                      content: npm,
                      icon: Icons.badge,
                      width: infoCardWidth,
                    ),
                    InfoCard(
                      title: 'Name',
                      content: nama,
                      icon: Icons.person,
                      width: infoCardWidth,
                    ),
                    InfoCard(
                      title: 'Class',
                      content: kelas,
                      icon: Icons.school,
                      width: infoCardWidth,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'Selamat datang di MyPortfolio Mobile!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pilih menu untuk menjelajahi portofolio saya.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 20),
                // The grid adapts its column count to the available screen width.
                GridView.count(
                  crossAxisCount: columnCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: itemAspectRatio,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: items.map((item) => ProjectCard(item)).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
