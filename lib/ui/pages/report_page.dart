import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../data/app_data.dart';
import '../../data/data_validator.dart';
import '../../algorithm/weighted_product.dart';
import '../../models/result_model.dart';
import '../../services/pdf_report_service.dart';
import '../utils/responsive.dart';
import '../widgets/section_title.dart';
import '../widgets/responsive_button.dart';
import '../widgets/custom_card.dart';
import '../widgets/responsive_table_container.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({Key? key}) : super(key: key);

  void _generatePdf(BuildContext context, List<ResultModel> results) async {
    final bool isComplete = DataValidator.isAllDataComplete();
    if (!isComplete) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data belum lengkap. Silakan lengkapi setup, kriteria, dan penilaian alternatif terlebih dahulu.'),
          backgroundColor: Color(0xFFC62828),
        ),
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    try {
      await Printing.layoutPdf(
        onLayout: (format) async {
          return PdfReportService.generateReportPdf(
            systemName: AppData.config.systemName,
            criterias: AppData.criterias,
            alternatives: AppData.alternatives,
            results: results,
          );
        },
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Gagal membuat PDF: $e'),
          backgroundColor: const Color(0xFFC62828),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color cream = Color(0xFFFFF8EC);
    const Color brown = Color(0xFF5D4037);
    const Color lightBrown = Color(0xFFD7B98E);
    const Color orange = Color(0xFFE59A45);

    final bool isComplete = DataValidator.isAllDataComplete();

    List<ResultModel> results = [];
    String bestAlternative = '';
    double bestValue = 0.0;

    if (isComplete) {
      results = WeightedProduct.calculateRanking(
        criterias: AppData.criterias,
        alternatives: AppData.alternatives,
      );

      if (results.isNotEmpty) {
        bestAlternative = results.first.alternativeName;
        bestValue = results.first.vectorV;
      }
    }

    final bool isMobile = Responsive.isMobile(context);

    // Responsive metadata info layout (2 columns on tablet/desktop, 1 column on mobile)
    Widget buildInfoLayout() {
      if (isMobile) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportPreviewRow('Nama Sistem/Usaha', AppData.config.systemName),
            _buildReportPreviewRow('Metode Analisis', 'Weighted Product (WP)'),
            _buildReportPreviewRow('Jumlah Alternatif', '${AppData.config.alternativeCount}'),
            _buildReportPreviewRow('Jumlah Kriteria', '${AppData.config.criteriaCount}'),
            _buildReportPreviewRow('Alternatif Terbaik', bestAlternative),
            _buildReportPreviewRow('Nilai V Terbesar', bestValue.toStringAsFixed(3)),
          ],
        );
      } else {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReportPreviewRow('Nama Sistem/Usaha', AppData.config.systemName),
                  _buildReportPreviewRow('Jumlah Alternatif', '${AppData.config.alternativeCount}'),
                  _buildReportPreviewRow('Alternatif Terbaik', bestAlternative),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReportPreviewRow('Metode Analisis', 'Weighted Product (WP)'),
                  _buildReportPreviewRow('Jumlah Kriteria', '${AppData.config.criteriaCount}'),
                  _buildReportPreviewRow('Nilai V Terbesar', bestValue.toStringAsFixed(3)),
                ],
              ),
            ),
          ],
        );
      }
    }

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text(
          'Laporan Hasil Keputusan',
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
                        title: 'Ringkasan Laporan SPK',
                        subtitle: 'Laporan resmi pemilihan keputusan terbaik menggunakan metode WP.',
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
                                'Laporan Belum Tersedia',
                                style: TextStyle(
                                  color: brown,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Laporan belum dapat dibuat karena data penilaian belum lengkap.',
                                style: TextStyle(color: brown, fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else ...[
                        // Report Summary Card
                        CustomCard(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    const Icon(Icons.description, color: orange, size: 40),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'LAPORAN HASIL KEPUTUSAN',
                                      style: TextStyle(
                                        color: brown,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'SPK ${AppData.config.systemName.toUpperCase()}',
                                      style: const TextStyle(
                                        color: orange,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const Divider(color: lightBrown, thickness: 1, height: 16),
                                  ],
                                ),
                              ),

                              buildInfoLayout(),

                              const SizedBox(height: 16),
                              const Text(
                                'Hasil Ranking Final:',
                                style: TextStyle(color: brown, fontWeight: FontWeight.bold, fontSize: 13),
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
                                      DataColumn(label: SizedBox(width: 60, child: Text('Ranking', style: TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13), textAlign: TextAlign.center))),
                                      DataColumn(label: SizedBox(width: 140, child: Text('Nama Alternatif', style: TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13)))),
                                      DataColumn(label: SizedBox(width: 110, child: Text('Nilai S', style: TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13), textAlign: TextAlign.center))),
                                      DataColumn(label: SizedBox(width: 110, child: Text('Nilai V', style: TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13), textAlign: TextAlign.center))),
                                    ],
                                    rows: results.map((res) {
                                      return DataRow(
                                        cells: [
                                          DataCell(SizedBox(width: 60, child: Text('${res.ranking}', style: const TextStyle(fontSize: 13), textAlign: TextAlign.center))),
                                          DataCell(SizedBox(width: 140, child: Text(res.alternativeName, style: const TextStyle(fontSize: 13)))),
                                          DataCell(SizedBox(width: 110, child: Text(res.vectorS.toStringAsFixed(4), style: const TextStyle(fontSize: 13), textAlign: TextAlign.center))),
                                          DataCell(SizedBox(width: 110, child: Text(res.vectorV.toStringAsFixed(3), style: const TextStyle(fontSize: 13), textAlign: TextAlign.center))),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),
                              const Text(
                                'Kesimpulan Akhir:',
                                style: TextStyle(
                                  color: brown,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Berdasarkan hasil perhitungan metode Weighted Product, alternatif dengan nilai preferensi tertinggi adalah $bestAlternative dengan nilai V sebesar ${bestValue.toStringAsFixed(3)}. ' +
                                (AppData.config.systemName.toLowerCase().contains('shine bakery')
                                    ? 'Maka, $bestAlternative direkomendasikan sebagai supplier bahan baku terbaik untuk Shine Bakery.'
                                    : 'Maka, $bestAlternative direkomendasikan sebagai pilihan terbaik pada ${AppData.config.systemName}.'),
                                style: const TextStyle(
                                  color: brown,
                                  fontSize: 13,
                                  height: 1.4,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Action buttons placed side-by-side using Wrap on large screens
                        Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          children: [
                            ResponsiveButton(
                              text: 'Preview PDF',
                              onPressed: () => _generatePdf(context, results),
                              icon: Icons.picture_as_pdf,
                              backgroundColor: brown,
                            ),
                            ResponsiveButton(
                              text: 'Cetak / Simpan PDF',
                              onPressed: () => _generatePdf(context, results),
                              icon: Icons.print,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],

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

  Widget _buildReportPreviewRow(String label, String value) {
    const Color brown = Color(0xFF5D4037);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: brown.withOpacity(0.5),
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: brown,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
