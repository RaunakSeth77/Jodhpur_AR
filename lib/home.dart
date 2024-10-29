// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iitj_ram/Ar_World.dart';
import 'package:iitj_ram/Maps/Directions_repository.dart';

import 'package:iitj_ram/constants.dart';
import 'package:iitj_ram/Maps/directions.dart';
import 'package:iitj_ram/Maps/external_navigation.dart';
import 'package:iitj_ram/Maps/map.dart';
import 'package:iitj_ram/try.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

int i = 1;

List<String> tabs = ["Go", "Home", "AR World"];

class HomePage extends StatefulWidget {
  final int index;
  final String category;
  const HomePage({super.key, required this.category, required this.index});

  void initState() {}

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> lis = [];
  MotionTabBarController? _controller;

  @override
  void initState() {
    i = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.index);
    print(i);
    return Scaffold(
        bottomNavigationBar: MotionTabBar(
          textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          tabSelectedColor: colors["Blue"],
          tabIconSize: 35,
          controller: _controller,
          initialSelectedTab: tabs[widget.index],
          labels: const ["Go", "Home", "AR World"],
          icons: const [
            Icons.location_pin,
            Icons.home,
            Icons.home_max_rounded,
          ],
          onTabItemSelected: (int value) {
            setState(() {
              i = value;
            });
          },
        ),
        body: [
          ExternalNavigation(category: widget.category),
          SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.pink[50]),
                  //  gradient: LinearGradient(
                  //     begin: Alignment.topCenter,
                  //   end: Alignment.bottomCenter,
                  // colors: [Colors.pink[100]!, Colors.pink])),
                  padding: const EdgeInsets.only(top: 220),
                  child: Column(
                      children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(
                                  left: (MediaQuery.sizeOf(context).width -
                                          260 -
                                          45) /
                                      2),
                              child: const Text(
                                "Quick Access",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    width: (MediaQuery.sizeOf(context).width -
                                            260 -
                                            65) /
                                        2),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  ExternalNavigation(
                                                      category: "Sports")));
                                    },
                                    icon: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: colors["Blue"],
                                      child: Image.asset(
                                        images['Sports']!,
                                        width: 25,
                                        height: 25,
                                      ),
                                    )),
                                IconButton(
                                    onPressed: () async {
                                      Position position =
                                          await getCurrentLocation();
                                      LatLng destination = latlng[
                                          "Primary Health Care Center(PHC)"]!;
                                      Directions? info =
                                          await Directions_Repository()
                                              .getDirections(
                                                  origin: LatLng(
                                                      position.latitude,
                                                      position.longitude),
                                                  destination: destination);
                                      Navigator.push(
                                          context,
                                          CupertinoDialogRoute(
                                              builder: (context) => MapScreen(
                                                    category: 'Amenities',
                                                    origin: LatLng(
                                                        position.latitude,
                                                        position.longitude),
                                                    destination: destination,
                                                    info: info!,
                                                  ),
                                              context: context));
                                    },
                                    icon: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: colors["Blue"],
                                      child: Image.asset(
                                        images['Medical']!,
                                        width: 25,
                                        height: 25,
                                      ),
                                    )),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  ExternalNavigation(
                                                      category: "Hostels")));
                                    },
                                    icon: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: colors["Blue"],
                                      child: Image.asset(
                                        images['Hostels']!,
                                        width: 25,
                                        height: 25,
                                      ),
                                    )),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  ExternalNavigation(
                                                      category: "All Places")));
                                    },
                                    icon: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: colors["Blue"],
                                      child: Image.asset(
                                        images['Hostels']!,
                                        width: 25,
                                        height: 25,
                                      ),
                                    )),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: (MediaQuery.sizeOf(context).width -
                                          260 -
                                          45) /
                                      2),
                              alignment: Alignment.topLeft,
                              child: const Text(
                                "Choose to navigate",
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ] +
                          optionCreator(
                              3, 2, MediaQuery.sizeOf(context).width)),
                ),
                RoundedAppBar(
                  color: colors['Blue']!,
                  color2: Colors.blue[100]!,
                ),
                const Positioned(
                  top: 50,
                  left: 20,
                  child: Text(
                    "IITJ RAM",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
          Ar_World(),
        ][i]);
  }
}

class Box extends StatefulWidget {
  final String image;
  final String text;
  final int page;
  const Box(
      {super.key, required this.text, required this.image, required this.page});

  @override
  State<Box> createState() => _BoxState();
}

class _BoxState extends State<Box> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: ((context) =>
                    HomePage(category: widget.text, index: 0))));
      },
      child: Container(
        padding: const EdgeInsets.only(top: 20),
        height: 130,
        width: 130,
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Colors.black,
                  blurRadius: 3,
                  blurStyle: BlurStyle.outer)
            ],
            border: Border.all(color: colors['Blue']!, width: 2.5),
            borderRadius: BorderRadius.circular(15)),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Image.asset(
                widget.image,
                width: 60,
                height: 60,
              ),
              Container(
                  alignment: Alignment.center,
                  child: Text(
                    widget.text,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> optionCreator(int rows, int columns, pageWidth) {
  List<Widget> lis = [];
  double Width = 0;
  double margin = 0;
  if (columns == 2) {
    Width = 40;
    margin = (pageWidth - 260 - (Width + 5)) / 2;
  }
  if (columns == 3) {
    Width = 5;
    margin = 5;
  }

  for (int i = 0; i < rows * columns; i += columns) {
    List<Widget> list = [
      SizedBox(
        width: margin,
      ),
    ];
    for (int j = i; j < columns + i; j++) {
      list.add(
        Box(
          text: Categories[j],
          image: images[Categories[j]]!,
          page: 0,
        ),
      );
      if (j != columns + i - 1) {
        list.add(SizedBox(
          width: Width,
        ));
      }
    }
    Widget row = Row(children: list);
    lis.add(row);
    if (i != (rows - 1) * columns) {
      lis.add(const SizedBox(
        height: 20,
      ));
    }
  }
  return lis;
}

class RoundedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RoundedAppBar({super.key, required this.color, required this.color2});
  final Color color;
  final Color color2;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.fromSize(
          size: preferredSize,
          child: LayoutBuilder(builder: (context, constraint) {
            final width = constraint.maxWidth * 6;
            return ClipRect(
              child: OverflowBox(
                maxHeight: double.infinity,
                maxWidth: double.infinity,
                child: SizedBox(
                  width: width,
                  height: width,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: width / 2 - preferredSize.height / 2),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomCenter,
                            colors: [color2, color],
                            stops: [0.8, 0.999]),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(color: Colors.black54, blurRadius: 10.0)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        Positioned(
          top: 15,
          left: MediaQuery.sizeOf(context).width * 0.5,
          child: Image.asset(
            images['clock']!,
            height: 200,
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(220.0);
}
