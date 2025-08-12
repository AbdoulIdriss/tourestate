import 'package:estate/models/property.dart';
import 'package:estate/providers/favorites_provider.dart';
import 'package:estate/screens/booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EstateDetail extends StatefulWidget {
  final Property property;

  const EstateDetail({super.key, required this.property});

  @override
  State<EstateDetail> createState() => _EstateDetailState();
}

class _EstateDetailState extends State<EstateDetail> {
  int _currentImageIndex = 0;
  GoogleMapController? _mapController;

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
                  _buildPropertyDetailsSection(),
                  _buildAboutSection(),
                  if (widget.property.hasVirtualTour)
                    _buildVirtualTourSection(),
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
    final isFav = favoritesProvider.isFavorite(widget.property);

    return Stack(
      children: [
        SizedBox(
          height: 400,
          child: PageView.builder(
            itemCount: widget.property.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                widget.property.imageUrls[index],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
                cacheWidth: 800, // Limit image resolution
                cacheHeight: 600,
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
                icon: isFav ? Icons.bookmark : Icons.bookmark_border,
                onPressed: () {
                  favoritesProvider.toggleFavorite(widget.property);
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
              '${_currentImageIndex + 1} / ${widget.property.imageUrls.length}',
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.property.listingType == ListingType.rent
                      ? Colors.green[100]
                      : Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.property.listingTypeDisplay,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: widget.property.listingType == ListingType.rent
                        ? Colors.green[700]
                        : Colors.blue[700],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.property.propertyTypeDisplay,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.property.title,
            style: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.property.location,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                '${widget.property.rating}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              Text(
                ' (${widget.property.reviewCount} reviews)',
                style: GoogleFonts.poppins(color: Colors.grey[600]),
              ),
              const Text('  ·  '),
              Icon(Icons.person_outline, size: 18, color: Colors.grey[700]),
              const SizedBox(width: 4),
              Text(
                widget.property.ownerName,
                style: GoogleFonts.poppins(color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyDetailsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Property Details',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (widget.property.propertyType != PropertyType.office) ...[
                _buildDetailItem(
                  Icons.bed_outlined,
                  '${widget.property.beds} Beds',
                ),
                const SizedBox(width: 20),
              ],
              _buildDetailItem(
                Icons.bathtub_outlined,
                '${widget.property.baths} Baths',
              ),
              const SizedBox(width: 20),
              _buildDetailItem(
                Icons.square_foot_outlined,
                '${widget.property.area} m²',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (widget.property.floors != null) ...[
                _buildDetailItem(
                  Icons.layers_outlined,
                  '${widget.property.floors} Floor${widget.property.floors! > 1 ? 's' : ''}',
                ),
                const SizedBox(width: 20),
              ],
              if (widget.property.furnished != null) ...[
                _buildDetailItem(
                  widget.property.furnished!
                      ? Icons.chair_outlined
                      : Icons.chair_alt_outlined,
                  widget.property.furnished! ? 'Furnished' : 'Unfurnished',
                ),
                const SizedBox(width: 20),
              ],
              if (widget.property.hasGarage) ...[
                _buildDetailItem(Icons.garage_outlined, 'Garage'),
              ],
            ],
          ),
          if (widget.property.parkingSpots != null) ...[
            const SizedBox(height: 8),
            _buildDetailItem(
              Icons.local_parking_outlined,
              widget.property.parkingSpots!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    List<String> words = widget.property.description.split(' ');
    bool showReadMore = words.length > 16;
    String displayedDescription = '';

    if (showReadMore) {
      displayedDescription = words.take(16).join(' ') + '...';
    } else {
      displayedDescription = widget.property.description;
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
              fontWeight: FontWeight.w600,
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
          ),
          if (showReadMore)
            GestureDetector(
              onTap: () => _showFullDescriptionSheet(
                context,
                widget.property.description,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Read more',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVirtualTourSection() {
    // Check if virtual tour is actually available
    if (!widget.property.hasVirtualTour) {
      return const SizedBox.shrink(); 
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '360° Virtual Tour',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[400]!, Colors.purple[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _launchVirtualTour(),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.threesixty,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Take Virtual Tour',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Explore in 360°',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.9),
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
    );
  }

  void _launchVirtualTour() async {
    try {
      // Check if virtual tour URL exists and is not empty
      final virtualTourUrl = widget.property.virtualTourUrl;

      if (virtualTourUrl == null || virtualTourUrl.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Virtual tour is not available for this property'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Validate URL format
      Uri? url;
      try {
        url = Uri.parse(virtualTourUrl);
        // Check if URL has a valid scheme
        if (!url.hasScheme) {
          url = Uri.parse('https://$virtualTourUrl');
        }
      } catch (e) {
        debugPrint('URL parsing error: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid virtual tour URL'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Check if URL can be launched
      bool canLaunch = false;
      try {
        canLaunch = await canLaunchUrl(url);
      } catch (e) {
        debugPrint('canLaunchUrl error: $e');
        canLaunch = false;
      }

      if (canLaunch) {
        // Try to launch the URL
        try {
          await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
            webOnlyWindowName: '_blank',
          );
        } catch (e) {
          debugPrint('launchUrl error: $e');
          // Fallback to in-app browser
          try {
            await launchUrl(url, mode: LaunchMode.inAppWebView);
          } catch (fallbackError) {
            debugPrint('Fallback launchUrl error: $fallbackError');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Unable to open virtual tour'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }
      } else {
        debugPrint('Cannot launch URL: $virtualTourUrl');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cannot open virtual tour: ${url.toString()}'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Copy URL',
                onPressed: () {
                  // You can add clipboard functionality here if needed
                  // Clipboard.setData(ClipboardData(text: url.toString()));
                },
              ),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Virtual tour launch error: $e');
      debugPrint('Stack trace: $stackTrace');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'An unexpected error occurred while opening virtual tour',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showFullDescriptionSheet(BuildContext context, String description) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: 0.9,
          minChildSize: 0.3,
          builder: (BuildContext context, ScrollController scrollController) {
            return Column(
              children: [
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
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
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

  Widget _buildAmenitiesSection() {
    final amenitiesPreview = widget.property.amenities.take(6).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amenities',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4.0,
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
                  Expanded(
                    child: Text(
                      amenity.name,
                      style: GoogleFonts.poppins(fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          if (widget.property.amenities.length > 6)
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _showAllAmenities,
              child: Text(
                'Show all ${widget.property.amenities.length} amenities',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  void _showAllAmenities() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: 0.9,
          minChildSize: 0.3,
          builder: (BuildContext context, ScrollController scrollController) {
            return Column(
              children: [
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
                    itemCount: widget.property.amenities.length,
                    itemBuilder: (context, index) {
                      final amenity = widget.property.amenities[index];
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

  Widget _buildLocationMapSection() {
    final LatLng propertyLocation = LatLng(
      widget.property.latitude,
      widget.property.longitude,
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: propertyLocation,
                  zoom: 15.0,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(widget.property.id),
                    position: propertyLocation,
                    infoWindow: InfoWindow(
                      title: widget.property.title,
                      snippet: widget.property.location,
                    ),
                  ),
                },
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                zoomControlsEnabled: true,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.property.location,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
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
                widget.property.priceDisplay,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.property.discountPercentage != null)
                Text(
                  '${widget.property.discountPercentage}% Off',
                  style: GoogleFonts.poppins(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (widget.property.listingType == ListingType.rent) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        BookingScreen(property: widget.property),
                  ),
                );
              } else {
                _showContactOwnerDialog();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD9865D),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              widget.property.listingType == ListingType.rent
                  ? 'Reserve'
                  : 'Contact Owner',
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

  void _showContactOwnerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Contact Owner',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Interested in purchasing this ${widget.property.propertyTypeDisplay.toLowerCase()}?',
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 12),
              Text(
                'Owner: ${widget.property.ownerName}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              Text(
                'Price: ${widget.property.priceDisplay}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: GoogleFonts.poppins()),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Contact information sent to your email'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD9865D),
              ),
              child: Text(
                'Contact',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
