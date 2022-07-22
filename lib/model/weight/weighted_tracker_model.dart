// To parse this JSON data, do
//
//     final weightedTrackerModel = weightedTrackerModelFromJson(jsonString);

import 'dart:convert';

WeightedTrackerModel weightedTrackerModelFromJson(String str) => WeightedTrackerModel.fromJson(json.decode(str));

String weightedTrackerModelToJson(WeightedTrackerModel data) => json.encode(data.toJson());

class WeightedTrackerModel {
  WeightedTrackerModel({
    this.weight,
    this.timestamp,
    this.documentId,
  });

  double? weight;
  String? timestamp;
  String? documentId;

  factory WeightedTrackerModel.fromJson(Map<String, dynamic> json) => WeightedTrackerModel(
    weight: json["weight"] ?? 0.00,
    timestamp: json["timestamp"] ??  DateTime.now().toString() ,
    documentId: json["document_id"] ??  DateTime.now().toString() ,
  );

  Map<String, dynamic> toJson() => {
    "weight": weight ?? 0.00,
    "timestamp": timestamp ??  DateTime.now().toString() ,
    "document_id": documentId ?? DateTime.now().toString() ,
  };
}
