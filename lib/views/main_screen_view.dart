import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_demo_app/utils/constants.dart';
import 'package:my_demo_app/utils/methods.dart';
import 'package:my_demo_app/view_models/view_modal.dart';
import 'package:my_demo_app/utils/colors.dart';
import 'package:my_demo_app/utils/extensions/assets_paths_extension.dart';
import 'package:my_demo_app/utils/extensions/size_extensions.dart';
import 'package:my_demo_app/views/edit_page_view.dart';
import 'package:provider/provider.dart';

class MainScreenView extends StatelessWidget {
  const MainScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhite,
      body: buildColumn(context),
    );
  }

  Center buildColumn(BuildContext context) {
    return Center(
      child: Column(
        children: [
          context.verticalSizedBox(0.018),
          SizedBox(
              height: context.dynamicHeight(0.22),
              width: context.dynamicWidht(0.92),
              child: buildContainerIntroduction(context)),
          SizedBox(
            height: context.dynamicHeight(0.06),
            child: Center(child: buildText()),
          ),
          SizedBox(
            height: context.dynamicHeight(0.50),
            width: context.dynamicWidht(0.91),
            child: buildStreamBuilder(),
          )
        ],
      ),
    );
  }

  ///firestore da kayıtlı olan notların ekranda görüntülendiği yer
  StreamBuilder<QuerySnapshot<Object?>> buildStreamBuilder() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('notes').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: SpinKitFadingCube(
            color: myDark1,
            size: 36,
          ));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No notes found.'));
        }
        return SizedBox(
            height: context.dynamicHeight(0.59),
            width: context.dynamicWidht(0.85),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var note = snapshot.data!.docs[index];
                return GestureDetector(
                  onTap: () {},
                  child: Card(
                      color: myDark1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPageView(
                                  noteController: TextEditingController(
                                      text: note['notes']),
                                  titleController: TextEditingController(
                                      text: note['title']),
                                  i: note['id'],
                                  visible: true,
                                ),
                              ));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: myDark1,
                            borderRadius: BorderRadius.circular(23),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(note['title'], style: styleLight),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    note['notes'],
                                    style: styleLight,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Divider(
                                      color: myWhite,
                                    ),
                                    Text(
                                      convertDate(note['datePublished']),
                                      style: styleLight,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                );
              },
            ));
      },
    );
  }

  Align buildText() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '   My Notes',
        style: TextStyle(
          color: myDark1,
          fontSize: 22,
          fontFamily: 'Riot',
        ),
      ),
    );
  }

  Align buildContainerIntroduction(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: context.paddingAllLow,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22), color: myDark1),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: context.paddingMedium,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            'Convert text in your photos to written text using artificial intelligence.',
                            style: TextStyle(
                              color: myWhite,
                              fontFamily: 'Riot',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                              onPressed: () {},
                              child: Text(
                                'learn more',
                                style: TextStyle(
                                  color: myWhite,
                                  fontFamily: 'Riot',
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(flex: 4, child: Image.asset(context.ai_logo_path)),
                Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
