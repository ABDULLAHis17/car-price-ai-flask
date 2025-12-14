class CarPredictionRequest {
  final String carName;
  final int year;
  final int km;
  final int engine;
  final double power;
  final double mileage;
  final int seats;
  final String fuel;
  final String transmission;
  final String seller;
  final String owner;

  CarPredictionRequest({
    required this.carName,
    required this.year,
    required this.km,
    required this.engine,
    required this.power,
    required this.mileage,
    required this.seats,
    required this.fuel,
    required this.transmission,
    required this.seller,
    required this.owner,
  });

  Map<String, dynamic> toJson() {
    return {
      'car_name': carName,
      'year': year,
      'km': km,
      'engine': engine,
      'power': power,
      'mileage': mileage,
      'seats': seats,
      'fuel': fuel,
      'transmission': transmission,
      'seller': seller,
      'owner': owner,
    };
  }
}

class PredictionResponse {
  final bool success;
  final double predictedPrice;
  final double? realPrice;
  final String? error;

  PredictionResponse({
    required this.success,
    required this.predictedPrice,
    this.realPrice,
    this.error,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      success: json['success'] ?? false,
      predictedPrice: (json['predicted_price'] ?? 0).toDouble(),
      realPrice: json['real_price'] != null ? (json['real_price']).toDouble() : null,
      error: json['error'],
    );
  }
}

class CarInfo {
  final List<String> fuelTypes;
  final List<String> sellerTypes;
  final List<String> transmissions;
  final List<String> ownerCounts;

  CarInfo({
    required this.fuelTypes,
    required this.sellerTypes,
    required this.transmissions,
    required this.ownerCounts,
  });

  factory CarInfo.fromJson(Map<String, dynamic> json) {
    final info = json['info'] ?? {};
    return CarInfo(
      fuelTypes: List<String>.from(info['fuel_types'] ?? []),
      sellerTypes: List<String>.from(info['seller_types'] ?? []),
      transmissions: List<String>.from(info['transmissions'] ?? []),
      ownerCounts: List<String>.from(info['owner_counts'] ?? []),
    );
  }
}
