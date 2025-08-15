import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:estate/models/property.dart';
import 'package:estate/services/firebase_service.dart';
import 'package:estate/widgets/estate_cards.dart';
import 'package:estate/utils/auth_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  List<Property> _properties = [];
  Property? _selectedProperty;
  bool _isLoading = true;
  bool _showPropertyDetails = false;

  // Default camera position (Douala, Cameroon)
  static const CameraPosition _defaultPosition = CameraPosition(
    target: LatLng(4.0511, 9.7679), // Douala coordinates
    zoom: 12.0,
  );

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Get properties from Firebase
      final propertiesStream = FirebaseService.getProperties();
      await for (final properties in propertiesStream) {
        if (mounted) {
          setState(() {
            _properties = properties;
            _createMarkers();
            _isLoading = false;
          });
          break; // Take the first snapshot
        }
      }
    } catch (e) {
      print('Error loading properties: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _createMarkers() {
    _markers.clear();
    
    for (final property in _properties) {
      // Skip properties with invalid coordinates
      if (property.latitude == 0.0 && property.longitude == 0.0) {
        print('Skipping property ${property.title} - invalid coordinates');
        continue;
      }
      
      final marker = Marker(
        markerId: MarkerId(property.id),
        position: LatLng(property.latitude, property.longitude),
        infoWindow: InfoWindow(
          title: property.title,
          snippet: '${property.priceDisplay} • ${property.propertyTypeDisplay}',
          onTap: () {
            setState(() {
              _selectedProperty = property;
              _showPropertyDetails = true;
            });
          },
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          _getMarkerColor(property.listingType),
        ),
        onTap: () async {
          final isAuthenticated = await AuthUtils.requireAuthentication(
            context,
            'view property details',
          );
          if (isAuthenticated) {
            setState(() {
              _selectedProperty = property;
              _showPropertyDetails = true;
            });
          }
        },
      );
      
      _markers.add(marker);
    }
    
    print('Created ${_markers.length} markers for ${_properties.length} properties');
  }

  double _getMarkerColor(ListingType listingType) {
    switch (listingType) {
      case ListingType.rent:
        return BitmapDescriptor.hueBlue; // Blue for rent
      case ListingType.sale:
        return BitmapDescriptor.hueRed; // Red for sale
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _animateToProperty(Property property) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(property.latitude, property.longitude),
          15.0,
        ),
      );
    }
  }

  void _showPropertyList() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPropertyListSheet(),
    );
  }

  Widget _buildPropertyListSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Properties (${_properties.length})',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Property list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _properties.length,
              itemBuilder: (context, index) {
                final property = _properties[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        property.imageUrls.isNotEmpty 
                            ? property.imageUrls.first 
                            : 'https://via.placeholder.com/60x60',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[300],
                            child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      property.title,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.location,
                          style: GoogleFonts.poppins(color: Colors.grey[600]),
                        ),
                        Text(
                          property.priceDisplay,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: property.listingType == ListingType.rent 
                            ? Colors.blue.shade100 
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        property.listingType == ListingType.rent ? 'Rent' : 'Sale',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: property.listingType == ListingType.rent 
                              ? Colors.blue[700] 
                              : Colors.red[700],
                        ),
                      ),
                    ),
                    onTap: () async {
                      final isAuthenticated = await AuthUtils.requireAuthentication(
                        context,
                        'view property details',
                      );
                      if (isAuthenticated) {
                        Navigator.pop(context);
                        _animateToProperty(property);
                        setState(() {
                          _selectedProperty = property;
                          _showPropertyDetails = true;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Map
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: _defaultPosition,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onTap: (_) {
              setState(() {
                _showPropertyDetails = false;
                _selectedProperty = null;
              });
            },
          ),
          
          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          
          // No properties overlay
          if (!_isLoading && _properties.isEmpty)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_off, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No Properties Found',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Properties will appear here once added to the database',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Top app bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.blue[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Property Map',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _showPropertyList,
                    icon: Icon(Icons.list, color: Colors.blue[700]),
                    tooltip: 'Show Property List',
                  ),
                ],
              ),
            ),
          ),
          
          // Property details bottom sheet
          if (_showPropertyDetails && _selectedProperty != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Handle bar
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    
                    // Property details
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Property image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                _selectedProperty!.imageUrls.isNotEmpty 
                                    ? _selectedProperty!.imageUrls.first 
                                    : 'https://via.placeholder.com/80x80',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
                                  );
                                },
                              ),
                            ),
                            
                            const SizedBox(width: 16),
                            
                            // Property info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedProperty!.title,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _selectedProperty!.location,
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _selectedProperty!.listingType == ListingType.rent 
                                              ? Colors.blue.shade100 
                                              : Colors.red.shade100,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          _selectedProperty!.listingType == ListingType.rent ? 'Rent' : 'Sale',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: _selectedProperty!.listingType == ListingType.rent 
                                                ? Colors.blue[700] 
                                                : Colors.red[700],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${_selectedProperty!.beds} bed • ${_selectedProperty!.baths} bath',
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _selectedProperty!.priceDisplay,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // View details button
                            ElevatedButton(
                              onPressed: () async {
                                final isAuthenticated = await AuthUtils.requireAuthentication(
                                  context,
                                  'view property details',
                                );
                                if (isAuthenticated) {
                                  // Navigate to property details
                                  // You can implement this navigation
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Viewing details for ${_selectedProperty!.title}'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[700],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('View'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_mapController != null) {
            _mapController!.animateCamera(
              CameraUpdate.newCameraPosition(_defaultPosition),
            );
          }
        },
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        child: const Icon(Icons.my_location),
        tooltip: 'Reset Map View',
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}