
import 'package:estate/models/appartment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_payunit/flutter_payunit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
 

class PaymentScreen extends StatefulWidget {
  final Apartment apartment;
  final int totalPrice;
  final int numberOfNights;
  final DateTime checkInDate;
  final DateTime checkOutDate;

  const PaymentScreen({
    super.key,
    required this.apartment,
    required this.totalPrice,
    required this.numberOfNights,
    required this.checkInDate,
    required this.checkOutDate,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

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
            Text('Ready to Pay?', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Click the button below to proceed. You will be prompted to select a payment method (MTN, Orange, VISA).',
              style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 15),
            ),
          ],
        ),
      ),
      // --- The PayUnitButton is now here ---
      bottomNavigationBar: _buildBottomPayButton(),
    );
  }

  Widget _buildBookingDetails() {
    final formatter = DateFormat('MMM d, yyyy');
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.apartment.title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
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
                Text('Total (${widget.numberOfNights} nights)', style: GoogleFonts.poppins()),
                Text(
                  '${widget.totalPrice.toStringAsFixed(0)} CFA',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- This method now returns the PayUnitButton wrapped in padding ---
  Widget _buildBottomPayButton() {
    return Padding(
      // Add padding to avoid the button touching the screen edges
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: PayUnitButton(
        // --- IMPORTANT: Replace with your actual PayUnit credentials ---
        apiUsername: '75d5e495-be7f-4155-b1e4-aeea2f3904eb', 
        apiPassword: '5c19e287-f828-4279-ad6c-784ba53c7fa9', 
        apiKey: 'sand_dhpF3amYmAggEAPCtwaOycyzSJC1bT',

        // --- Transaction Details ---
        totalAmount: widget.totalPrice, // Convert int to double
        
        // --- SDK Configuration ---
        mode: 'test', // Use 'live' for production
        currency: 'XAF', 
        paymentCountry: 'CM',

        // --- IMPORTANT: Replace with your actual URLs ---
        returnUrl: 'https://webhook.site/d457b2f3-dd71-4f04-9af5-e2fcf3be8f34', 
        notifyUrl: 'https://webhook.site/d457b2f3-dd71-4f04-9af5-e2fcf3be8f34',

        // --- Callback after payment process ---
        actionAfterProccess: (transactionId , transactionStatus , phoneNumber) {
          print("Transaction id is : $transactionId and transaction status : $transactionStatus");

          if(transactionStatus.toUpperCase() == "SUCCESS") {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //     content: Text('Payment Successful!'),
            //     backgroundColor: Colors.green,
            //   )
            // );
            print('The transaction $transactionId is Successful');
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