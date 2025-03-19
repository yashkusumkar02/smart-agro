class CropModel {
  final String cropName;
  final String soilType;
  final double temperature;
  final double rainfall;

  CropModel({
    required this.cropName,
    required this.soilType,
    required this.temperature,
    required this.rainfall,
  });

  factory CropModel.fromJson(Map<String, dynamic> json) {
    return CropModel(
      cropName: json['cropName'],
      soilType: json['soilType'],
      temperature: json['temperature'].toDouble(),
      rainfall: json['rainfall'].toDouble(),
    );
  }
}
