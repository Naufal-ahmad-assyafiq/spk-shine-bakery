import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import '../../data/data_validator.dart';
import '../../algorithm/weighted_product.dart';
import '../../models/result_model.dart';
import '../utils/responsive.dart';
import '../widgets/section_title.dart';
import '../widgets/responsive_button.dart';
import '../widgets/custom_card.dart';
import '../widgets/responsive_table_container.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color cream = Color(0xFFFFF8EC);
    const Color brown = Color(0xFF5D4037);
    const Color orange = Color(0xFFE59A45);
    const Color lightBrown = Color(0xFFD7B98E);

    final bool isComplete = DataValidator.isAllDataComplete();

    List<ResultModel> results = [];
    String bestAlternativeName = '';
    double bestAlternativeVal = 0.0;

    if (isComplete) {
      results = WeightedProduct.calculateRanking(
        criterias: AppData.criterias,
        alternatives: AppData.alternatives,
      );

      if (results.isNotEmpty) {
        bestAlternativeName = results.first.alternativeName;
        bestAlternativeVal = results.first.vectorV;
      }
    }

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text(
          'Hasil Ranking',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: brown,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double padding = Responsive.pagePadding(context);
            return SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Responsive.maxContentWidth(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(
                        title: 'Perangkingan Alternatif',
                        subtitle: 'Urutan alternatif terbaik berdasarkan nilai preferensi Vektor V terbesar.',
                      ),
                      const SizedBox(height: 12),

                      if (!isComplete)
                        CustomCard(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Center(child: Icon(Icons.warning_amber_rounded, color: orange, size: 40)),
                              const SizedBox(height: 12),
                              const Text(
                                'Data Belum Lengkap',
                                style: TextStyle(
                                  color: brown,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Silakan lengkapi setup, kriteria, dan penilaian alternatif terlebih dahulu.',
                                style: TextStyle(color: brown, fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else ...[
                        // Highlight Winner Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: orange, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: orange.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.emoji_events, color: orange, size: 24),
                                  SizedBox(width: 8),
                                  Text(
                                    'Rekomendasi Terbaik',
                                    style: TextStyle(
                                      color: orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                bestAlternativeName,
                                style: const TextStyle(
                                  color: brown,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Nilai V: ${bestAlternativeVal.toStringAsFixed(3)}',
                                style: const TextStyle(
                                  color: orange,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Rankings DataTable in ResponsiveTableContainer
                        ResponsiveTableContainer(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: const Color(0xFFEFEBE9),
                            ),
                            child: DataTable(
                              headingRowColor: MaterialStateProperty.all(lightBrown),
                              columnSpacing: 16,
                              horizontalMargin: 12,
                              headingRowHeight: 48,
                              dataRowMinHeight: 48,
                              dataRowMaxHeight: 56,
                              columns: const [
                                DataColumn(label: SizedBox(width: 80, child: Text('Ranking', style: TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13), textAlign: TextAlign.center))),
                                DataColumn(label: SizedBox(width: 160, child: Text('Nama Alternatif', style: TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13)))),
                                DataColumn(label: SizedBox(width: 120, child: Text('Nilai S', style: TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13), textAlign: TextAlign.center))),
                                DataColumn(label: SizedBox(width: 120, child: Text('Nilai V', style: TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13), textAlign: TextAlign.center))),
                              ],
                              rows: List.generate(results.length, (index) {
                                final res = results[index];
                                final isRank1 = res.ranking == 1;
                                return DataRow(
                                  // Highlight Rank 1 with soft background color
                                  color: MaterialStateProperty.resolveWith<Color?>((states) {
                                    if (isRank1) return const Color(0xFFFFF3E0); // soft gold/orange background
                                    return null;
                                  }),
                                  cells: [
                                    DataCell(
                                      SizedBox(
                                        width: 80,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if (isRank1) ...[
                                              const Icon(Icons.emoji_events, color: orange, size: 14),
                                              const SizedBox(width: 4),
                                            ],
                                            Text(
                                              '${res.ranking}',
                                              style: TextStyle(
                                                color: isRank1 ? orange : brown,
                                                fontWeight: isRank1 ? FontWeight.bold : FontWeight.normal,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 160,
                                        child: Text(
                                          res.alternativeName,
                                          style: TextStyle(
                                            color: brown,
                                            fontWeight: isRank1 ? FontWeight.bold : FontWeight.normal,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          res.vectorS.toStringAsFixed(4),
                                          style: const TextStyle(color: brown, fontSize: 13),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          res.vectorV.toStringAsFixed(3),
                                          style: TextStyle(
                                            color: isRank1 ? orange : brown,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Conclusion
                        CustomCard(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.stars, color: orange, size: 20),
                                  SizedBox(width: 6),
                                  Text(
                                    'Kesimpulan Keputusan',
                                    style: TextStyle(
                                      color: brown,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Berdasarkan hasil perhitungan metode Weighted Product, alternatif dengan nilai preferensi tertinggi adalah $bestAlternativeName dengan nilai V sebesar ${bestAlternativeVal.toStringAsFixed(3)}. ' +
                                (AppData.config.systemName.toLowerCase().contains('shine bakery')
                                    ? 'Maka, $bestAlternativeName direkomendasikan sebagai supplier bahan baku terbaik untuk Shine Bakery.'
                                    : 'Maka, $bestAlternativeName direkomendasikan sebagai pilihan terbaik pada ${AppData.config.systemName}.'),
                                style: const TextStyle(
                                  color: brown,
                                  fontSize: 13,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),

                      ResponsiveButton(
                        text: 'Kembali ke Dashboard',
                        onPressed: () => Navigator.pop(context),
                        icon: Icons.arrow_back,
                        backgroundColor: brown,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
