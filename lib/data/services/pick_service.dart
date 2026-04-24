import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/fallback_lists.dart';
import '../models/pick_model.dart';
import '../models/suggestion_model.dart';
import 'auth_service.dart';

final pickServiceProvider = Provider<PickService>((ref) {
  return PickService(ref.watch(authServiceProvider));
});

final picksHistoryStreamProvider = StreamProvider<List<PickModel>>((ref) {
  return ref.watch(pickServiceProvider).getPicksHistory();
});

class PickService {
  final AuthService _authService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PickService(this._authService);

  CollectionReference get _picksRef => _firestore.collection('picks');
  CollectionReference get _suggestionsRef => _firestore.collection('suggestions');

  Stream<List<PickModel>> getPicksHistory() {
    return _picksRef
        .orderBy('pickedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => PickModel.fromFirestore(doc)).toList();
    });
  }

  Future<PickModel?> makePick(String category) async {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User not logged in");

    // 1. Get ALL suggestions for category
    final snapshot = await _suggestionsRef
        .where('category', isEqualTo: category)
        .get();

    // Filter unused locally to avoid complex Firestore query issues
    final unusedDocs = snapshot.docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return data['used'] == false;
    }).toList();

    if (unusedDocs.isEmpty) {
      // Handled by UI to show fallback
      return null;
    }

    // 2. Randomly pick one
    final docs = unusedDocs;
    final random = Random();
    final selectedDoc = docs[random.nextInt(docs.length)];
    final suggestion = SuggestionModel.fromFirestore(selectedDoc);

    // 3. Mark as used and create Pick record in a transaction/batch
    final batch = _firestore.batch();
    
    batch.update(selectedDoc.reference, {
      'used': true,
      'usedAt': FieldValue.serverTimestamp(),
    });

    final newPickRef = _picksRef.doc();
    final pick = PickModel(
      id: newPickRef.id,
      suggestionId: suggestion.id,
      category: category,
      pickedAt: DateTime.now(),
      suggestionName: suggestion.name,
      addedBy: suggestion.addedBy,
    );

    batch.set(newPickRef, {
      ...pick.toMap(),
      'pickedAt': FieldValue.serverTimestamp(), // override with server time
    });

    await batch.commit();
    return pick;
  }

  String getFallbackSuggestion(String category) {
    final random = Random();
    List<String> fallbacks = [];
    if (category == 'food') {
      fallbacks = AppConstants.fallbackFood;
    } else if (category == 'place') {
      fallbacks = AppConstants.fallbackPlaces;
    } else if (category == 'watch') {
      fallbacks = AppConstants.fallbackWatch;
    }
    
    if (fallbacks.isEmpty) return "Something nice";
    return fallbacks[random.nextInt(fallbacks.length)];
  }

  Future<void> reconsiderPick(String pickId, String suggestionId) async {
    final batch = _firestore.batch();

    // 1. Make the suggestion available again
    batch.update(_suggestionsRef.doc(suggestionId), {
      'used': false,
      'usedAt': null,
    });

    // 2. Delete the pick record so it disappears from history
    batch.delete(_picksRef.doc(pickId));

    await batch.commit();
  }
}
