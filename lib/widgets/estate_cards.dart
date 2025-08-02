import 'package:estate/models/appartment.dart';
import 'package:estate/screens/pages/estate_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EstateCards extends StatelessWidget {

  final Apartment apartment;

  const EstateCards({
    super.key,
    required this.apartment
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EstateDetail(apartment: apartment)
          )
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 5),
        child: Card(
          elevation: 4,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: apartment.imageUrls.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      apartment.imageUrls[index],
                      width: double.infinity,
                      fit: BoxFit.cover,
      
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child; //image is loaded
                        return Container(
                          height: 200,
                          width: double.infinity, 
                          color: Colors.grey[200],
                          child: const Center(child: CircularProgressIndicator() ) ,
                        );
                      },
      
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          width: double.infinity, 
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey[400],
                            size: 48,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
      
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- UPDATED LAYOUT ---
                    // Title and Location are now in their own Column
                    Text(
                      apartment.title,
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      apartment.location,
                      style: GoogleFonts.poppins(fontSize: 16, color: const Color.fromARGB(255, 104, 103, 103)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    // Row now contains the facility icons and the price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // A Row to group the icons together
                        Row(
                          children: [
                            _buildIconText(icon: Icons.bed_outlined, text: '${apartment.beds} Beds'),
                            const SizedBox(width: 16),
                            _buildIconText(
                              icon: Icons.bathtub_outlined,
                              text: '${apartment.baths} Baths',
                            ),
                            const SizedBox(width: 16),
                            _buildIconText(
                              icon: Icons.square_foot_outlined,
                              text: '${apartment.area} m²',
                            ),
                          ],
                        ),
                        // Price Widget is now here
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${apartment.pricePerNight.toStringAsFixed(0)}',
                                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              TextSpan(
                                text: ' CFA',
                                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    // --- END OF UPDATED LAYOUT ---
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to reduce repetition for the icon-text rows
  Widget _buildIconText({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueGrey, size: 20),
        const SizedBox(width: 8),
        Text(text, style: GoogleFonts.poppins(fontSize: 12)), // Reduced font size to fit
      ],
    );
  }
}
