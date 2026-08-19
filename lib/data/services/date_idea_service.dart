import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/date_idea_model.dart';

final dateIdeaServiceProvider = Provider<DateIdeaService>((ref) {
  return DateIdeaService();
});

final dateIdeasStreamProvider = StreamProvider<List<DateIdeaModel>>((ref) {
  return ref.watch(dateIdeaServiceProvider).getDateIdeas();
});

class DateIdeaService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('dateIdeas');

  Stream<List<DateIdeaModel>> getDateIdeas() {
    return _collection.orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => DateIdeaModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> addDateIdea(DateIdeaModel idea) async {
    await _collection.add(idea.toMap());
  }

  Future<void> updateDateIdea(DateIdeaModel idea) async {
    await _collection.doc(idea.id).update(idea.toMap());
  }

  Future<void> deleteDateIdea(String id) async {
    await _collection.doc(id).delete();
  }
}
