import 'package:cloud_firestore/cloud_firestore.dart';

class DateIdeaModel {
  final String id;
  final String title;
  final String notes;
  final String dateType;
  final String budgetRange;
  final DateTime createdAt;

  DateIdeaModel({
    required this.id,
    required this.title,
    required this.notes,
    required this.dateType,
    required this.budgetRange,
    required this.createdAt,
  });

  factory DateIdeaModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DateIdeaModel(
      id: doc.id,
      title: data['title'] ?? '',
      notes: data['notes'] ?? '',
      dateType: data['dateType'] ?? '',
      budgetRange: data['budgetRange'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'notes': notes,
      'dateType': dateType,
      'budgetRange': budgetRange,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
