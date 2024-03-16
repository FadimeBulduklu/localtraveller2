import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'sign_up_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen()
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    MapPage(),
    DestinationsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Harita',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            label: 'Gidilecek Yerler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profilim',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}


class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;
  LatLng _currentPosition = LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Konum servisleri etkin değilse kullanıcıyı bilgilendir
      return Future.error('Konum servisleri devre dışı.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // İzinler reddedildiyse kullanıcıyı bilgilendir
        return Future.error('Konum izinleri reddedildi');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // İzinler kalıcı olarak reddedildiyse kullanıcıyı bilgilendir
      return Future.error('Konum izinleri kalıcı olarak reddedildi, izin isteyemeyiz.');
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    // Kullanıcının mevcut konumuna kamera pozisyonunu animasyonlu bir şekilde ayarla
    if (_controller != null) {
      _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14,
      )));
    }
  }

  Set<Marker> _createMarker() {
    return {
      Marker(
        markerId: MarkerId("currentLocation"),
        position: _currentPosition,
        infoWindow: InfoWindow(title: "Mevcut Konumunuz"),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Harita'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          // İlk konum belirlendiğinde kamerayı güncelle
          if (_currentPosition.latitude != 0 && _currentPosition.longitude != 0) {
            controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: _currentPosition,
              zoom: 14,
            )));
          }
        },
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 14,
        ),
        markers: _createMarker(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _determinePosition();
        },
        child: Icon(Icons.location_searching),
      ),
    );
  }
}


class DestinationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gidilecek Yerler'),
      ),
      body: Center(
        child: Text('Gidilecek Yerler Sayfası'),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gidilecek Yerler'),
      ),
      body: Center(
        child: Text('Gidilecek Yerler Sayfası'),
      ),
    );
  }
}
