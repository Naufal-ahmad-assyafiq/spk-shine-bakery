import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import '../../models/alternative_model.dart';
import '../utils/responsive.dart';
import '../widgets/section_title.dart';
import '../widgets/responsive_button.dart';
import '../widgets/responsive_table_container.dart';

class AssessmentPage extends StatefulWidget {
  const AssessmentPage({Key? key}) : super(key: key);

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _nameControllers = [];
  final List<List<double>> _values = [];

  @override
  void initState() {
    super.initState();
    if (AppData.alternatives.length != AppData.config.alternativeCount) {
      AppData.resetAlternatives();
    }

    for (var alt in AppData.alternatives) {
      _nameControllers.add(TextEditingController(text: alt.name));

      List<double> vals = List.from(alt.values);
      if (vals.length != AppData.config.criteriaCount) {
        vals = List.generate(AppData.config.criteriaCount, (i) => 1.0);
      }

      // Check bounds
      for (int i = 0; i < AppData.config.criteriaCount; i++) {
        if (i < AppData.criterias.length) {
          double maxScale = AppData.criterias[i].assessmentScale.toDouble();
          if (vals[i] > maxScale) {
            vals[i] = maxScale;
          }
          if (vals[i] <= 0) {
            vals[i] = 1.0;
          }
        }
      }
      _values.add(vals);
    }
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveAssessment() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      for (int i = 0; i < AppData.config.alternativeCount; i++) {
        AppData.alternatives[i] = AlternativeModel(
          name: _nameControllers[i].text.trim(),
          values: _values[i],
        );
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Penilaian alternatif berhasil disimpan!'),
        backgroundColor: Color(0xFF2E7D32),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const Color cream = Color(0xFFFFF8EC);
    const Color brown = Color(0xFF5D4037);
    const Color lightBrown = Color(0xFFD7B98E);

    final bool isMobile = Responsive.isMobile(context);

    // Dynamic input widths
    final double altWidth = isMobile ? 170 : 220;
    final double scoreWidth = isMobile ? 120 : 140;

    final bool hasCriteria = AppData.criterias.isNotEmpty &&
        AppData.criterias.every((c) => c.name.trim().isNotEmpty);

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text(
          'Penilaian Alternatif',
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
                        title: 'Matriks Keputusan Penilaian',
                        subtitle: 'Masukkan nama alternatif dan nilai untuk setiap kriteria.',
                      ),
                      const SizedBox(height: 12),

                      if (!hasCriteria)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: lightBrown, width: 1.5),
                          ),
                          child: const Center(
                            child: Text(
                              'Silakan lengkapi Data Kriteria terlebih dahulu sebelum mengisi penilaian.',
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      else
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
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
                                    dataRowMinHeight: 56,
                                    dataRowMaxHeight: 72,
                                    columns: [
                                      DataColumn(
                                        label: SizedBox(
                                          width: altWidth,
                                          child: const Text(
                                            'Nama Alternatif',
                                            style: TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      ...List.generate(AppData.config.criteriaCount, (index) {
                                        final c = AppData.criterias[index];
                                        final label = c.name.trim().isNotEmpty ? c.name : 'C${index + 1}';
                                        return DataColumn(
                                          label: SizedBox(
                                            width: scoreWidth,
                                            child: Text(
                                              label,
                                              style: const TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13),
                                              softWrap: true,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                    rows: List.generate(AppData.config.alternativeCount, (rowIndex) {
                                      return DataRow(
                                        cells: [
                                          // Nama Alternatif
                                          DataCell(
                                            SizedBox(
                                              width: altWidth,
                                              child: TextFormField(
                                                controller: _nameControllers[rowIndex],
                                                decoration: const InputDecoration(
                                                  isDense: true,
                                                  border: OutlineInputBorder(),
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                ),
                                                style: const TextStyle(color: brown, fontSize: 13),
                                                validator: (val) {
                                                  if (val == null || val.trim().isEmpty) return '';
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          // Dropdown values
                                          ...List.generate(AppData.config.criteriaCount, (colIndex) {
                                            final c = AppData.criterias[colIndex];
                                            final maxScale = c.assessmentScale;
                                            final currentVal = _values[rowIndex][colIndex];
                                            final dropdownItems = List.generate(maxScale, (i) => (i + 1).toDouble());

                                            return DataCell(
                                              SizedBox(
                                                width: scoreWidth,
                                                child: DropdownButtonFormField<double>(
                                                  value: currentVal,
                                                  isExpanded: true,
                                                  decoration: const InputDecoration(
                                                    isDense: true,
                                                    border: OutlineInputBorder(),
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                                  ),
                                                  dropdownColor: Colors.white,
                                                  style: const TextStyle(color: brown, fontSize: 13),
                                                  items: dropdownItems.map((val) {
                                                    return DropdownMenuItem<double>(
                                                      value: val,
                                                      child: Center(
                                                        child: Text(
                                                          '${val.toInt()}',
                                                          style: const TextStyle(fontSize: 13),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (val) {
                                                    if (val != null) {
                                                      setState(() {
                                                        _values[rowIndex][colIndex] = val;
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                            );
                                          }),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              ResponsiveButton(
                                text: 'Simpan Penilaian',
                                onPressed: _saveAssessment,
                                icon: Icons.save,
                              ),
                            ],
                          ),
                        ),
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
