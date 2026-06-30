import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import '../../models/criteria_model.dart';
import '../utils/responsive.dart';
import '../widgets/section_title.dart';
import '../widgets/responsive_button.dart';
import '../widgets/responsive_table_container.dart';

class CriteriaPage extends StatefulWidget {
  const CriteriaPage({Key? key}) : super(key: key);

  @override
  State<CriteriaPage> createState() => _CriteriaPageState();
}

class _CriteriaPageState extends State<CriteriaPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _weightControllers = [];
  final List<String> _types = [];
  final List<int> _scales = [];

  @override
  void initState() {
    super.initState();
    if (AppData.criterias.length != AppData.config.criteriaCount) {
      AppData.resetCriteria();
    }

    for (var c in AppData.criterias) {
      _nameControllers.add(TextEditingController(text: c.name));
      _weightControllers.add(TextEditingController(text: '${c.weight}'));
      _types.add(c.type);
      _scales.add(c.assessmentScale);
    }
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    for (var controller in _weightControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveCriteria() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      for (int i = 0; i < AppData.config.criteriaCount; i++) {
        AppData.criterias[i] = CriteriaModel(
          name: _nameControllers[i].text.trim(),
          weight: int.parse(_weightControllers[i].text.trim()),
          type: _types[i],
          assessmentScale: _scales[i],
        );
      }

      // Clamp alternative values to prevent out of bounds scale selections
      for (var alt in AppData.alternatives) {
        if (alt.values.length != AppData.config.criteriaCount) {
          alt.values = List.generate(AppData.config.criteriaCount, (i) => 1.0);
        }
        for (int i = 0; i < AppData.config.criteriaCount; i++) {
          double maxScale = AppData.criterias[i].assessmentScale.toDouble();
          if (alt.values[i] > maxScale) {
            alt.values[i] = maxScale;
          }
        }
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kriteria dinamis berhasil disimpan!'),
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
    final double nameWidth = isMobile ? 160 : 220;
    final double weightWidth = isMobile ? 90 : 110;
    final double typeWidth = isMobile ? 170 : 200;
    final double scaleWidth = isMobile ? 180 : 220;

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text(
          'Data Kriteria',
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
                        title: 'Pengaturan Kriteria Dinamis',
                        subtitle: 'Tentukan nama, bobot angka, jenis kriteria, dan skala penilaian kriteria.',
                      ),
                      const SizedBox(height: 12),

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
                                    DataColumn(label: SizedBox(width: nameWidth, child: Text('Nama Kriteria', style: const TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13)))),
                                    DataColumn(label: SizedBox(width: weightWidth, child: const Text('Bobot', style: TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13), textAlign: TextAlign.center))),
                                    DataColumn(label: SizedBox(width: typeWidth, child: const Text('Jenis', style: TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13)))),
                                    DataColumn(label: SizedBox(width: scaleWidth, child: const Text('Isian Penilaian', style: TextStyle(fontWeight: FontWeight.bold, color: brown, fontSize: 13)))),
                                  ],
                                  rows: List.generate(AppData.config.criteriaCount, (index) {
                                    return DataRow(
                                      cells: [
                                        // Nama Kriteria
                                        DataCell(
                                          SizedBox(
                                            width: nameWidth,
                                            child: TextFormField(
                                              controller: _nameControllers[index],
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
                                        // Bobot
                                        DataCell(
                                          SizedBox(
                                            width: weightWidth,
                                            child: TextFormField(
                                              controller: _weightControllers[index],
                                              keyboardType: TextInputType.number,
                                              textAlign: TextAlign.center,
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                border: OutlineInputBorder(),
                                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                              ),
                                              style: const TextStyle(color: brown, fontSize: 13),
                                              validator: (val) {
                                                if (val == null || val.trim().isEmpty) return '';
                                                final parsed = int.tryParse(val.trim());
                                                if (parsed == null || parsed <= 0) return '';
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        // Jenis Dropdown
                                        DataCell(
                                          SizedBox(
                                            width: typeWidth,
                                            child: DropdownButtonFormField<String>(
                                              value: _types[index],
                                              isExpanded: true,
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                border: OutlineInputBorder(),
                                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                              ),
                                              style: const TextStyle(color: brown, fontSize: 13),
                                              dropdownColor: Colors.white,
                                              items: const [
                                                DropdownMenuItem<String>(
                                                  value: 'Positif / Benefit',
                                                  child: Text('Positif / Benefit', style: TextStyle(fontSize: 13)),
                                                ),
                                                DropdownMenuItem<String>(
                                                  value: 'Negatif / Cost',
                                                  child: Text('Negatif / Cost', style: TextStyle(fontSize: 13)),
                                                ),
                                              ],
                                              onChanged: (val) {
                                                if (val != null) {
                                                  setState(() {
                                                    _types[index] = val;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        // Isian Penilaian Dropdown
                                        DataCell(
                                          SizedBox(
                                            width: scaleWidth,
                                            child: DropdownButtonFormField<int>(
                                              value: _scales[index],
                                              isExpanded: true,
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                border: OutlineInputBorder(),
                                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                              ),
                                              style: const TextStyle(color: brown, fontSize: 13),
                                              dropdownColor: Colors.white,
                                              items: const [
                                                DropdownMenuItem<int>(
                                                  value: 5,
                                                  child: Text('Skala 1-5', style: TextStyle(fontSize: 13)),
                                                ),
                                                DropdownMenuItem<int>(
                                                  value: 10,
                                                  child: Text('Skala 1-10', style: TextStyle(fontSize: 13)),
                                                ),
                                                DropdownMenuItem<int>(
                                                  value: 100,
                                                  child: Text('Skala 1-100', style: TextStyle(fontSize: 13)),
                                                ),
                                              ],
                                              onChanged: (val) {
                                                if (val != null) {
                                                  setState(() {
                                                    _scales[index] = val;
                                                  });
                                                }
                                              },
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

                            ResponsiveButton(
                              text: 'Simpan Kriteria',
                              onPressed: _saveCriteria,
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
