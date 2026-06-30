import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import '../utils/responsive.dart';
import '../widgets/section_title.dart';
import '../widgets/responsive_button.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_dropdown.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _systemNameController;
  late int _criteriaCount;
  late int _alternativeCount;

  @override
  void initState() {
    super.initState();
    _systemNameController = TextEditingController(text: AppData.config.systemName);
    _criteriaCount = AppData.config.criteriaCount;
    _alternativeCount = AppData.config.alternativeCount;
  }

  @override
  void dispose() {
    _systemNameController.dispose();
    super.dispose();
  }

  void _confirmAndSave() {
    if (!_formKey.currentState!.validate()) return;

    final systemName = _systemNameController.text.trim();
    final bool criteriaChanged = _criteriaCount != AppData.config.criteriaCount;
    final bool alternativeChanged = _alternativeCount != AppData.config.alternativeCount;

    if (criteriaChanged || alternativeChanged) {
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          const Color brown = Color(0xFF5D4037);
          const Color cream = Color(0xFFFFF8EC);
          return AlertDialog(
            backgroundColor: cream,
            title: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange),
                SizedBox(width: 8),
                Text('Konfirmasi Perubahan', style: TextStyle(color: brown, fontWeight: FontWeight.bold)),
              ],
            ),
            content: const Text(
              'Mengubah jumlah kriteria atau alternatif akan merestart data kriteria dan penilaian alternatif. '
              'Apakah Anda yakin ingin melanjutkan?',
              style: TextStyle(color: brown),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _doSave(systemName, criteriaChanged, alternativeChanged);
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE59A45)),
                child: const Text('Ya, Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      );
    } else {
      _doSave(systemName, false, false);
    }
  }

  void _doSave(String systemName, bool resetC, bool resetA) {
    setState(() {
      AppData.config.systemName = systemName;
      AppData.config.criteriaCount = _criteriaCount;
      AppData.config.alternativeCount = _alternativeCount;

      if (resetC) {
        AppData.resetCriteria();
        AppData.resetAlternatives();
      } else if (resetA) {
        AppData.resetAlternatives();
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Setup sistem berhasil disimpan!'),
        backgroundColor: Color(0xFF2E7D32),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const Color cream = Color(0xFFFFF8EC);
    const Color brown = Color(0xFF5D4037);

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text(
          'Setup Sistem',
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
                        title: 'Pengaturan Parameter Sistem',
                        subtitle: 'Atur nama sistem/usaha, jumlah kriteria, dan jumlah alternatif.',
                      ),
                      const SizedBox(height: 12),

                      CustomCard(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Use responsive Wrap layout for columns on tablets/desktop
                              Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: [
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? double.infinity : 320,
                                    child: CustomInput(
                                      controller: _systemNameController,
                                      labelText: 'Nama Sistem / Usaha',
                                      hintText: 'Misal: Shine Bakery',
                                      validator: (val) {
                                        if (val == null || val.trim().isEmpty) {
                                          return 'Nama sistem/usaha tidak boleh kosong';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? double.infinity : 320,
                                    child: CustomDropdown<int>(
                                      value: _criteriaCount,
                                      labelText: 'Jumlah Kriteria',
                                      items: List.generate(10, (index) => index + 1).map((val) {
                                        return DropdownMenuItem<int>(
                                          value: val,
                                          child: Text('$val Kriteria'),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() {
                                            _criteriaCount = val;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? double.infinity : 320,
                                    child: CustomDropdown<int>(
                                      value: _alternativeCount,
                                      labelText: 'Jumlah Alternatif',
                                      items: List.generate(10, (index) => index + 1).map((val) {
                                        return DropdownMenuItem<int>(
                                          value: val,
                                          child: Text('$val Alternatif'),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() {
                                            _alternativeCount = val;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              ResponsiveButton(
                                text: 'Simpan Setup',
                                onPressed: _confirmAndSave,
                                icon: Icons.save,
                              ),
                            ],
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
