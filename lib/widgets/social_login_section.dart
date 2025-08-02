import 'package:estate/screens/phone_auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        _buildDivider(),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using PNG image URL for Google logo
            _buildSocialButton(
              imageUrl: 'https://img.icons8.com/?size=100&id=V5cGWnc9R4xj&format=png&color=000000',
              onTap: () {
                print('Google Sign In Tapped');
                // e.g., AuthService().signInWithGoogle();
              },
            ),
            const SizedBox(width: 20),
            // Using PNG image URL for Apple logo
            _buildSocialButton(
              imageUrl: 'https://img.icons8.com/?size=100&id=30840&format=png&color=000000',
              onTap: () {
                print('Apple Sign In Tapped');
                // e.g., AuthService().signInWithApple();
              },
            ),
            const SizedBox(width: 20),
            // No change for the phone icon, it still uses iconData
            _buildSocialButton(
              iconData: Icons.phone_android,
              onTap: () {
                print('Phone Sign In Tapped');
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => PhoneAuthScreen()));
                // This would navigate to a new screen for phone auth.
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'OR',
            style: GoogleFonts.poppins(
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(child: Divider(thickness: 1)),
      ],
    );
  }

  // UPDATED: This method now handles network PNGs, SVGs, local assets, and material icons.
  Widget _buildSocialButton({
    String? imageUrl,
    String? assetPath,
    IconData? iconData,
    required VoidCallback onTap
  }) {
    // This widget will hold the correct icon/image based on the parameters
    Widget displayWidget;

    if (imageUrl != null) {
      if (imageUrl.toLowerCase().endsWith('.svg')) {
        // Use SvgPicture.network for internet SVG images
        displayWidget = SvgPicture.network(
          imageUrl,
          height: 24,
          width: 24,
          placeholderBuilder: (BuildContext context) => Container(
            padding: const EdgeInsets.all(4.0),
            child: const CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF1A2F4B)),
          ),
        );
      } else {
        // Use Image.network for other internet images (like PNG)
        displayWidget = Image.network(
          imageUrl,
          height: 24,
          width: 24,
          // Shows a loading spinner while the image is being fetched.
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: const Color(0xFF1A2F4B),
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        );
      }
    } else if (assetPath != null) {
      // Fallback to SvgPicture.asset for local files
      displayWidget = SvgPicture.asset(
        assetPath,
        height: 24,
        width: 24,
      );
    } else {
      // Default to Icon if no image path is provided
      displayWidget = Icon(
        iconData,
        size: 24,
        color: const Color(0xFF1A2F4B),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[100],
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        // FIXED: This now correctly uses the 'displayWidget' created above.
        child: displayWidget,
      ),
    );
  }
}
