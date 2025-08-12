import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estate/models/property.dart';
import 'package:estate/models/reservation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_payunit/flutter_payunit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
 

class PaymentScreen extends StatefulWidget {
  final Property property;
  final int totalPrice;
  final int numberOfNights;
  final DateTime checkInDate;
  final DateTime checkOutDate;

  const PaymentScreen({
    super.key,
    required this.property,
    required this.totalPrice,
    required this.numberOfNights,
    required this.checkInDate,
    required this.checkOutDate,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

enum PaymentOption { full, partial }

class _PaymentScreenState extends State<PaymentScreen> {
  // State to track the selected payment option
  PaymentOption _selectedOption = PaymentOption.full;

    // --- NEW METHOD: Saves reservation to Firestore ---
  Future<void> _saveReservation(double amountPaid, String transactionId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Should not happen if user is logged in

    final newReservation = Reservation(
      reservationId: transactionId, // Use the transaction ID as the reservation ID
      userId: user.uid,
      propertyTitle: widget.property.title,
      propertyLocation: widget.property.location,
      propertyImageUrl: widget.property.imageUrls.first,
      checkInDate: widget.checkInDate,
      checkOutDate: widget.checkOutDate,
      amountPaid: amountPaid,
      totalPrice: widget.totalPrice.toDouble(),
      paymentStatus: _selectedOption == PaymentOption.full ? 'Paid in Full' : 'Partial Payment',
      reservationDate: DateTime.now(),
    );

    // Save the reservation in a subcollection for the user
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('reservations')
        .doc(transactionId)
        .set(newReservation.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm and Pay', style: GoogleFonts.poppins()),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBookingDetails(),
            const SizedBox(height: 24),
            Text('Payment Options', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildPaymentOptionsBoxes(), 
            const SizedBox(height: 8),
            _buildPaymentExplanation(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomPayButton(),
    );
  }

  Widget _buildBookingDetails() {
    final formatter = DateFormat('MMM d, yyyy');
    final amountToPay = _selectedOption == PaymentOption.full ? widget.totalPrice : (widget.totalPrice / 3);
    
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.property.title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${formatter.format(widget.checkInDate)} - ${formatter.format(widget.checkOutDate)}',
                  style: GoogleFonts.poppins(),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Amount to Pay Today', style: GoogleFonts.poppins(fontSize: 16)),
                Text(
                  '${amountToPay.toStringAsFixed(0)} CFA',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- NEW: Replaces the SegmentedButton with styled boxes ---
  Widget _buildPaymentOptionsBoxes() {
    return Row(
      children: [
        _buildPaymentOptionCard(
          option: PaymentOption.full,
          title: 'Pay in Full',
          amount: '${widget.totalPrice.toStringAsFixed(0)} CFA',
        ),
        const SizedBox(width: 16),
        _buildPaymentOptionCard(
          option: PaymentOption.partial,
          title: 'Pay 1/3 Deposit',
          amount: '${(widget.totalPrice / 3).toStringAsFixed(0)} CFA',
        ),
      ],
    );
  }

    // --- NEW: Helper widget for the styled payment option boxes ---
  Widget _buildPaymentOptionCard({
    required PaymentOption option,
    required String title,
    required String amount,
  }) {
    final bool isSelected = _selectedOption == option;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedOption = option;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFD9865D).withOpacity(0.1) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFFD9865D) : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? const Color(0xFFD9865D) : Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                amount,
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentExplanation() {
    if (_selectedOption == PaymentOption.partial) {
      final remainingAmount = widget.totalPrice - (widget.totalPrice / 3);
      final dueDate = widget.checkInDate.subtract(const Duration(days: 1));
      final formatter = DateFormat('MMM d, yyyy');

      return Text(
        'The remaining balance of ${remainingAmount.toStringAsFixed(0)} CFA will be due on ${formatter.format(dueDate)} (24 hours before check-in).',
        style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14),
      );
    }
    return Text(
      'You are paying the full amount for your stay. No further payments will be required.',
      style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14),
    );
  }

  Widget _buildBottomPayButton() {
    final amountToPay = _selectedOption == PaymentOption.full ? widget.totalPrice : (widget.totalPrice / 3);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: PayUnitButton(
        apiUsername: '75d5e495-be7f-4155-b1e4-aeea2f3904eb', 
        apiPassword: '5c19e287-f828-4279-ad6c-784ba53c7fa9', 
        apiKey: 'sand_dhpF3amYmAggEAPCtwaOycyzSJC1bT',
        totalAmount: amountToPay.toInt(),
        mode: 'test',
        currency: 'XAF', 
        paymentCountry: 'CM',
        returnUrl: 'https://webhook.site/d457b2f3-dd71-4f04-9af5-e2fcf3be8f34', 
        notifyUrl: 'https://webhook.site/d457b2f3-dd71-4f04-9af5-e2fcf3be8f34',
        actionAfterProccess: (transactionId , transactionStatus , phoneNumber) {
          print("Transaction id is : $transactionId and transaction status : $transactionStatus");

          if(transactionStatus.toUpperCase() == "SUCCESS") {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //     content: Text('Payment Successful!'),
            //     backgroundColor: Colors.green,
            //   )
            // );
            _saveReservation(amountToPay.toDouble(), transactionId);
            print('The transaction $transactionId is Successful');
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //     content: Text('Payment Failed. Please try again.'),
            //     backgroundColor: Colors.red,
            //   ),
            // );
            print('The transaction $transactionId Failed');
          }
        }
      ),
    );
  }
}