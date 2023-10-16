// To parse this JSON data, do
//
//     final itemInfo = itemInfoFromJson(jsonString);

import 'dart:convert';

ItemInfo itemInfoFromJson(String str) => ItemInfo.fromJson(json.decode(str));

String itemInfoToJson(ItemInfo data) => json.encode(data.toJson());

class ItemInfo {
  String day;
  String dailyVariation;
  String id;
  String value;
  String totalVariation;
  String date;
  StockVariation stockVariation;

  ItemInfo({
    required this.day,
    required this.dailyVariation,
    required this.id,
    required this.value,
    required this.totalVariation,
    required this.date,
    required this.stockVariation,
  });

  factory ItemInfo.fromJson(Map<String, dynamic> json) => ItemInfo(
    day: json["day"],
    dailyVariation: json["dailyVariation"],
    id: json["id"],
    value: json["value"],
    totalVariation: json["totalVariation"],
    date: json["date"],
    stockVariation: StockVariation.fromJson(json["stockVariation"]),
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "dailyVariation": dailyVariation,
    "id": id,
    "value": value,
    "totalVariation": totalVariation,
    "date": date,
    "stockVariation": stockVariation.toJson(),
  };
}

class StockVariation {
  double min;
  double max;
  double closing;
  int timeStamp;
  double variation;
  double opening;

  StockVariation({
    required this.min,
    required this.max,
    required this.closing,
    required this.timeStamp,
    required this.variation,
    required this.opening,
  });

  factory StockVariation.fromJson(Map<String, dynamic> json) => StockVariation(
    min: json["min"]?.toDouble(),
    max: json["max"]?.toDouble(),
    closing: json["closing"]?.toDouble(),
    timeStamp: json["timeStamp"],
    variation: json["variation"]?.toDouble(),
    opening: json["opening"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "min": min,
    "max": max,
    "closing": closing,
    "timeStamp": timeStamp,
    "variation": variation,
    "opening": opening,
  };
}
