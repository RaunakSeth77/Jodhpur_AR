import 'dart:async';
import 'dart:math' as math; // Import the math library
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:iitj_ram/Maps/directions.dart';
import 'package:iitj_ram/Maps/external_navigation.dart';
import 'package:iitj_ram/home.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../unity_demo_screen.dart';

class MapScreen extends StatefulWidget {
  Directions info;
  final LatLng origin;
  final LatLng destination;
  final String category;

  MapScreen({
    Key? key,
    required this.info,
    required this.origin,
    required this.destination,
    required this.category,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  late Location location;
  bool _isNavigated=false;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _checkLocation();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkLocation() {
    int distance=int.parse(widget.info.totalDistance.replaceAll(RegExp(r'[a-zA-Z]'), ''));
      if (distance <= 5.0 && !_isNavigated) {
        _isNavigated=true;
        Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) =>
                  UnityDemoScreen()),);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink[50],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    ExternalNavigation(category: widget.category),
              ),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            // This ensures the map expands to take up available space
            child: GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition: CameraPosition(
                target: widget.origin,
                zoom: 15,
              ),
              onMapCreated: (controller) => _controller = controller,
              markers: {
                Marker(
                  markerId: const MarkerId("Origin"),
                  infoWindow: const InfoWindow(title: "Origin"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue),
                  position: widget.origin,
                ),
                Marker(
                  markerId: const MarkerId("Destination"),
                  infoWindow: const InfoWindow(title: "Destination"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                  position: widget.destination,
                ),
              },
              polylines: {
                Polyline(
                  polylineId: PolylineId('overview_polyline'),
                  color: Colors.blue,
                  jointType: JointType.round,
                  width: 10,
                  startCap: Cap.roundCap,
                  patterns: [PatternItem.dot],
                  endCap: Cap.roundCap,
                  points: widget.info.polylinepoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
              },
            ),
          ),
          Container(
            height: MediaQuery.sizeOf(context).height * 0.196,
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              color: Colors.pink[50],
            ),
            child: Column(
              children: [
                const SizedBox(width: 10),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Distance : ${widget.info.totalDistance}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Time: ${widget.info.totalDuration}",
                    style: TextStyle(
                        color: Colors.green[900],
                        fontSize: 25,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(width: 80),
                    GestureDetector(
                      onTap: () {
                        Navigator.popUntil(context, (route) => false);
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const HomePage(
                              category: "All Places",
                              index: 2,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue[300],
                        ),
                        child: const Text(
                          "Home",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.popUntil(context, (route) => false);
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const HomePage(
                              category: "All Places",
                              index: 2,
                            ),
                          ),
                        );
                        launchUrl(Uri.parse(
                            "google.navigation:q=${widget.destination.latitude},${widget.destination.longitude}"));
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green[400],
                        ),
                        child: const Text(
                          "Drive",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
/* add_marker(LatLng pos) async {
    Position positon = await getCurrentLocation();

    final Marker _origin = Marker(
        markerId: const MarkerId("Origin"),
        infoWindow: const InfoWindow(title: "Origin"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: LatLng(positon.latitude, positon.longitude));

    final directions = await Directions_Repository().getDirections(
        origin: _origin.position, destination: _destination.position);
    setState(() {
      widget.info = directions!;
    });*/
