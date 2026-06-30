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

class CalculationPage extends StatelessWidget {
  const CalculationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color cream = Color(0xFFFFF8EC);
    const Color brown = Color(0xFF5D4037);
    const Color lightBrown = Color(0xFFD7B98E);
    const Color orange = Color(0xFFE59A45);

    final bool isComplete = DataValidator.isAllDataComplete();

    List<ResultModel> orderedResults = [];
    List<double> fixedWeights = [];
    double sumS = 0.0;

    if (isComplete) {
      final results = WeightedProduct.calculateRanking(
        criterias: AppData.criterias,
        alternatives: AppData.alternatives,
      );

      orderedResults = List.from(results);
      orderedResults.sort((a, b) {
        final aIdx = AppData.alternatives.indexWhere((alt) => alt.name == a.alternativeName);
        final bIdx = AppData.alternatives.indexWhere((alt) => alt.name == b.alternativeName);
        return aIdx.compareTo(bIdx);
      });

      fixedWeights = WeightedProduct.getFixedWeights(AppData.criterias);
      sumS = results.fold(0.0, (sum, res) => sum + res.vectorS);
    }

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text(
          'Perhitungan WP',
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
                        title: 'Tahapan Perhitungan WP',
                        subtitle: 'Berikut adalah hasil normalisasi bobot serta perhitungan Vektor S dan Vektor V.',
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
                        // Brief explanation card
                        CustomCard(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.info_outline, color: orange, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Teori Perhitungan WP',
                                    style: TextStyle(color: brown, fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Proses Weighted Product (WP) terdiri dari normalisasi bobot awal agar total penjumlahan seluruh bobot bernilai 1.000. '
                                'Selanjutnya, Nilai S (Vektor S) dihitung untuk tiap alternatif, dan dinormalisasi menjadi Nilai V (Vektor V) sebagai acuan ranking.',
                                style: TextStyle(color: brown, fontSize: 13, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Table 1: Bobot Perbaikan
                        const Text(
                          '1. Tabel Perbaikan Bobot',
                          style: TextStyle(color: brown, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 6),
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
                                DataColumn(label: SizedBox(width: 140, child: Text('Kriteria', style: TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13)))),
                                DataColumn(label: SizedBox(width: 90, child: Text('Bobot Awal', style: TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13), textAlign: TextAlign.center))),
                                DataColumn(label: SizedBox(width: 130, child: Text('Jenis', style: TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13), textAlign: TextAlign.center))),
                                DataColumn(label: SizedBox(width: 130, child: Text('Bobot Perbaikan', style: TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13), textAlign: TextAlign.center))),
                              ],
                              rows: List.generate(AppData.criterias.length, (index) {
                                final c = AppData.criterias[index];
                                final corrected = fixedWeights[index];
                                return DataRow(
                                  cells: [
                                    DataCell(SizedBox(width: 140, child: Text(c.name, style: const TextStyle(color: brown, fontSize: 13)))),
                                    DataCell(SizedBox(width: 90, child: Text('${c.weight}', style: const TextStyle(color: brown, fontSize: 13), textAlign: TextAlign.center))),
                                    DataCell(SizedBox(width: 130, child: Text(c.type, style: const TextStyle(color: brown, fontSize: 13), textAlign: TextAlign.center))),
                                    DataCell(
                                      SizedBox(
                                        width: 130,
                                        child: Text(
                                          (corrected > 0 ? '+' : '') + corrected.toStringAsFixed(3),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: corrected < 0 ? const Color(0xFFD84315) : const Color(0xFF2E7D32),
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
                        const SizedBox(height: 24),

                        // Table 2: Nilai S & Nilai V
                        const Text(
                          '2. Tabel Perhitungan Nilai S & Nilai V',
                          style: TextStyle(color: brown, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 6),
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
                                DataColumn(label: SizedBox(width: 180, child: Text('Alternatif', style: TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13)))),
                                DataColumn(label: SizedBox(width: 140, child: Text('Nilai S', style: TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13), textAlign: TextAlign.center))),
                                DataColumn(label: SizedBox(width: 140, child: Text('Nilai V', style: TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13), textAlign: TextAlign.center))),
                              ],
                              rows: List.generate(orderedResults.length, (index) {
                                final res = orderedResults[index];
                                return DataRow(
                                  cells: [
                                    DataCell(SizedBox(width: 180, child: Text(res.alternativeName, style: const TextStyle(color: brown, fontSize: 13)))),
                                    DataCell(SizedBox(width: 140, child: Text(res.vectorS.toStringAsFixed(4), style: const TextStyle(color: brown, fontSize: 13), textAlign: TextAlign.center))),
                                    DataCell(SizedBox(width: 140, child: Text(res.vectorV.toStringAsFixed(3), style: const TextStyle(color: orange, fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center))),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // mathematical details info block
                        CustomCard(
                          padding: const EdgeInsets.all(12),
                          child: RichText(
                            text: TextSpan(
                              text: 'Total Vektor S (∑Sᵢ) = ',
                              style: const TextStyle(color: brown, fontSize: 13, fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: sumS.toStringAsFixed(4),
                                  style: const TextStyle(color: orange, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),

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
