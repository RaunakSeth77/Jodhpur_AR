import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iitj_ram/Maps/Directions_repository.dart';
import 'package:iitj_ram/Maps/directions.dart';
import 'package:iitj_ram/Maps/map.dart';

String lat = '';
String long = '';

class Locations extends StatefulWidget {
  @override
  State<Locations> createState() => _LocationsState();
}

List<bool> Expanded = [false, false, false];

class _LocationsState extends State<Locations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Location(),
                SizedBox(
                  height: 20,
                ),
                Location(),
                Text("Latitude:" + lat + '\nLongitude:' + long)
              ],
            )),
      ),
    );
  }
}

class Location extends StatefulWidget {
  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: MediaQuery.sizeOf(context).width * 0.95,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 10)]),
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                  image: const DecorationImage(
                      image: AssetImage(
                        "assets/images/office_of_students.jpg",
                      ),
                      fit: BoxFit.cover))),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 30, top: 5),
            child: Text(
              "Office Of \nStudents",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ),
          TextButton.icon(
              label: const Text(
                "Start",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              onPressed: () async {
                Position position = await getCurrentLocation();
                setState(() {
                  lat = position.latitude.toString();
                  long = position.longitude.toString();
                });
                print(position.latitude);
                print(position.longitude);
                Directions? info = await Directions_Repository().getDirections(
                    origin: LatLng(position.latitude, position.longitude),
                    destination: LatLng(26.46712170200536, 73.11464172307818));

                Navigator.push(
                    context,
                    CupertinoDialogRoute(
                        builder: (context) => MapScreen(
                              category: '',
                              origin:
                                  LatLng(position.latitude, position.longitude),
                              destination:
                                  LatLng(26.46712170200536, 73.11464172307818),
                              info: info!,
                            ),
                        context: context));
              },
              icon: Image.asset(
                "assets/images/arrow.png",
                height: 20,
                width: 20,
              )),

          /* Container(
            height: 40,
            decoration: BoxDecoration(
                color: Colors.blue,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black,
                      blurRadius: 10,
                      blurStyle: BlurStyle.outer)
                ],
                borderRadius: BorderRadius.circular(20)),
            child: */
        ],
      ),
    );
  }
}

Future<Position> getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error("Location services disabled");
  }
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  return Geolocator.getCurrentPosition();
}
