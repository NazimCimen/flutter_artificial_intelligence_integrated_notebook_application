import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_demo_app/models/note_model.dart';
import 'package:uuid/uuid.dart';

class CloudFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> saveNote(NoteModel noteModel) async {
    String res = "Some error occurred";
    try {
      if (noteModel.title.isNotEmpty && noteModel.note.isNotEmpty) {
        _firestore.collection('notes').doc(noteModel.id).set({
          'title': noteModel.title,
          'notes': noteModel.note,
          'id': noteModel.id,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deleteNote(String noteId) async {
    try {
      await _firestore.collection('notes').doc(noteId).delete();
      return 'success';
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> updateNote(
      String noteId, String newTitle, String newNote) async {
    try {
      await _firestore.collection('notes').doc(noteId).update({
        'title': newTitle,
        'notes': newNote,
        'dateUpdated': DateTime.now(), // Güncelleme tarihini ekleyebilirsiniz
      });
      return 'success';
    } catch (err) {
      return err.toString();
    }
  }
}
