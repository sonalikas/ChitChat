import 'dart:async';
// import 'dart:io';

// import 'package:fluttertoast/fluttertoast.dart';

// import '../../Api/Model/location_response.dart';
import 'package:fl_location/fl_location.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
// import '../../Api/api_wrapper.dart';

enum ButtonState { LOADING, DONE, DISABLED }

class GetLocation extends StatefulWidget {
  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  StreamSubscription<Location>? _locationSubscription;
  bool isLoading = true;
  String _result = '';

  String country = '';
  String name = '';
  String street = '';
  String postalCode = '';
  ButtonState _getLocationButtonState = ButtonState.DONE;
  ButtonState _listenLocationStreamButtonState = ButtonState.DONE;


  // locationResponse _locationResponse = locationResponse();



// Future<void> _getAddressFromLatLng(Position position) async {
//   await placemarkFromCoordinates(
//       _currentPosition!.latitude, _currentPosition!.longitude)
//       .then((List<Placemark> placemarks) {
//     Placemark place = placemarks[0];
//     setState(() {
//       _currentAddress =
//       '${place.street}, ${place.subLocality},
//       ${place.subAdministrativeArea}, ${place.postalCode}';
//     });
//   }).catchError((e) {
//     debugPrint(e);
//   });
// }

@override
void initState() {
  super.initState();

  getLocation();
  if (!kIsWeb) {
    FlLocation.getLocationServicesStatusStream().listen((event) {
      print('location services status: $event');
    });
  }
}


  Future<bool> _checkAndRequestPermission({bool? background}) async {
    if (!await FlLocation.isLocationServicesEnabled) {
      // Location services are disabled.
      return false;
    }

    var locationPermission = await FlLocation.checkLocationPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      // Cannot request runtime permission because location permission is denied forever.
      return false;
    } else if (locationPermission == LocationPermission.denied) {
      // Ask the user for location permission.
      locationPermission = await FlLocation.requestLocationPermission();
      if (locationPermission == LocationPermission.denied ||
          locationPermission == LocationPermission.deniedForever) return false;
    }

    // Location permission must always be allowed (LocationPermission.always)
    // to collect location data in the background.
    if (background == true &&
        locationPermission == LocationPermission.whileInUse) return false;

    // Location services has been enabled and permission have been granted.
    return true;
  }

  void _refreshPage() {
    setState(() {});
  }

  Future<void> _getLocation() async {
    if (await _checkAndRequestPermission()) {
      _getLocationButtonState = ButtonState.LOADING;
      _listenLocationStreamButtonState = ButtonState.DISABLED;
      _refreshPage();

      final timeLimit = const Duration(seconds: 10);
      await FlLocation.getLocation(timeLimit: timeLimit).then((location) {
        _result = location.toJson().toString();

      }).onError((error, stackTrace) {
        _result = error.toString();
      }).whenComplete(() {
        _getLocationButtonState = ButtonState.DONE;
        _listenLocationStreamButtonState = ButtonState.DONE;
        _refreshPage();
      });
    }
  }

  Future<void> getLocation() async {
    List<Placemark> placemark = await placemarkFromCoordinates(UserLocation.lat, UserLocation.long);

    print(placemark[0].country);
    print(placemark[0].name);
    print(placemark[0].street);
    print(placemark[0].postalCode);

    setState(() {
      country = placemark[0].country!;
      name = placemark[0].name!;
      street = placemark[0].street!;
      postalCode = placemark[0].postalCode!;
    });
  }

  // sendLocation( double? latitude,
  //     double? longitude,
  //     double? accuracy,
  //     double? altitude,
  //     double? speed,
  //     double? speedAccuracy,
  //     double? heading,
  //     String? MillisecondsSinceEpoch,
  //     String? time,
  //     bool? isMock) async {
  //   FocusScope.of(context).unfocus();
  //   setState(() {
  //     this.isLoading = true;
  //   });
  //   await ApiWrapper.locations(latitude, longitude, accuracy,altitude,
  //       heading ,
  //       speed,
  //       speedAccuracy,
  //       MillisecondsSinceEpoch,
  //       time,isMock).then((response) {
  //     setState(() {
  //       _locationResponse = response;
  //       if(_locationResponse.data !=null || _locationResponse.data !=""){
  //         Fluttertoast.showToast(
  //             msg: 'Successfully submit ',
  //             timeInSecForIosWeb: 1,
  //             backgroundColor: Colors.black38,
  //             textColor: Colors.white
  //         );
  //       }
  //     });
  //   }).catchError((error) {
  //     debugPrint(error);
  //     setState(() {
  //       this.isLoading = false;
  //     });
  //   });
  // }


  Future<void> _listenLocationStream() async {
    if (await _checkAndRequestPermission()) {
      if (_locationSubscription != null) await _cancelLocationSubscription();

      _locationSubscription = FlLocation.getLocationStream()
          .handleError(_handleError)
          .listen((event) {
        _result = event.toJson().toString();
        _refreshPage();
      });

      _getLocationButtonState = ButtonState.DISABLED;
      _refreshPage();
    }
  }

  Future<void> _cancelLocationSubscription() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;

    _getLocationButtonState = ButtonState.DONE;
    _refreshPage();
  }

  void _handleError(dynamic error, StackTrace stackTrace) {
    _result = error.toString();
    _refreshPage();
  }



  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp( debugShowCheckedModeBanner: false,
      home: Scaffold(
        body:
        //_getLocation,
        _buildContentView(),
      ),
    );
  }

  Widget _buildContentView() {
    final buttonList = Padding(
      padding: const EdgeInsets.only(top: 45.0),
      child: Column(
        children: [
          const SizedBox(height: 8.0),
          _buildTestButton(
            text: 'GET Location',
            state: _getLocationButtonState,
            onPressed: _getLocation,
          ),
          const SizedBox(height: 8.0),
          // _buildTestButton(
          //   text: _locationSubscription == null
          //       ? 'Listen LocationStream'
          //       : 'Cancel LocationSubscription',
          //   state: _listenLocationStreamButtonState,
          //   onPressed: _locationSubscription == null
          //       ? _listenLocationStream
          //       : _cancelLocationSubscription,
          // ),
        ],
      ),
    );

    final resultText =
    Text(_result, style: Theme.of(context).textTheme.bodyText1);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      children: [
        buttonList,
        const SizedBox(height: 10.0),
        resultText,
      ],
    );
  }

  Widget _buildTestButton({
    required String text,
    required ButtonState state,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      child: state == ButtonState.LOADING
          ? SizedBox.fromSize(
        size: const Size(20.0, 20.0),
        child: const CircularProgressIndicator(strokeWidth: 2.0),
      )
          : Text(text),
      onPressed: state == ButtonState.DONE ? onPressed : null,
    );
  }
}