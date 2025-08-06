import 'package:estate/models/reservation.dart';
import 'package:estate/screens/auth_screen.dart'; // Make sure you have this import
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  // --- MOCK DATA for Reservations ---
  // Replace this with a real fetch from Firestore in a FutureBuilder or StreamBuilder
  final List<Reservation> _mockReservations = [
    Reservation(
      reservationId: 'trans_12345',
      userId: 'mock_user_id',
      apartmentTitle: 'Modern Family House',
      apartmentLocation: 'Bonamoussadi, Douala',
      apartmentImageUrl: 'https://i.pinimg.com/736x/d4/7b/e2/d47be28251f9931b33fb37816bc32143.jpg',
      checkInDate: DateTime.now().add(const Duration(days: 10)),
      checkOutDate: DateTime.now().add(const Duration(days: 15)),
      amountPaid: 80,
      totalPrice: 400,
      paymentStatus: 'Partial Payment',
      reservationDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Reservation(
      reservationId: 'trans_67890',
      userId: 'mock_user_id',
      apartmentTitle: 'Luxury Beachside Villa',
      apartmentLocation: 'Kribi, South Region',
      apartmentImageUrl: 'https://i.pinimg.com/736x/ba/e4/a4/bae4a4ba046305ff112d4872374ca751.jpg',
      checkInDate: DateTime.now().subtract(const Duration(days: 20)),
      checkOutDate: DateTime.now().subtract(const Duration(days: 15)),
      amountPaid: 750,
      totalPrice: 750,
      paymentStatus: 'Paid in Full',
      reservationDate: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('My Profile', style: GoogleFonts.poppins()),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        children: [
          _buildUserInfoCard(),
          _buildReservationsSection(),
          _buildSettingsCard(), // <-- MOVED TO THE END
        ],
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Color(0xFFD9865D),
              child: Icon(Icons.person, size: 30, color: Colors.white),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentUser?.displayName ?? 'Real Estate User',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentUser?.email ?? 'No email found',
                  style: GoogleFonts.poppins(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text('Settings', style: GoogleFonts.poppins()),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to a dedicated SettingsScreen
              print('Settings tapped');
            },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text('Logout', style: GoogleFonts.poppins(color: Colors.red)),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              // Navigate to the AuthScreen and remove all previous routes
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const AuthScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReservationsSection() {
    // TODO: Replace '_mockReservations' with a real data stream from Firestore
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Reservations',
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (_mockReservations.isEmpty)
            const Text('You have no reservations yet.')
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _mockReservations.length,
              itemBuilder: (context, index) {
                return _buildReservationCard(_mockReservations[index]);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildReservationCard(Reservation reservation) {
    final formatter = DateFormat('MMM d, yyyy');
    final bool isUpcoming = reservation.checkInDate.isAfter(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    reservation.apartmentImageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation.apartmentTitle,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${formatter.format(reservation.checkInDate)} - ${formatter.format(reservation.checkOutDate)}',
                        style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isUpcoming ? Colors.blue.shade100 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isUpcoming ? 'Upcoming' : 'Completed',
                    style: GoogleFonts.poppins(
                      color: isUpcoming ? Colors.blue.shade800 : Colors.grey.shade800,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                )
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Status:', style: GoogleFonts.poppins()),
                Text(
                  reservation.paymentStatus,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Amount Paid:', style: GoogleFonts.poppins()),
                Text(
                  '${reservation.amountPaid.toStringAsFixed(0)} CFA',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
