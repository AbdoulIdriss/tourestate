import 'package:estate/models/appartment.dart';
import 'package:estate/providers/favorites_provider.dart';
import 'package:estate/screens/booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


class EstateDetail extends StatefulWidget {
  final Apartment apartment;

  const EstateDetail({super.key, required this.apartment});

  @override
  State<EstateDetail> createState() => _EstateDetailState();
}

class _EstateDetailState extends State<EstateDetail> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageGallery(),
                  _buildHeader(),
                  const Divider(height: 10, indent: 16, endIndent: 16),
                  _buildAboutSection(),
                  // _buildFacilities(),
                  _buildAmenitiesSection(),
                  _buildLocationMapSection(),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {

    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFav = favoritesProvider.isFavorite(widget.apartment);
    
    return Stack(
      children: [
        SizedBox(
          height: 400,
          child: PageView.builder(
            itemCount: widget.apartment.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                widget.apartment.imageUrls[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              );
            },
          ),
        ),
        Positioned(
          top: 60,
          left: 16,
          child: _buildIconButton(
            icon: Icons.arrow_back,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        Positioned(
          top: 60,
          right: 16,
          child: Row(
            children: [
              _buildIconButton(icon: Icons.share_outlined, onPressed: () {}),
              const SizedBox(width: 10),
              _buildIconButton(
                icon: isFav ? Icons.bookmark : Icons.bookmark_border, // Change icon based on favorite status
                onPressed: () {
                  favoritesProvider.toggleFavorite(widget.apartment); // Toggle favorite status
                },
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_currentImageIndex + 1} / ${widget.apartment.imageUrls.length}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black87),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.apartment.title,
            style: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.apartment.location,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                '${widget.apartment.rating}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              Text(
                ' (${widget.apartment.reviewCount} reviews)',
                style: GoogleFonts.poppins(color: Colors.grey[600]),
              ),
              const Text('  ·  '),
              Icon(Icons.person_outline, size: 18, color: Colors.grey[700]),
              const SizedBox(width: 4),
              Text(
                widget.apartment.ownerName,
                style: GoogleFonts.poppins(color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }

    Widget _buildAboutSection() {
    // Split the description into words
    List<String> words = widget.apartment.description.split(' ');
    bool showReadMore = words.length > 16;
    String displayedDescription = '';

    if (showReadMore) {
      displayedDescription = words.take(16).join(' ') + '...';
    } else {
      displayedDescription = widget.apartment.description;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            displayedDescription,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
            // No maxLines or overflow needed here, as we're explicitly truncating words
          ),
          if (showReadMore)
            GestureDetector(
              onTap: () => _showFullDescriptionSheet(context, widget.apartment.description),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Read more',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black, // A color to indicate it's tappable
                    fontWeight: FontWeight.bold, // Make it bold
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // New method to show the full description in a DraggableScrollableSheet
  void _showFullDescriptionSheet(BuildContext context, String description) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to take up more screen height
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5, // Start at 50% of screen height
          maxChildSize: 0.9, // Can be dragged up to 90%
          minChildSize: 0.3, // Can be dragged down to 30%
          builder: (BuildContext context, ScrollController scrollController) {
            return Column(
              children: [
                // Handle for dragging
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Text(
                  'Description',
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Expanded(
                  child: SingleChildScrollView( // Use SingleChildScrollView for the description text
                    controller: scrollController,
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      description,
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[800]),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Widget _buildFacilities() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Facilities',
  //           style: GoogleFonts.poppins(
  //             fontSize: 20,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: [
  //             _buildFacilityIcon(
  //               Icons.bed_outlined,
  //               '${widget.apartment.beds} Beds',
  //             ),
  //             _buildFacilityIcon(
  //               Icons.bathtub_outlined,
  //               '${widget.apartment.baths} Baths',
  //             ),
  //             _buildFacilityIcon(
  //               Icons.square_foot_outlined,
  //               '${widget.apartment.area} m²',
  //             ),
  //             if (widget.apartment.hasGarage)
  //               _buildFacilityIcon(Icons.garage_outlined, 'Garage'),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildFacilityIcon(IconData icon, String label) {
  //   return Column(
  //     children: [
  //       Container(
  //         padding: const EdgeInsets.all(16),
  //         decoration: BoxDecoration(
  //           color: const Color(0xFFF5EFEF), // A soft beige color
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         child: Icon(icon, size: 28, color: const Color(0xFFC07F5A)),
  //       ),
  //       const SizedBox(height: 8),
  //       Text(label, style: GoogleFonts.poppins(color: Colors.grey[700])),
  //     ],
  //   );
  // }


  // --- AMENITIES SECTION ---
  Widget _buildAmenitiesSection() {
    // Show a preview of the first 6 amenities
    final amenitiesPreview = widget.apartment.amenities.take(6).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amenities',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4.0, // Adjust aspect ratio for item height
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: amenitiesPreview.length,
            itemBuilder: (context, index) {
              final amenity = amenitiesPreview[index];
              return Row(
                children: [
                  Icon(amenity.icon, color: Colors.grey[700], size: 20),
                  const SizedBox(width: 12),
                  Text(amenity.name, style: GoogleFonts.poppins(fontSize: 15)),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          if (widget.apartment.amenities.length > 6)
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _showAllAmenities,
              child: Text(
                'Show all ${widget.apartment.amenities.length} amenities',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  // --- METHOD TO SHOW ALL AMENITIES IN A MODAL BOTTOM SHEET ---
  void _showAllAmenities() {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allows the sheet to take up more screen height
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5, // Start at 50% of screen height
          maxChildSize: 0.9, // Can be dragged up to 90%
          minChildSize: 0.3, // Can be dragged down to 30%
          builder: (BuildContext context, ScrollController scrollController) {
            return Column(
              children: [
                // Handle for dragging
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Text(
                  'All Amenities',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: widget.apartment.amenities.length,
                    itemBuilder: (context, index) {
                      final amenity = widget.apartment.amenities[index];
                      return ListTile(
                        leading: Icon(amenity.icon, color: Colors.grey[800]),
                        title: Text(amenity.name, style: GoogleFonts.poppins()),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

    // --- NEW: LOCATION MAP SECTION ---
  Widget _buildLocationMapSection() {
    final LatLng apartmentLocation = LatLng(widget.apartment.latitude, widget.apartment.longitude);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Location',
            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0 ),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: apartmentLocation,
                  zoom: 14.0,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(widget.apartment.title),
                    position: apartmentLocation,
                  ),
                },
                scrollGesturesEnabled: false,
                zoomGesturesEnabled: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${widget.apartment.pricePerNight.toStringAsFixed(0)} CFA / night',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.apartment.discountPercentage != null)
                Text(
                  '${widget.apartment.discountPercentage}% Off',
                  style: GoogleFonts.poppins(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      BookingScreen(apartment: widget.apartment),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD9865D),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Reserve',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
