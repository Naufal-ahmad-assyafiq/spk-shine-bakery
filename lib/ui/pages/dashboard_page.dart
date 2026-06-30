import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import '../../data/data_validator.dart';
import '../../algorithm/weighted_product.dart';
import '../../models/result_model.dart';
import '../widgets/menu_card.dart';
import '../utils/responsive.dart';
import 'setup_page.dart';
import 'criteria_page.dart';
import 'assessment_page.dart';
import 'formula_page.dart';
import 'calculation_page.dart';
import 'ranking_page.dart';
import 'report_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Widget _buildSummaryRow({
    required BuildContext context,
    required String label,
    required String value,
    bool isBadge = false,
    bool isComplete = false,
  }) {
    const Color brown = Color(0xFF5D4037);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.brown.shade300,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: isBadge
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isComplete
                            ? Colors.green.shade100
                            : Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isComplete
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                        ),
                      ),
                    )
                  : Text(
                      value,
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: brown,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryDivider() {
    return Divider(
      height: 1,
      color: Colors.brown.withOpacity(0.12),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color cream = Color(0xFFFFF8EC);
    const Color brown = Color(0xFF5D4037);
    const Color orange = Color(0xFFE59A45);
    const Color lightBrown = Color(0xFFD7B98E);

    // Check data completeness
    final bool isComplete = DataValidator.isAllDataComplete();
    String bestAlternative = '-';
    double bestValue = 0.0;

    if (isComplete) {
      final List<ResultModel> results = WeightedProduct.calculateRanking(
        criterias: AppData.criterias,
        alternatives: AppData.alternatives,
      );
      if (results.isNotEmpty) {
        bestAlternative = results.first.alternativeName;
        bestValue = results.first.vectorV;
      }
    }

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text(
          'SPK Shine Bakery',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: brown,
        elevation: 2,
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(Responsive.pagePadding(context)),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Responsive.maxContentWidth(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Header / Hero section (Full Width)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: lightBrown),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'SISTEM PENDUKUNG KEPUTUSAN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: Responsive.isMobile(context) ? 14 : 16,
                                fontWeight: FontWeight.bold,
                                color: orange,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Pemilihan Supplier Bahan Baku Terbaik pada Shine Bakery',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: Responsive.isMobile(context) ? 18 : 22,
                                fontWeight: FontWeight.bold,
                                color: brown,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Metode Weighted Product (WP)',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: Responsive.isMobile(context) ? 13 : 15,
                                fontStyle: FontStyle.italic,
                                color: Colors.brown.shade300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 2. Ringkasan sistem (Single Box Container)
                      const Text(
                        'Ringkasan Sistem',
                        style: TextStyle(
                          color: brown,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: lightBrown),
                        ),
                        child: Column(
                          children: [
                            _buildSummaryRow(
                              context: context,
                              label: 'Nama Sistem/Usaha',
                              value: AppData.config.systemName,
                            ),
                            _buildSummaryDivider(),
                            _buildSummaryRow(
                              context: context,
                              label: 'Jumlah Kriteria',
                              value: '${AppData.config.criteriaCount} Kriteria',
                            ),
                            _buildSummaryDivider(),
                            _buildSummaryRow(
                              context: context,
                              label: 'Jumlah Alternatif',
                              value: '${AppData.config.alternativeCount} Alternatif',
                            ),
                            _buildSummaryDivider(),
                            _buildSummaryRow(
                              context: context,
                              label: 'Status Kelengkapan Data',
                              value: isComplete ? 'LENGKAP' : 'BELUM LENGKAP',
                              isBadge: true,
                              isComplete: isComplete,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 3. Card rekomendasi terbaik
                      if (isComplete)
                        Builder(
                          builder: (context) {
                            final isMobile = Responsive.isMobile(context);
                            if (isMobile) {
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [brown, Color(0xFF795548)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Rekomendasi Alternatif Terbaik',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      bestAlternative,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Nilai V: ${bestValue.toStringAsFixed(3)}',
                                      style: const TextStyle(
                                        color: orange,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [brown, Color(0xFF795548)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: orange.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.star,
                                        color: orange,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Rekomendasi Alternatif Terbaik',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            bestAlternative,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Nilai V',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          bestValue.toStringAsFixed(3),
                                          style: const TextStyle(
                                            color: orange,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        )
                      else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFEF9A9A), width: 1),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.error_outline, color: Color(0xFFC62828), size: 24),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Data belum lengkap. Silakan isi setup sistem, kriteria, dan penilaian alternatif terlebih dahulu.',
                                  style: TextStyle(
                                    color: Color(0xFFC62828),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // 4. Menu navigasi
                      const SizedBox(height: 28),
                      const Text(
                        'Menu Navigasi',
                        style: TextStyle(
                          color: brown,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),

                      GridView.count(
                        crossAxisCount: Responsive.gridCount(context),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: Responsive.isMobile(context) ? 1.05 : 1.3,
                        children: [
                          MenuCard(
                            title: 'Setup Sistem',
                            description: 'Atur nama usaha & jumlah data',
                            icon: Icons.settings_outlined,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SetupPage()),
                              );
                              setState(() {});
                            },
                          ),
                          MenuCard(
                            title: 'Data Kriteria',
                            description: 'Konfigurasi kriteria dinamis',
                            icon: Icons.rule_folder_outlined,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const CriteriaPage()),
                              );
                              setState(() {});
                            },
                          ),
                          MenuCard(
                            title: 'Penilaian Alternatif',
                            description: 'Matriks keputusan nilai alternatif',
                            icon: Icons.rate_review_outlined,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AssessmentPage()),
                              );
                              setState(() {});
                            },
                          ),
                          MenuCard(
                            title: 'Rumus WP',
                            description: 'Formulasi metode Weighted Product',
                            icon: Icons.functions_outlined,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const FormulaPage()),
                              );
                              setState(() {});
                            },
                          ),
                          MenuCard(
                            title: 'Perhitungan WP',
                            description: 'Tahapan Vektor S & Vektor V',
                            icon: Icons.calculate_outlined,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const CalculationPage()),
                              );
                              setState(() {});
                            },
                          ),
                          MenuCard(
                            title: 'Hasil Ranking',
                            description: 'Peringkat alternatif terbaik',
                            icon: Icons.insights_outlined,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RankingPage()),
                              );
                              setState(() {});
                            },
                          ),
                          MenuCard(
                            title: 'Laporan',
                            description: 'Ringkasan cetak hasil keputusan',
                            icon: Icons.description_outlined,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ReportPage()),
                              );
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
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
