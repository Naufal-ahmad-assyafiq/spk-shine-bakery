import 'dart:math';
import '../models/criteria_model.dart';
import '../models/alternative_model.dart';
import '../models/result_model.dart';

class WeightedProduct {
  static List<double> getFixedWeights(List<CriteriaModel> criterias) {
    double totalWeight = criterias.fold(
      0.0,
      (sum, item) => sum + item.weight,
    );

    return criterias.map((c) => c.getFixedWeight(totalWeight)).toList();
  }

  static double calculateVectorS({
    required List<double> values,
    required List<double> weights,
  }) {
    double result = 1.0;

    for (int i = 0; i < values.length; i++) {
      result *= pow(values[i], weights[i]);
    }

    return result;
  }

  static List<double> calculateVectorV(List<double> vectorSList) {
    if (vectorSList.isEmpty) return [];
    double totalS = vectorSList.fold(0.0, (sum, s) => sum + s);

    if (totalS == 0) {
      return List.generate(vectorSList.length, (index) => 0.0);
    }

    return vectorSList.map((s) => s / totalS).toList();
  }

  static List<ResultModel> calculateRanking({
    required List<CriteriaModel> criterias,
    required List<AlternativeModel> alternatives,
  }) {
    if (alternatives.isEmpty || criterias.isEmpty) return [];

    final weights = getFixedWeights(criterias);

    final vectorSList = alternatives.map((alternative) {
      return calculateVectorS(
        values: alternative.values,
        weights: weights,
      );
    }).toList();

    final vectorVList = calculateVectorV(vectorSList);

    final results = List.generate(alternatives.length, (index) {
      return ResultModel(
        alternativeName: alternatives[index].name,
        vectorS: vectorSList[index],
        vectorV: vectorVList[index],
        ranking: 0,
      );
    });

    results.sort((a, b) => b.vectorV.compareTo(a.vectorV));

    for (int i = 0; i < results.length; i++) {
      results[i].ranking = i + 1;
    }

    return results;
  }
}
