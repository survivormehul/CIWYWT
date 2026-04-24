import 'package:cloud_firestore/cloud_firestore.dart';

class PickModel {
  final String id;
  final String suggestionId;
  final String category;
  final DateTime pickedAt;
  
  // Denormalized fields for easier UI rendering without extra reads
  final String suggestionName;
  final String addedBy;

  PickModel({
    required this.id,
    required this.suggestionId,
    required this.category,
    required this.pickedAt,
    required this.suggestionName,
    required this.addedBy,
  });

  factory PickModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PickModel(
      id: doc.id,
      suggestionId: data['suggestionId'] ?? '',
      category: data['category'] ?? '',
      pickedAt: (data['pickedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      suggestionName: data['suggestionName'] ?? '',
      addedBy: data['addedBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'suggestionId': suggestionId,
      'category': category,
      'pickedAt': Timestamp.fromDate(pickedAt),
      'suggestionName': suggestionName,
      'addedBy': addedBy,
    };
  }
}
