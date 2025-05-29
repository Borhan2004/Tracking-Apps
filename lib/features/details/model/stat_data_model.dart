class StatDataModel {
  final List<Movement>? ongoingMovements;
  final List<Movement>? climbingMovements;
  final List<Movement>? trackingRunningMovements;
  final List<Movement>? trackingClimbs;

  StatDataModel({
    this.ongoingMovements,
    this.climbingMovements,
    this.trackingRunningMovements,
    this.trackingClimbs,
  });

  factory StatDataModel.fromJson(Map<String, dynamic> json) {
    return StatDataModel(
      ongoingMovements:
          (json['ongoingMovements'] as List<dynamic>?)
              ?.map((e) => Movement.fromJson(e))
              .toList(),
      climbingMovements:
          (json['climbingMovements'] as List<dynamic>?)
              ?.map((e) => Movement.fromJson(e))
              .toList(),
      trackingRunningMovements:
          (json['trackingRunningMovements'] as List<dynamic>?)
              ?.map((e) => Movement.fromJson(e))
              .toList(),
      trackingClimbs:
          (json['trackingClimbs'] as List<dynamic>?)
              ?.map((e) => Movement.fromJson(e))
              .toList(),
    );
  }
}

class Movement {
  final String? id;
  final String? userId;
  final String? date;
  final double? distance;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Movement({
    this.id,
    this.userId,
    this.date,
    this.distance,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Movement.fromJson(Map<String, dynamic> json) {
    return Movement(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      date: json['date'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'])
              : null,
      v: json['__v'] as int?,
    );
  }
}
