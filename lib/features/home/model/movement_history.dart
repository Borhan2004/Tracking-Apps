class MovementHistoryResponse {
  final List<MovementData>? ongoingMovements;
  final List<MovementData>? climbingMovements;
  final List<MovementData>? trackingRunningMovements;
  final List<MovementData>? trackingClimbs;

  MovementHistoryResponse({
    this.ongoingMovements,
    this.climbingMovements,
    this.trackingRunningMovements,
    this.trackingClimbs,
  });

  factory MovementHistoryResponse.fromJson(Map<String, dynamic> json) {
    return MovementHistoryResponse(
      ongoingMovements: (json['ongoingMovements'] as List<dynamic>?)
          ?.map((e) => MovementData.fromJson(e))
          .toList(),
      climbingMovements: (json['climbingMovements'] as List<dynamic>?)
          ?.map((e) => MovementData.fromJson(e))
          .toList(),
      trackingRunningMovements: (json['trackingRunningMovements'] as List<dynamic>?)
          ?.map((e) => MovementData.fromJson(e))
          .toList(),
      trackingClimbs: (json['trackingClimbs'] as List<dynamic>?)
          ?.map((e) => MovementData.fromJson(e))
          .toList(),
    );
  }
}

class MovementData {
  final String? id;
  final String? userId;
  final String? date;
  final double? distance;
  final String? createdAt;
  final String? updatedAt;

  MovementData({
    this.id,
    this.userId,
    this.date,
    this.distance,
    this.createdAt,
    this.updatedAt,
  });

  factory MovementData.fromJson(Map<String, dynamic> json) {
    return MovementData(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      date: json['date'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
}
