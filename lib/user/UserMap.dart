import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:user_safe_cab/AllWidgets/progressDialog.dart';
import 'package:user_safe_cab/Assistant/assistantMethods.dart';
import 'package:user_safe_cab/dataHandler/appData.dart';
import 'package:user_safe_cab/user/divider.dart';
import 'package:user_safe_cab/user/searchScreen.dart';



class UserMap extends StatefulWidget {
  @override
  _UserMap createState() => _UserMap();
}

class _UserMap extends State<UserMap> {
    Completer<GoogleMapController> _controllerGoogleMap = Completer();
    GoogleMapController newGoogleMapController;


    GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

    List<LatLng>pLineCoordinates = [];
    Set<Polyline> polylineSet = {};

   static final CameraPosition initialLocation = CameraPosition(
     target: LatLng(37.42796133580664, -122.085749655962),
     zoom: 14.4746,
   );

    Position currentPosition;
    var geoLocator =  Geolocator();
    double bottomPaddingOfMap = 0;
    BitmapDescriptor customIcon;

    Set<Marker> markersSet = {};
    Set<Circle> circlesSet = {};


   void locatePosition() async{
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentPosition = position;

      LatLng  latLatPosition = LatLng(position.latitude, position.longitude);
      
      CameraPosition cameraPosition = new CameraPosition(target: latLatPosition,zoom: 14);
      newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      String address = await  AssistantMethods.searchCoordinateAddress(position,context);
      print("This is your Address ::" + address);
    }

/*
  File _image;
  final picker = ImagePicker();

  void getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery
    );
    setState(() {
      _image = File(pickedFile.path);
    });
  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
         appBar: AppBar(
           title: Text(" UserMap"),
         ),
      drawer: Container(
        color: Colors.white,
        width: 250.0,
        child: Drawer(
          child: ListView(
            children: [
              //Drawer Header
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      /*Container(
                  margin: EdgeInsets.only(top:5),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 15.0
                  ),
                  child: Center(
                      child: InkWell(
                        onTap: (){
                          getImage();
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 80.0,
                          child: CircleAvatar(
                            radius: 80.0,
                            child: ClipOval(
                              child: (_image != null)
                                  ? Image.file(_image)
                                  : Image.asset('images/image.jpg'),
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                  ),
                ),*/
                      Image.asset(
                        "assets/images/user_icon.jng",
                        height: 65.0,width: 65.0,
                      ),
                      SizedBox(height: 16.0,),
                      Column(
                        mainAxisAlignment:  MainAxisAlignment.center,
                        children: [
                          Text("Profile Name",style: TextStyle(fontSize: 16.0),),
                          SizedBox(height: 6.0,),
                          Text("Visit Profile"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              DividerWidget(),
              SizedBox(height: 12.0,),
              //Drawer body controllers
              ListTile(
                leading: Icon(Icons.history),
                title: Text("History", style: TextStyle(fontSize: 16.0),),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Visit Profile", style: TextStyle(fontSize: 16.0),),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("About", style: TextStyle(fontSize: 16.0),),
              ),

            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
           initialCameraPosition:initialLocation,
            myLocationButtonEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            polylines: polylineSet,
            markers: markersSet,
            circles: circlesSet,
            onMapCreated: (GoogleMapController controller){
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;
            setState(() {
            bottomPaddingOfMap = 300.0;
            });
            locatePosition();
            },

          ),

       //HamburgerButton for a drawer
       /*   Positioned(
            top: 45.0,
            left: 22.0,
            child: GestureDetector(
              onTap: (){
                scaffoldKey.currentState.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [
                    BoxShadow(color: Colors.black,
                    blurRadius: 6.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7,0.7),),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.menu,color: Colors.black,),
                  radius: 20.0,
                ),
              ),
            ),
          ),*/
          //buttom menu
        Positioned(
         left: 0.0,
         right: 0.0,
         bottom: 0.0,
         child: Container(
           height: 300.0,
           decoration: BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.only(
                 topLeft: Radius.circular(18.0),
                 topRight: Radius.circular(18.0)),
             boxShadow: [
               BoxShadow(
                 color: Colors.black,
                 blurRadius: 16.0,
                 spreadRadius: 0.5,
                 offset: Offset(0.7, 0.7),
               ),
             ],
           ),
          child: Padding(
             padding: const EdgeInsets.symmetric(
                 horizontal: 24.0,
                 vertical: 18.0),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [

                /* SizedBox(height: 6.0),
                 Text("Hi there,",style: TextStyle(fontSize: 12.0 ),),
                 Text("where to?,",style: TextStyle(fontSize: 20.0 ),),*/
                 SizedBox(height: 20.0),
                 GestureDetector(
                   onTap: () async
                   {
                       var res = await Navigator.push(context,MaterialPageRoute(builder: (context) =>SearchScreen()));
                        if(res =="obtainDirection")
                        {
                          await getPlaceDirection();
                        }
                        },
                   child: Container(
                     height: 50.0,
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(5.0),
                       boxShadow: [ BoxShadow(
                           color: Colors.black54,
                           blurRadius: 6.0,
                           spreadRadius: 0.5,
                           offset: Offset(0.7, 0.7),
                         ),
                       ],
                     ),
                     child: Padding(
                       padding:  EdgeInsets.all(12.0),
                       child: Row(
                         children: [
                           Icon(Icons.search,color: Colors.blueAccent),
                           SizedBox(width: 10.0),
                           Text("Search Drop off")
                         ],
                       ),
                     ),
                   ),
                 ),
                 SizedBox(height: 24.0,),
                 Row(
                   children:[
                   Icon(Icons.home,color: Colors.grey),
                   SizedBox(width: 5.0),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         Provider.of<AppData>(context).pickUpLocation != null
                             ?  Provider.of<AppData>(context).pickUpLocation.placeName
                             : "Add Home"
                       ),
                       SizedBox(height: 4.0,),
                       Text("Your home address",
                         style: TextStyle(
                             color: Colors.black54,
                             fontSize: 12.0),
                       ),
                     ],
                   ),
                   ],
                 ),
                 SizedBox(height: 10.0),
                 DividerWidget(),
                 SizedBox(height: 10.0),
                 Row(
                   children:[
                     Icon(Icons.work, color: Colors.grey),
                     SizedBox(width: 16.0,),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text("Add Work"),
                         SizedBox(height: 4.0,),
                         Text("Your office address",
                           style: TextStyle(
                               color: Colors.black54,
                               fontSize: 12.0),
                         ),
                       ],
                     ),
                   ],
                 ),
                 SizedBox(height: 10.0),
                 DividerWidget(),
                 SizedBox(height: 20.0),
                 Row(
                   crossAxisAlignment:  CrossAxisAlignment.end,
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     FlatButton(
                       padding: EdgeInsets.symmetric(horizontal: 30.0),
                       color: Theme.of(context).primaryColor,
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),
                       ),
                       child: Text(
                         'NewRide',
                         style: TextStyle(
                           color: Colors.black,
                           fontSize: 20.0,
                         ),
                       ),
                       onPressed: (){},
                     ),
                     FlatButton(
                       padding: EdgeInsets.symmetric(horizontal: 30.0),
                       color: Theme.of(context).primaryColor,
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),
                       ),
                       child: Text(
                         'EndRide',
                         style: TextStyle(
                           color: Colors.black,
                           fontSize: 20.0,
                         ),
                       ),
                       onPressed: (){},
                     ),
                   ],
                 ),
               ],
             ),
           ),
         ),
          ),

      /*  Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child:Container(
            height: 300.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(16.0),topLeft: Radius.circular(16.0),),
              boxShadow: [
                 BoxShadow(
                   color: Colors.black,
                   blurRadius:16.0,
                   spreadRadius: 0.5,
                   offset: Offset(0.7,0.7),
                 ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.tealAccent,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Image.asset("assets/images/taxi.png",height: 70.0,width: 80.0,),
                        SizedBox(width: 16.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Car", style: TextStyle(fontSize: 18.0)),
                            Text("Car", style: TextStyle(fontSize: 18.0)),
                          ],
                        ),
                      ],
                    ),
                   ),
                ),
              ],
            ),
          ),
        ),*/
        ],
      ),
    );
  }

  Future<void> getPlaceDirection()async
  {
    var initialPos = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
    );

    var details = await AssistantMethods.obtainPlaceDirectionDetails(pickUpLatLng, dropOffLatLng);
    Navigator.pop(context);

    print("This is  Encoded Points ::");
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult = polylinePoints.decodePolyline(details.encodedPoints);

    pLineCoordinates.clear();
    if(decodedPolyLinePointsResult.isNotEmpty)
    {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
       pLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
     polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
          color: Colors.amber,
          polylineId: PolylineId("PolyLineID"),
          jointType: JointType.round,
          points: pLineCoordinates,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true

      );

      polylineSet.add(polyline);
    });
    LatLngBounds latLngBounds;

    if(pickUpLatLng.latitude >  dropOffLatLng.latitude && pickUpLatLng.longitude > dropOffLatLng.longitude)
    {
      latLngBounds = LatLngBounds(southwest: dropOffLatLng , northeast: pickUpLatLng);
    }
    else   if(pickUpLatLng.longitude >  dropOffLatLng.longitude)
    {
      latLngBounds = LatLngBounds(southwest: LatLng(pickUpLatLng.latitude,dropOffLatLng.longitude), northeast: LatLng(dropOffLatLng.latitude,pickUpLatLng.longitude));
    }
    else   if(pickUpLatLng.latitude >  dropOffLatLng.latitude)
    {
      latLngBounds = LatLngBounds(southwest: LatLng(dropOffLatLng.latitude,pickUpLatLng.longitude), northeast: LatLng(pickUpLatLng.latitude,dropOffLatLng.longitude));
    }

     newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds,70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow: InfoWindow(title: initialPos.placeName, snippet: "My Location"),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: finalPos.placeName, snippet: "DropOff Location"),
      position: dropOffLatLng,
      markerId: MarkerId("dropOffId"),
    );
    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
      fillColor: Colors.blue,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId:   CircleId("pickUpId"),
    );

    Circle dropOfLocCircle = Circle(
      fillColor: Colors.deepPurple,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.purple,
      circleId:   CircleId("dropOffId"),
    );

    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOfLocCircle);
    });
  }
 /* void initGeoFireListner()
  {
    Geofire.initialize("");
     //Comment
    Geofire.queryAtLocation(30.730743, 76.774948, 5).listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:
            keysRetrieved.add(map["key"]);
            break;

          case Geofire.onKeyExited:
            keysRetrieved.remove(map["key"]);
            break;

          case Geofire.onKeyMoved:
          // Update your key's location
            break;

          case Geofire.onGeoQueryReady:
          // All Intial Data is loaded
            print(map['result'])

            break;
        }
      }

      setState(() {});
    });
    //comment
  }*/
}

