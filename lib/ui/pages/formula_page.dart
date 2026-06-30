import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../widgets/section_title.dart';
import '../widgets/responsive_button.dart';
import '../widgets/custom_card.dart';
import '../widgets/responsive_table_container.dart';

class FormulaPage extends StatelessWidget {
  const FormulaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color cream = Color(0xFFFFF8EC);
    const Color brown = Color(0xFF5D4037);
    const Color orange = Color(0xFFE59A45);
    const Color lightBrown = Color(0xFFD7B98E);

    final List<List<Widget>> rows = [
      [
        const Text('Sᵢ', style: TextStyle(fontWeight: FontWeight.bold, color: orange, fontSize: 16)),
        const Text('Nilai vektor S alternatif ke-i', style: TextStyle(color: brown)),
      ],
      [
        const Text('Xᵢⱼ', style: TextStyle(fontWeight: FontWeight.bold, color: orange, fontSize: 16)),
        const Text('Nilai alternatif ke-i pada kriteria ke-j', style: TextStyle(color: brown)),
      ],
      [
        const Text('Wⱼ', style: TextStyle(fontWeight: FontWeight.bold, color: orange, fontSize: 16)),
        const Text('Bobot kriteria ke-j', style: TextStyle(color: brown)),
      ],
      [
        const Text('∏', style: TextStyle(fontWeight: FontWeight.bold, color: orange, fontSize: 20)),
        const Text('Operator perkalian seluruh nilai kriteria dari j = 1 sampai n', style: TextStyle(color: brown)),
      ],
      [
        const Text('Vᵢ', style: TextStyle(fontWeight: FontWeight.bold, color: orange, fontSize: 16)),
        const Text('Nilai preferensi alternatif ke-i (Vektor V)', style: TextStyle(color: brown)),
      ],
      [
        const Text('∑Sᵢ', style: TextStyle(fontWeight: FontWeight.bold, color: orange, fontSize: 16)),
        const Text('Jumlah total nilai Vektor S seluruh alternatif', style: TextStyle(color: brown)),
      ],
    ];

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text(
          'Rumus Metode WP',
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
                        title: 'Rumus Metode Weighted Product',
                        subtitle: 'Penjelasan teori dan landasan matematis perhitungan metode Weighted Product (WP).',
                      ),
                      const SizedBox(height: 12),

                      // Introduction Card
                      CustomCard(
                        padding: const EdgeInsets.all(16),
                        child: const Text(
                          'Metode Weighted Product (WP) digunakan untuk menghitung nilai setiap alternatif supplier berdasarkan kriteria dan bobot yang telah ditentukan. Metode ini menggunakan perkalian untuk menghubungkan rating atribut, di mana rating setiap atribut harus dipangkatkan terlebih dahulu dengan bobot kriteria yang bersangkutan.',
                          style: TextStyle(color: brown, fontSize: 13, height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Formula 1 Card: Vector S
                      CustomCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text(
                              '1. Perhitungan Vektor S (Skor Alternatif)',
                              style: TextStyle(color: brown, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: cream,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: lightBrown, width: 1),
                              ),
                              child: const Text(
                                'Sᵢ = ∏ ( Xᵢⱼ ^ Wⱼ )',
                                style: TextStyle(
                                  color: brown,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Courier',
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Perkalian nilai alternatif dipangkatkan dengan bobot perbaikannya.',
                              style: TextStyle(color: brown.withOpacity(0.6), fontSize: 11),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Formula 2 Card: Vector V
                      CustomCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text(
                              '2. Perhitungan Vektor V (Nilai Preferensi Akhir)',
                              style: TextStyle(color: brown, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: cream,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: lightBrown, width: 1),
                              ),
                              child: const Text(
                                'Vᵢ = Sᵢ / ∑ Sᵢ',
                                style: TextStyle(
                                  color: brown,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Courier',
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Alternatif supplier dengan nilai V terbesar menjadi supplier terbaik.',
                              style: TextStyle(color: brown.withOpacity(0.6), fontSize: 11),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Table Notation Explanation
                      const Text(
                        'Keterangan Simbol Rumus:',
                        style: TextStyle(color: brown, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 8),

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
                              DataColumn(label: SizedBox(width: 80, child: Text('Simbol', style: TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13), textAlign: TextAlign.center))),
                              DataColumn(label: SizedBox(width: 300, child: Text('Keterangan', style: TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13)))),
                            ],
                            rows: rows.map((row) {
                              return DataRow(
                                cells: [
                                  DataCell(SizedBox(width: 80, child: Center(child: row[0]))),
                                  DataCell(SizedBox(width: 300, child: row[1])),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
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
