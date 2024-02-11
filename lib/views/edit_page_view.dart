import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_demo_app/models/note_model.dart';
import 'package:my_demo_app/utils/colors.dart';
import 'package:my_demo_app/utils/constants.dart';
import 'package:my_demo_app/utils/extensions/size_extensions.dart';
import 'package:my_demo_app/view_models/view_modal.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EditPageView extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  String i;
  bool visible;
  EditPageView(
      {super.key,
      required this.titleController,
      required this.noteController,
      required this.i,
      required this.visible});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myDark1,
      appBar: buildAppBar(context),
      resizeToAvoidBottomInset: false,
      body: buildStack(context),
    );
  }

  Stack buildStack(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: context.dynamicHeight(0.75),
                child: buildInputContainer(),
              ),
              SizedBox(
                height: context.dynamicHeight(0.08),
                width: context.dynamicWidht(0.5),
                child: buildAiButton(context),
              )
            ],
          ),
        ),
        buildLoadingAnimation(context)
      ],
    );
  }

  Center buildLoadingAnimation(BuildContext context) {
    return Center(
      child: Visibility(
          visible: context.watch<MyViewModel>().isLoading,
          child: SpinKitFadingCube(
            color: myDark1,
            size: 36,
          )),
    );
  }

  TextButton buildAiButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          _showMenu(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/ai.png'),
            Text(
              '   import with AI',
              style: styleLight,
            ),
          ],
        ));
  }

  Container buildInputContainer() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: myWhite,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.grey,
          width: 2.0,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: TextField(
              focusNode: focusNodeTitle,
              style: styleDark,
              controller: titleController,
              maxLines: 1,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: myGrey),
                hintText: 'Write your title here...',
                border: UnderlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: TextField(
              focusNode: focusNodeNote,
              controller: noteController,
              style: styleDark,
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: myGrey),
                hintText: 'Write your note here...',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: myDark1,
      title: Text(
        'Notebook App',
        style: styleLight,
      ),
      actions: [
        Visibility(
          visible: visible,
          child: IconButton(
              onPressed: () async {
                await context
                    .read<MyViewModel>()
                    .deleteNoteFromFirestore(context, i);
              },
              icon: Icon(
                Icons.delete_outline_outlined,
                color: myWhite,
                size: 26,
              )),
        ),
        IconButton(
          onPressed: () async {
            if (i == 'save') {
              await context.read<MyViewModel>().saveNoteToFireStore(
                  NoteModel(
                      title: titleController.text,
                      note: noteController.text,
                      id: Uuid().v1()),
                  context);
            } else {
              await context.read<MyViewModel>().updateNote(
                  context, i, titleController.text, noteController.text);
            }
          },
          icon: Icon(
            Icons.save_alt_outlined,
            color: myWhite,
            size: 26,
          ),
        )
      ],
    );
  }
}

void _showMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Take a Photo'),
              onTap: () {
                context
                    .read<MyViewModel>()
                    .getImage(ImageSource.camera, context);
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Choose from Gallery'),
              onTap: () async {
                await context
                    .read<MyViewModel>()
                    .getImage(ImageSource.gallery, context);
              },
            ),
          ],
        ),
      );
    },
  );
}
