class BottleHistoryData {
  final int id;
  final String quantity;
  final String buildingName;
  final String block;
  final String room;
  final String saleUser;
  final DateTime createdAt;

  BottleHistoryData({
    required this.id,
    required this.quantity,
    required this.buildingName,
    required this.block,
    required this.room,
    required this.saleUser,
    required this.createdAt,
  });

  factory BottleHistoryData.fromJson(Map<String, dynamic> json) {
    return BottleHistoryData(
      id: json['id'],
      quantity: json['quantity'],
      buildingName: json['building_name'],
      block: json['block'],
      room: json['room'],
      saleUser: json['sale_user'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'building_name': buildingName,
      'block': block,
      'room': room,
      'sale_user': saleUser,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class BottleHistory {
  final String date;
  final List<BottleHistoryData> entries;

  BottleHistory({
    required this.date,
    required this.entries,
  });

  factory BottleHistory.fromJson(Map<String, dynamic> json) {
    return BottleHistory(
      date: json['date'],
      entries: (json['entries'] as List)
          .map((e) => BottleHistoryData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'entries': entries.map((e) => e.toJson()).toList(),
    };
  }
}

class BottleHistoryResponse {
  final bool status;
  final List<BottleHistory> data;

  BottleHistoryResponse({
    required this.status,
    required this.data,
  });

  factory BottleHistoryResponse.fromJson(Map<String, dynamic> json) {
    return BottleHistoryResponse(
      status: json['status'],
      data:
          (json['data'] as List).map((e) => BottleHistory.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
