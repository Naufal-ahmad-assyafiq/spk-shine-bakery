import 'app_data.dart';

class DataValidator {
  static bool isCriteriaComplete() {
    return AppData.criterias.isNotEmpty &&
        AppData.criterias.every((c) => c.name.trim().isNotEmpty && c.weight > 0);
  }

  static bool isAlternativeComplete() {
    return AppData.alternatives.isNotEmpty &&
        AppData.alternatives.every(
          (a) =>
              a.name.trim().isNotEmpty &&
              a.values.isNotEmpty &&
              a.values.every((v) => v > 0),
        );
  }

  static bool isAllDataComplete() {
    return isCriteriaComplete() && isAlternativeComplete();
  }
}
