// lib/src/presentation/widgets/shared/map_picker_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const MapPickerScreen({super.key, this.initialLocation});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  // --- MODIFIED: Renamed for clarity and added new state variables ---
  late LatLng _currentMapCenter;
  final MapController _mapController = MapController();

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  // --- END MODIFIED ---

  @override
  void initState() {
    super.initState();
    // Default to Casablanca if no initial location is provided
    _currentMapCenter = widget.initialLocation ?? LatLng(33.5731, -7.5898);
  }
  
  // --- ADDED: Dispose the search controller ---
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  // --- END ADDED ---

  // --- MODIFIED: This now only moves the map view, marker is separate ---
  void _handleTap(TapPosition tapPosition, LatLng latLng) {
    setState(() {
      _currentMapCenter = latLng;
    });
    _mapController.move(_currentMapCenter, _mapController.camera.zoom);
  }
  // --- END MODIFIED ---

  // --- ADDED: Function to search for a location using Nominatim API ---
  Future<void> _searchLocation() async {
    final query = _searchController.text;
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _searchResults = [];
    });

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5');

    try {
      final response = await http.get(url, headers: {
        'User-Agent': 'com.bl2026.waitless_mobile', // Be polite to the API
      });

      if (response.statusCode == 200) {
        final results = json.decode(response.body) as List;
        setState(() {
          _searchResults = List<Map<String, dynamic>>.from(results);
        });
      }
    } catch (e) {
      // Handle error, maybe show a snackbar
      debugPrint('Error searching for location: $e');
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }
  // --- END ADDED ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélectionner l\'emplacement'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Return the selected location when the checkmark is pressed
              Navigator.of(context).pop(_currentMapCenter);
            },
          ),
        ],
      ),
      // --- MODIFIED: Using a Stack to overlay search UI on the map ---
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentMapCenter,
              initialZoom: 13.0,
              onTap: _handleTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.bl2026.waitless_mobile',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: _currentMapCenter,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // --- ADDED: Search Bar and Results UI ---
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Column(
              children: [
                Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Rechercher un lieu...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: _isSearching
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 3))
                            : const Icon(Icons.search),
                        onPressed: _searchLocation,
                      ),
                    ),
                    onSubmitted: (_) => _searchLocation(),
                  ),
                ),
                if (_searchResults.isNotEmpty)
                  Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(8.0),
                    child: LimitedBox(
                      maxHeight: 200,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final result = _searchResults[index];
                          return ListTile(
                            title: Text(result['display_name'] ?? 'Unknown'),
                            onTap: () {
                              final lat = double.parse(result['lat']);
                              final lon = double.parse(result['lon']);
                              final newLocation = LatLng(lat, lon);
                              setState(() {
                                _currentMapCenter = newLocation;
                                _searchResults = []; // Hide results
                                _searchController.clear();
                                FocusScope.of(context).unfocus(); // Hide keyboard
                              });
                              _mapController.move(newLocation, 15.0);
                            },
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // --- END ADDED ---
        ],
      ),
      // --- MODIFIED: FAB now returns the current pin location ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop(_currentMapCenter);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}