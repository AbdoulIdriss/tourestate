import 'package:estate/models/property.dart';
import 'package:estate/providers/favorites_provider.dart';
import 'package:estate/screens/pages/estate_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EstateCards extends StatelessWidget {

  final Property property;

  const EstateCards({
    super.key,
    required this.property
  });

@override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(property);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EstateDetail(property: property),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    property.imageUrls.first,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                
                // Property type and listing type badges
                Positioned(
                  top: 12,
                  left: 12,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: property.listingType == ListingType.rent 
                              ? Colors.green[600]
                              : Colors.blue[600],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          property.listingType == ListingType.rent ? 'RENT' : 'SALE',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          property.propertyTypeDisplay.toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Favorite button
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => favoritesProvider.toggleFavorite(property),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ),
                ),

                // Virtual tour indicator
                if (property.hasVirtualTour)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.purple[600],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.threesixty,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '360° TOUR',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Discount badge
                if (property.discountPercentage != null)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red[600],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${property.discountPercentage}% OFF',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child:                         Text(
                          property.title,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        property.priceDisplay,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD9865D),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.location,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Property details
                  Row(
                    children: [
                      if (property.propertyType != PropertyType.office) ...[
                        _buildDetailChip(Icons.bed_outlined, '${property.beds}'),
                        const SizedBox(width: 8),
                      ],
                      _buildDetailChip(Icons.bathtub_outlined, '${property.baths}'),
                      const SizedBox(width: 8),
                      _buildDetailChip(Icons.square_foot_outlined, '${property.area}m²'),
                      if (property.floors != null) ...[
                        const SizedBox(width: 8),
                        _buildDetailChip(Icons.layers_outlined, '${property.floors}F'),
                      ],
                      const Spacer(),
                      // Rating
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${property.rating}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Additional info row
                  Row(
                    children: [
                      // Owner name
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                property.ownerName,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Additional property features
                      if (property.furnished != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: property.furnished! 
                                ? Colors.green[100] 
                                : Colors.orange[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            property.furnished! ? 'Furnished' : 'Unfurnished',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: property.furnished! 
                                  ? Colors.green[700] 
                                  : Colors.orange[700],
                            ),
                          ),
                        ),
                      ],
                      
                      if (property.hasGarage) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Garage',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
