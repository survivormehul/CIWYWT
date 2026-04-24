import 'package:cloud_firestore/cloud_firestore.dart';

class SuggestionModel {
  final String id;
  final String name;
  final String category;
  final String? subcategory;
  final String addedBy;
  final bool used;
  final DateTime? usedAt;
  final DateTime createdAt;

  SuggestionModel({
    required this.id,
    required this.name,
    required this.category,
    this.subcategory,
    required this.addedBy,
    this.used = false,
    this.usedAt,
    required this.createdAt,
  });

  factory SuggestionModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SuggestionModel(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      subcategory: data['subcategory'],
      addedBy: data['addedBy'] ?? '',
      used: data['used'] ?? false,
      usedAt: (data['usedAt'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      if (subcategory != null) 'subcategory': subcategory,
      'addedBy': addedBy,
      'used': used,
      'usedAt': usedAt != null ? Timestamp.fromDate(usedAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  SuggestionModel copyWith({
    String? id,
    String? name,
    String? category,
    String? subcategory,
    String? addedBy,
    bool? used,
    DateTime? usedAt,
    DateTime? createdAt,
  }) {
    return SuggestionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      addedBy: addedBy ?? this.addedBy,
      used: used ?? this.used,
      usedAt: usedAt ?? this.usedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}