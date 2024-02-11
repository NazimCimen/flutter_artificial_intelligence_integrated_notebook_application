import 'package:flutter/material.dart';
import 'package:my_demo_app/utils/colors.dart';
import 'package:my_demo_app/utils/constants.dart';
import 'package:my_demo_app/utils/extensions/size_extensions.dart';
import 'package:my_demo_app/views/edit_page_view.dart';
import 'package:my_demo_app/views/main_screen_view.dart';
import 'package:my_demo_app/views/profile_screen_view.dart';

class Ui extends StatelessWidget {
  const Ui({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: myWhite,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: builFloatActingButton(context),
        appBar: buildAppBar(),
        bottomNavigationBar: buildBottomAppBar(context),
        body: buildTabBarView(),
      ),
    );
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      color: myDark1,
      elevation: 0,
      height: context.dynamicHeight(0.08),
      notchMargin: 5.0,
      shape: CircularNotchedRectangle(),
      child: TabBar(
        indicatorColor: myWhite,
        dividerColor: Colors.transparent,
        unselectedLabelColor: Colors.black,
        tabs: [
          FittedBox(
              child: Tab(
                  icon: Icon(
            Icons.dashboard_outlined,
            color: myWhite,
            size: 30,
          ))),
          FittedBox(
            child: Tab(
                icon: Icon(Icons.person_2_outlined, color: myWhite, size: 30)),
          ),
        ],
      ),
    );
  }

  TabBarView buildTabBarView() {
    return const TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [MainScreenView(), ProfileScreenView()]);
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: myDark1,
      title: Text('Notebook App', style: styleLight),
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings_outlined,
              color: myWhite,
            ))
      ],
    );
  }

  FloatingActionButton builFloatActingButton(BuildContext context) {
    return FloatingActionButton(
      shape: CircleBorder(),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditPageView(
                noteController: noteController,
                titleController: titleController,
                i: 'save',
                visible: false,
              ),
            ));
      },
      backgroundColor: myDark1,
      child: Icon(
        Icons.edit_outlined,
        color: myWhite,
      ),
    );
  }
}
