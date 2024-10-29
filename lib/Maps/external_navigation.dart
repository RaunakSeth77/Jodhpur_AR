import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iitj_ram/Maps/Directions_repository.dart';
import 'package:iitj_ram/constants.dart';
import 'package:iitj_ram/Maps/directions.dart';

import 'package:iitj_ram/Maps/map.dart';
import 'package:iitj_ram/home.dart';
import 'package:iitj_ram/main.dart';
import 'package:iitj_ram/try.dart';

import 'package:motion_tab_bar/MotionTabBarController.dart';

LatLng? destination = LatLng(0.0, 0.0);

class ExternalNavigation extends StatefulWidget {
  final String category;
  ExternalNavigation({Key? key, required this.category}) : super(key: key);

  @override
  State<ExternalNavigation> createState() => _ExternalNavigationState();
}

class _ExternalNavigationState extends State<ExternalNavigation> {
  String? category = "All Places";
  int index = 0;
  @override
  void initState() {
    category = widget.category;
    index = 0;
    super.initState();
  }

  MotionTabBarController? _controller;

  int i = 0;
  @override
  Widget build(BuildContext context) {
    print("Hi");
    print(index);
    List<String> places = cat[widget.category]!;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.popUntil(context, (route) => false);
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => HomePage(
                        category: 'All Places',
                        index: 2,
                      )));
        },
        child: Icon(Icons.home),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Roundedbar(
              color: Colors.pink,
              color2: Colors.pink[50]!,
              place: widget.category,
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Where to?",
                style: TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.only(
                  left: 20,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 4,
                          blurStyle: BlurStyle.outer)
                    ]),
                height: 50,
                width: 350,
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_pin,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      height: 100,
                      width: 250,
                      child: DropDownTextField(
                        initialValue: "Where?",
                        controller: _controller,
                        enableSearch: true,
                        dropDownList: getList(places),
                        onChanged: (value) async {
                          setState(() {
                            index = 1;
                          });
                          if (value != '') {
                            destination = value.props[1];
                          }
                          print(destination);
                          if (destination!.latitude != 0.0 &&
                              destination!.longitude != 0.0) {
                            Directions? info = await Directions_Repository()
                                .getDirections(
                                    origin: LatLng(currentLocation.latitude,
                                        currentLocation.longitude),
                                    destination: destination!);
                            Navigator.push(
                                context,
                                CupertinoDialogRoute(
                                    builder: (context) => MapScreen(
                                          category: widget.category,
                                          origin: LatLng(
                                              currentLocation.latitude,
                                              currentLocation.longitude),
                                          destination: destination!,
                                          info: info!,
                                        ),
                                    context: context));
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            [
              Center(
                child: Image.asset(
                  "assets/images/pot.png",
                  height: 300,
                ),
              ),
              Container(
                child: Column(children: [
                  Image.asset(
                    "assets/images/loading.gif",
                    height: 50,
                    width: 50,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Loading Maps...",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )
                ]),
              )
            ][index],
          ],
        ),
      ),
    );
  }
}

List<DropDownValueModel> getList(List<String> lis) {
  List<DropDownValueModel> ret = [];
  for (int i = 0; i < lis.length; i++) {
    ret.add(DropDownValueModel(name: lis[i], value: latlng[lis[i]]));
  }
  return ret;
}

class Roundedbar extends StatelessWidget implements PreferredSizeWidget {
  const Roundedbar(
      {super.key,
      required this.color,
      required this.color2,
      required this.place});
  final Color color;
  final Color color2;
  final String place;
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
                            begin: Alignment.topCenter,
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
        ),
        Positioned(
          top: 30,
          left: 20,
          child: Text(
            place,
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(220.0);
}
