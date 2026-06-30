class CriteriaModel {
  String name;
  int weight;
  String type;
  int assessmentScale;

  CriteriaModel({
    required this.name,
    required this.weight,
    required this.type,
    required this.assessmentScale,
  });

  double getFixedWeight(double totalWeight) {
    if (totalWeight == 0) return 0;

    double fixedWeight = weight / totalWeight;

    if (type.toLowerCase().contains('cost') ||
        type.toLowerCase().contains('negatif')) {
      return -fixedWeight;
    }

    return fixedWeight;
  }
}
