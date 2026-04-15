import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../theme/app_theme.dart';
import '../helpers/nav_helper.dart';
import '../widgets/bottom_nav_bar.dart';

class LocationScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  const LocationScreen({super.key, this.onToggleTheme});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchCtrl = TextEditingController();

  // ─── State ─────────────────────────────────────
  LatLng? _userLocation;
  LatLng? _selectedPlace;
  bool _isLoading = true;
  bool _showPlaceCard = false;
  bool _showRoute = false;
  int _selectedTransport = 0;

  // ─── Selected Place Data ───────────────────────
  String _placeName = '';
  String _placeAddress = '';
  double _placeRating = 0;
  bool _placeIsOpen = true;

  // ─── Campus Landmarks ──────────────────────────
  final List<Map<String, dynamic>> _campusPlaces = [
    {
      'name': 'Main Library',
      'address': 'Building A, Ground Floor',
      'lat': 36.3650,
      'lng': 6.6147,
      'rating': 4.5,
      'isOpen': true,
      'icon': Icons.menu_book_rounded,
    },
    {
      'name': 'Student Cafeteria',
      'address': 'Building C, Ground Floor',
      'lat': 36.3655,
      'lng': 6.6155,
      'rating': 4.2,
      'isOpen': true,
      'icon': Icons.restaurant_rounded,
    },
    {
      'name': 'Engineering Lab',
      'address': 'Building B, 2nd Floor',
      'lat': 36.3645,
      'lng': 6.6140,
      'rating': 4.7,
      'isOpen': false,
      'icon': Icons.science_rounded,
    },
    {
      'name': 'Sports Complex',
      'address': 'North Campus',
      'lat': 36.3660,
      'lng': 6.6130,
      'rating': 4.0,
      'isOpen': true,
      'icon': Icons.sports_soccer_rounded,
    },
    {
      'name': 'Admin Office',
      'address': 'Main Building, 1st Floor',
      'lat': 36.3648,
      'lng': 6.6160,
      'rating': 3.8,
      'isOpen': true,
      'icon': Icons.business_rounded,
    },
  ];

  final List<Map<String, dynamic>> _transportOptions = [
    {'icon': Icons.directions_car_rounded, 'label': 'Car'},
    {'icon': Icons.directions_bike_rounded, 'label': 'Bike'},
    {'icon': Icons.electric_scooter_rounded, 'label': 'Scooter'},
    {'icon': Icons.directions_walk_rounded, 'label': 'Walk'},
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _userLocation = const LatLng(36.3650, 6.6147);
          _isLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _userLocation = const LatLng(36.3650, 6.6147);
        _isLoading = false;
      });
    }
  }

  void _onMarkerTapped(Map<String, dynamic> place) {
    setState(() {
      _selectedPlace = LatLng(place['lat'], place['lng']);
      _placeName = place['name'];
      _placeAddress = place['address'];
      _placeRating = place['rating'];
      _placeIsOpen = place['isOpen'];
      _showPlaceCard = true;
      _showRoute = false;
    });

    _mapController.move(_selectedPlace!, 17);
  }

  void _onSearch(String query) {
    if (query.isEmpty) return;

    final results = _campusPlaces.where(
      (p) => p['name'].toString().toLowerCase().contains(query.toLowerCase()),
    );

    if (results.isNotEmpty) {
      _onMarkerTapped(results.first);
      _searchCtrl.clear();
      FocusScope.of(context).unfocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Location not found'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _drawRoute() {
    if (_userLocation == null || _selectedPlace == null) return;
    setState(() => _showRoute = true);

    // Fit both points in view
    final bounds = LatLngBounds.fromPoints([_userLocation!, _selectedPlace!]);
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(80)),
    );
  }

  String _getETA(int transportIndex) {
    if (_userLocation == null || _selectedPlace == null) return '--';
    final distance = Geolocator.distanceBetween(
      _userLocation!.latitude, _userLocation!.longitude,
      _selectedPlace!.latitude, _selectedPlace!.longitude,
    );
    final speeds = [8.33, 4.17, 2.78, 1.39]; // m/s: car, bike, scooter, walk
    final minutes = (distance / speeds[transportIndex] / 60).round();
    if (minutes < 1) return '1m';
    if (minutes >= 60) return '${(minutes / 60).round()}hr ${minutes % 60}m';
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // ─── OpenStreetMap ─────────────────────
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _userLocation ?? const LatLng(36.3650, 6.6147),
                    initialZoom: 16,
                    onTap: (_, __) {
                      if (_showPlaceCard) {
                        setState(() {
                          _showPlaceCard = false;
                          _showRoute = false;
                        });
                      }
                    },
                  ),
                  children: [
                    // Map tiles
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.unisphere.app',
                    ),

                    // Route line
                    if (_showRoute && _userLocation != null && _selectedPlace != null)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: [_userLocation!, _selectedPlace!],
                            strokeWidth: 4,
                            color: AppTheme.primary,
                          ),
                        ],
                      ),

                    // Markers
                    MarkerLayer(
                      markers: [
                        // User location marker
                        if (_userLocation != null)
                          Marker(
                            point: _userLocation!,
                            width: 44, height: 44,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.primary,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primary.withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.person_rounded,
                                  color: Colors.white, size: 22),
                            ),
                          ),

                        // Campus place markers
                        ..._campusPlaces.map((place) {
                          final isSelected = _selectedPlace != null &&
                              _selectedPlace!.latitude == place['lat'] &&
                              _selectedPlace!.longitude == place['lng'];
                          return Marker(
                            point: LatLng(place['lat'], place['lng']),
                            width: isSelected ? 48 : 40,
                            height: isSelected ? 48 : 40,
                            child: GestureDetector(
                              onTap: () => _onMarkerTapped(place),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? AppTheme.primary
                                      : (place['isOpen']
                                          ? const Color(0xFF4CAF50)
                                          : Colors.red),
                                  border: Border.all(color: Colors.white, width: 2.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  place['icon'] ?? Icons.place_rounded,
                                  color: Colors.white,
                                  size: isSelected ? 24 : 20,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),

                // ─── Floating Search Bar ──────────────
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12,
                  left: 20,
                  right: 20,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Icon(Icons.search_rounded, size: 22,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            style: TextStyle(fontSize: 15,
                                color: Theme.of(context).colorScheme.onSurface),
                            decoration: InputDecoration(
                              hintText: 'Search campus location...',
                              hintStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.35)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                            onSubmitted: _onSearch,
                          ),
                        ),
                        if (_searchCtrl.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchCtrl.clear();
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Icon(Icons.close_rounded, size: 20,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                            ),
                          )
                        else
                          GestureDetector(
                            onTap: () {
                              if (_searchCtrl.text.isNotEmpty) {
                                _onSearch(_searchCtrl.text);
                              }
                            },
                            child: Container(
                              width: 38, height: 38,
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.primary.withOpacity(0.1),
                              ),
                              child: Icon(Icons.mic_rounded, size: 20,
                                  color: AppTheme.primary),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // ─── FAB: Center on User ──────────────
                Positioned(
                  right: 20,
                  bottom: _showPlaceCard ? 330 : 100,
                  child: GestureDetector(
                    onTap: () {
                      if (_userLocation != null) {
                        _mapController.move(_userLocation!, 17);
                      }
                    },
                    child: Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(Icons.my_location_rounded, size: 22,
                          color: AppTheme.primary),
                    ),
                  ),
                ),

                // ─── Bottom Sheet ─────────────────────
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  left: 0,
                  right: 0,
                  bottom: _showPlaceCard ? 0 : -400,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.4 : 0.12),
                          blurRadius: 24,
                          offset: const Offset(0, -8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Drag handle
                        Center(
                          child: Container(
                            width: 40, height: 4,
                            margin: const EdgeInsets.only(top: 12, bottom: 16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),

                        // Content
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _showRoute
                              ? _buildRouteInfo(isDark)
                              : _buildPlaceInfo(isDark),
                        ),

                        // Transport options
                        if (_showRoute) ...[
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: _buildTransportRow(isDark),
                          ),
                        ],

                        // CTA Button
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                          child: SafeArea(
                            top: false,
                            child: GestureDetector(
                              onTap: () {
                                if (!_showRoute) {
                                  _drawRoute();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Navigating to $_placeName...'),
                                      backgroundColor: AppTheme.primary,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12)),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                width: double.infinity, height: 54,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors: [AppTheme.primary, AppTheme.primaryLight],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primary.withOpacity(0.35),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _showRoute ? Icons.navigation_rounded : Icons.directions_rounded,
                                      color: Colors.white, size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _showRoute ? 'Go Now' : 'Directions',
                                      style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w700,
                                        color: Colors.white, letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          handleNavTap(
            context: context, currentIndex: 3, tappedIndex: index,
            onToggleTheme: widget.onToggleTheme,
          );
        },
      ),
    );
  }

  // ─── Place Info ────────────────────────────────
  Widget _buildPlaceInfo(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: AppTheme.primary.withOpacity(0.08),
          ),
          child: Icon(Icons.place_rounded, size: 36,
              color: AppTheme.primary.withOpacity(0.4)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_placeName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFC107)),
                  const SizedBox(width: 4),
                  Text(_placeRating.toString(),
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface)),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _placeIsOpen
                          ? const Color(0xFF4CAF50).withOpacity(0.12)
                          : Colors.red.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _placeIsOpen ? 'Open' : 'Closed',
                      style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600,
                        color: _placeIsOpen ? const Color(0xFF2E7D32) : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(_placeAddress,
                  style: TextStyle(fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45))),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Route Info ────────────────────────────────
  Widget _buildRouteInfo(bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.circle, size: 12, color: AppTheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text('Your place',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface)),
            ),
            Icon(Icons.swap_vert_rounded, size: 20,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.location_on_rounded, size: 14, color: Color(0xFF4CAF50)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(_placeName,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Transport Row ─────────────────────────────
  Widget _buildTransportRow(bool isDark) {
    return Row(
      children: List.generate(_transportOptions.length, (index) {
        final isSelected = index == _selectedTransport;
        final option = _transportOptions[index];
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedTransport = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: index < _transportOptions.length - 1 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primary
                    : (isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF0EBF0)),
                borderRadius: BorderRadius.circular(14),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.3),
                          blurRadius: 8, offset: const Offset(0, 3)),
                      ]
                    : [],
              ),
              child: Column(
                children: [
                  Icon(option['icon'], size: 22,
                      color: isSelected ? Colors.white
                          : Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                  const SizedBox(height: 4),
                  Text(_getETA(index),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white
                              : Theme.of(context).colorScheme.onSurface)),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
