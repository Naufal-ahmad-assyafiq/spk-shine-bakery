import '../models/system_config_model.dart';
import '../models/criteria_model.dart';
import '../models/alternative_model.dart';

class AppData {
  static SystemConfigModel config = SystemConfigModel(
    systemName: 'Shine Bakery',
    criteriaCount: 5,
    alternativeCount: 5,
  );

  static List<CriteriaModel> criterias = [
    CriteriaModel(name: 'Harga Bahan Baku', weight: 5, type: 'Negatif / Cost', assessmentScale: 100),
    CriteriaModel(name: 'Kualitas Bahan Baku', weight: 4, type: 'Positif / Benefit', assessmentScale: 100),
    CriteriaModel(name: 'Ketersediaan Stok', weight: 3, type: 'Positif / Benefit', assessmentScale: 100),
    CriteriaModel(name: 'Pelayanan', weight: 2, type: 'Positif / Benefit', assessmentScale: 100),
    CriteriaModel(name: 'Jarak Supplier', weight: 1, type: 'Negatif / Cost', assessmentScale: 100),
  ];

  static List<AlternativeModel> alternatives = [
    AlternativeModel(name: 'Toko Susiana', values: [85.0, 80.0, 75.0, 80.0, 70.0]),
    AlternativeModel(name: 'Toko Sanitas', values: [75.0, 85.0, 80.0, 75.0, 80.0]),
    AlternativeModel(name: 'Toko Tan', values: [90.0, 75.0, 70.0, 85.0, 60.0]),
    AlternativeModel(name: 'Toko Boy', values: [80.0, 90.0, 85.0, 80.0, 75.0]),
    AlternativeModel(name: 'CV Rahmat', values: [85.0, 85.0, 80.0, 80.0, 65.0]),
  ];

  static void resetCriteria() {
    criterias = List.generate(
      config.criteriaCount,
      (index) => CriteriaModel(
        name: '',
        weight: 1,
        type: 'Positif / Benefit',
        assessmentScale: 100,
      ),
    );
  }

  static void resetAlternatives() {
    alternatives = List.generate(
      config.alternativeCount,
      (index) => AlternativeModel(
        name: '',
        values: List.generate(config.criteriaCount, (i) => 1.0),
      ),
    );
  }
}
