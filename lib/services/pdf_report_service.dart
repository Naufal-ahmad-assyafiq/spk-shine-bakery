import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/criteria_model.dart';
import '../models/alternative_model.dart';
import '../models/result_model.dart';

class PdfReportService {
  static Future<Uint8List> generateReportPdf({
    required String systemName,
    required List<CriteriaModel> criterias,
    required List<AlternativeModel> alternatives,
    required List<ResultModel> results,
  }) async {
    final pdf = pw.Document();

    final now = DateTime.now();
    final printedDate = "${now.day}/${now.month}/${now.year}";

    final double totalWeight = criterias.fold(0.0, (sum, c) => sum + c.weight);

    // Compute weights perbaikan list
    final List<double> fixedWeights = criterias.map((c) => c.getFixedWeight(totalWeight)).toList();

    // Prepare conclusion string
    final bestAltName = results.isNotEmpty ? results.first.alternativeName : '-';
    final bestAltVal = results.isNotEmpty ? results.first.vectorV : 0.0;
    
    final conclusion = 'Berdasarkan hasil perhitungan metode Weighted Product, alternatif dengan nilai preferensi tertinggi adalah $bestAltName dengan nilai V sebesar ${bestAltVal.toStringAsFixed(3)}. ' +
        (systemName.toLowerCase().contains('shine bakery')
            ? 'Maka, $bestAltName direkomendasikan sebagai supplier bahan baku terbaik untuk Shine Bakery.'
            : 'Maka, $bestAltName direkomendasikan sebagai pilihan terbaik pada $systemName.');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Title Header
            pw.Header(
              level: 0,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'LAPORAN HASIL KEPUTUSAN',
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.brown800),
                  ),
                  pw.Text(
                    'Sistem Pendukung Keputusan Pemilihan Supplier Bahan Baku Terbaik',
                    style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
                  ),
                  pw.Text(
                    'Metode Weighted Product (WP)',
                    style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
                  ),
                  pw.Divider(thickness: 1.5, color: PdfColors.grey400),
                ],
              ),
            ),
            pw.SizedBox(height: 10),

            // Informasi Sistem
            pw.Text('I. Informasi Sistem', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.brown800)),
            pw.SizedBox(height: 6),
            pw.Table.fromTextArray(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
              cellPadding: const pw.EdgeInsets.all(6),
              data: [
                ['Informasi', 'Isi'],
                ['Nama Sistem/Usaha', systemName],
                ['Metode', 'Weighted Product (WP)'],
                ['Jumlah Kriteria', '${criterias.length} Kriteria'],
                ['Jumlah Alternatif', '${alternatives.length} Alternatif'],
                ['Tanggal Cetak', printedDate],
              ],
            ),
            pw.SizedBox(height: 16),

            // Data Kriteria
            pw.Text('II. Data Kriteria & Bobot Perbaikan', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.brown800)),
            pw.SizedBox(height: 6),
            pw.Table.fromTextArray(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
              cellAlignment: pw.Alignment.center,
              cellAlignments: {
                1: pw.Alignment.centerLeft,
              },
              cellPadding: const pw.EdgeInsets.all(6),
              data: [
                ['No', 'Nama Kriteria', 'Bobot Awal', 'Jenis', 'Bobot Perbaikan'],
                ...List.generate(criterias.length, (index) {
                  final c = criterias[index];
                  final fw = fixedWeights[index];
                  return [
                    '${index + 1}',
                    c.name,
                    '${c.weight}',
                    c.type,
                    (fw > 0 ? '+' : '') + fw.toStringAsFixed(3),
                  ];
                }),
              ],
            ),
            pw.SizedBox(height: 16),

            // Data Penilaian Alternatif
            pw.Text('III. Data Penilaian Alternatif', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.brown800)),
            pw.SizedBox(height: 6),
            pw.Table.fromTextArray(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
              cellPadding: const pw.EdgeInsets.all(6),
              data: [
                ['Nama Alternatif', ...criterias.map((c) => c.name)],
                ...alternatives.map((alt) {
                  return [
                    alt.name,
                    ...alt.values.map((v) => '${v.toInt()}'),
                  ];
                }),
              ],
            ),
            pw.SizedBox(height: 16),

            // Hasil Ranking
            pw.Text('IV. Hasil Perhitungan & Ranking', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.brown800)),
            pw.SizedBox(height: 6),
            pw.Table.fromTextArray(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
              cellPadding: const pw.EdgeInsets.all(6),
              data: [
                ['Ranking', 'Nama Alternatif', 'Nilai S (Vektor S)', 'Nilai V (Vektor V)'],
                ...results.map((res) {
                  return [
                    '${res.ranking}',
                    res.alternativeName,
                    res.vectorS.toStringAsFixed(4),
                    res.vectorV.toStringAsFixed(3),
                  ];
                }),
              ],
            ),
            pw.SizedBox(height: 16),

            // Kesimpulan
            pw.Text('V. Kesimpulan Keputusan', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.brown800)),
            pw.SizedBox(height: 6),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.brown300, width: 1.5),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                color: PdfColors.amber50,
              ),
              child: pw.Text(
                conclusion,
                style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic),
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }
}
