import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/suggestion_model.dart';
import 'auth_service.dart';

final suggestionServiceProvider = Provider<SuggestionService>((ref) {
  return SuggestionService(ref.watch(authServiceProvider));
});

final suggestionsStreamProvider = StreamProvider.family<List<SuggestionModel>, String>((ref, category) {
  return ref.watch(suggestionServiceProvider).getSuggestions(category);
});

class SuggestionService {
  final AuthService _authService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SuggestionService(this._authService);

  CollectionReference get _suggestionsRef => _firestore.collection('suggestions');

  Stream<List<SuggestionModel>> getSuggestions(String category) {
    return _suggestionsRef
        .where('category', isEqualTo: category)
        // We removed .orderBy('createdAt') from here so you don't need to manually
        // build a composite index in the Firebase Console. We'll sort it locally!
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs.map((doc) => SuggestionModel.fromFirestore(doc)).toList();
      // Sort locally: newest first
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  Future<void> addSuggestion(String name, String category, {String? subcategory}) async {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User not logged in");

    final nameLower = name.trim().toLowerCase();

    // Prevent duplicates (case insensitive)
    final existingQuery = await _suggestionsRef
        .where('category', isEqualTo: category)
        .get();
        
    final exists = existingQuery.docs.any((doc) {
      final docName = (doc.data() as Map<String, dynamic>)['name']?.toString().toLowerCase() ?? '';
      return docName == nameLower;
    });

    if (exists) {
      throw Exception("This idea is already in your list! ✨");
    }

    final newSuggestion = SuggestionModel(
      id: '', // Will be set by firestore
      name: name.trim(),
      category: category,
      subcategory: subcategory,
      addedBy: user.uid,
      createdAt: DateTime.now(),
    );

    await _suggestionsRef.add(newSuggestion.toMap());
  }

  Future<void> refreshCategory(String category) async {
    // Sets used = false for all suggestions in that category
    final snapshot = await _suggestionsRef.where('category', isEqualTo: category).get();
    
    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {
        'used': false,
        'usedAt': null,
      });
    }
    await batch.commit();
  }
}
