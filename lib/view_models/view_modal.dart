import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_demo_app/models/note_model.dart';
import 'package:my_demo_app/services/cloud_firestore_service.dart';
import 'package:my_demo_app/services/cloud_storage_service.dart';
import 'package:my_demo_app/services/vision_ai_service.dart';
import 'package:my_demo_app/utils/constants.dart';

class MyViewModel extends ChangeNotifier {
  final MyCloudStorageService cloudStorageService = MyCloudStorageService();
  final VisionAiService _aiService = VisionAiService();
  final CloudFirestoreService _cloudFirestoreService = CloudFirestoreService();
  XFile? _image;
  String? imageUrl;
  bool isLoading = false;
  String? text;
  List<dynamic>? textAnnotations = [];

  ///KULLANICIDAN IMAGE ALIR
  Future<void> getImage(ImageSource source, BuildContext context) async {
    isLoading = true;
    Navigator.pop(context);

    notifyListeners();
    final pickedFile = await ImagePicker().pickImage(source: source);
    _image = pickedFile;
    notifyListeners();
    if (_image != null) {
      imageUrl = await cloudStorageService.uploadImage('images/', _image!);
      notifyListeners();
      if (imageUrl != null) {
        print('Image uploaded. URL: $imageUrl');
        text = await _aiService.annotateImages(imageUrl);
        noteController.text = '${noteController.text} \n $text';
        isLoading = false;
        notifyListeners();
      } else {
        print('Failed to upload image.');
      }
    }
  }

  ///Aİ İSTEK ATAR
  Future<void> requestToAi() async {
    await _aiService.annotateImages(imageUrl);
  }

  ///NOTLARI FIRESTORE'A GÖNDERİR
  Future<void> saveNoteToFireStore(
      NoteModel noteModel, BuildContext context) async {
    isLoading = true;
    focusNodeNote.unfocus();
    focusNodeTitle.unfocus();
    await Future.delayed(Duration(seconds: 2));
    notifyListeners();
    await _cloudFirestoreService.saveNote(noteModel);
    isLoading = false;
    notifyListeners();
    noteController.clear();
    titleController.clear();

    Navigator.pop(context);
  }

  Future<void> deleteNoteFromFirestore(
      BuildContext context, String noteId) async {
    isLoading = true;
    focusNodeNote.unfocus();
    focusNodeTitle.unfocus();
    await Future.delayed(Duration(seconds: 2));
    notifyListeners();
    await _cloudFirestoreService.deleteNote(noteId);
    isLoading = false;
    Navigator.pop(context);

    notifyListeners();
  }

  Future<void> updateNote(BuildContext context, String noteId, String newTitle,
      String newNote) async {
    isLoading = true;
    focusNodeNote.unfocus();
    focusNodeTitle.unfocus();
    await Future.delayed(Duration(seconds: 2));
    notifyListeners();
    await _cloudFirestoreService.updateNote(noteId, newTitle, newNote);
    isLoading = false;
    Navigator.pop(context);
    notifyListeners();
  }
}
