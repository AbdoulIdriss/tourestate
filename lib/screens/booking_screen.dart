import 'package:estate/models/property.dart';
import 'package:estate/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final Property property;

  const BookingScreen({super.key, required this.property});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // State variables for dates and guests
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime _focusedDay = DateTime.now();
  int _adults = 1;
  int _children = 0;
  int _infants = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Your Stay', style: GoogleFonts.poppins()),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildpropertySummary(),
            const SizedBox(height: 24),
            _buildGuestSummary(),
            const SizedBox(height: 24),
            _buildDateSelection(), // <-- REPLACES THE CALENDAR
            const SizedBox(height: 24),
            _buildPriceSummary(), // <-- RENAMED for clarity
          ],
        ),
      ),
      bottomNavigationBar: _buildProceedButton(),
    );
  }

  Widget _buildpropertySummary() {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                widget.property.imageUrls.first,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.property.title,
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hosted by ${widget.property.ownerName}',
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestSummary() {
    final totalGuests = _adults + _children;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Guests',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey[300]!)
          ),
          title: Text('$totalGuests Guest${totalGuests > 1 ? 's' : ''}${_infants > 0 ? ', $_infants Infant${_infants > 1 ? 's' : ''}' : ''}',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          trailing: const Icon(Icons.keyboard_arrow_down),
          onTap: _showGuestSelectionModal,
        )
      ],
    );
  }

  void _showGuestSelectionModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildGuestCounter(
                    'Adults', 'Ages 13 or above', _adults,
                    (newCount) => modalSetState(() => _adults = newCount),
                    min: 1
                  ),
                  _buildGuestCounter(
                    'Children', 'Ages 2-12', _children,
                    (newCount) => modalSetState(() => _children = newCount)
                  ),
                  _buildGuestCounter(
                    'Infants', 'Under 2', _infants,
                    (newCount) => modalSetState(() => _infants = newCount)
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Done'),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            );
          },
        );
      },
    ).then((_) => setState(() {}));
  }

  Widget _buildGuestCounter(String title, String subtitle, int count, Function(int) onCountChanged, {int min = 0}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              Text(subtitle, style: GoogleFonts.poppins(color: Colors.grey)),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: count > min ? () => onCountChanged(count - 1) : null,
              ),
              Text('$count', style: GoogleFonts.poppins(fontSize: 16)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => onCountChanged(count + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- NEW: Date selection UI that triggers a modal ---
  Widget _buildDateSelection() {
    final formatter = DateFormat('MMM d, yyyy');
    final String checkIn = _rangeStart != null ? formatter.format(_rangeStart!) : 'Check-in';
    final String checkOut = _rangeEnd != null ? formatter.format(_rangeEnd!) : 'Check-out';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Dates',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey[300]!)
          ),
          leading: const Icon(Icons.calendar_today_outlined),
          title: Text('$checkIn  -  $checkOut',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          trailing: const Icon(Icons.keyboard_arrow_down),
          onTap: _showDateSelectionModal,
        )
      ],
    );
  }

  // --- NEW: Method to show the calendar in a modal sheet ---
  void _showDateSelectionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Select Dates', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(),
                  Expanded(
                    child: TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      focusedDay: _focusedDay,
                      rangeStartDay: _rangeStart,
                      rangeEndDay: _rangeEnd,
                      calendarFormat: CalendarFormat.month,
                      rangeSelectionMode: RangeSelectionMode.toggledOn,
                      headerStyle: HeaderStyle(
                        titleCentered: true,
                        titleTextStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        formatButtonVisible: false,
                      ),
                      calendarStyle: CalendarStyle(
                        rangeHighlightColor: const Color(0xFFF5EFEF),
                        rangeStartDecoration: const BoxDecoration(color: Color(0xFFD9865D), shape: BoxShape.circle),
                        rangeEndDecoration: const BoxDecoration(color: Color(0xFFD9865D), shape: BoxShape.circle),
                        todayDecoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
                        selectedDecoration: const BoxDecoration(color: Color(0xFFC07F5A), shape: BoxShape.circle),
                      ),
                      onRangeSelected: (start, end, focusedDay) {
                        // Use modalSetState to update the UI inside the modal
                        modalSetState(() {
                          _rangeStart = start;
                          _rangeEnd = end;
                          _focusedDay = focusedDay;
                        });
                      },
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                    child: const Text('Done'),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            );
          },
        );
      },
    ).then((_) => setState(() {})); // Update the main screen after the modal closes
  }

  Widget _buildPriceSummary() {
    if (_rangeStart == null || _rangeEnd == null) {
      return const SizedBox.shrink(); // Return empty space if no date range is selected
    }
    
    final numberOfNights = _rangeEnd!.difference(_rangeStart!).inDays;
    if (numberOfNights <= 0) return const SizedBox.shrink();

    final totalPrice = numberOfNights * widget.property.price;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking Summary',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildSummaryRow(
          '${widget.property.price.toStringAsFixed(0)} CFA x $numberOfNights night${numberOfNights > 1 ? 's' : ''}',
          '${totalPrice.toStringAsFixed(0)} CFA'
        ),
        const Divider(height: 24),
        _buildSummaryRow(
          'Total:', 
          '${totalPrice.toStringAsFixed(0)} CFA',
          isTotal: true
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.poppins(color: Colors.grey[700])),
          Text(value, style: GoogleFonts.poppins(fontWeight: isTotal ? FontWeight.bold : FontWeight.w600, fontSize: isTotal ? 18 : 16)),
        ],
      ),
    );
  }
  
  Widget _buildProceedButton() {
    final bool canProceed = _rangeStart != null && _rangeEnd != null;
    final int numberOfNights = canProceed ? _rangeEnd!.difference(_rangeStart!).inDays : 0;
    final double totalPrice = numberOfNights * widget.property.price;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: ElevatedButton(
        onPressed: canProceed ? () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PaymentScreen(
                property: widget.property,
                totalPrice: totalPrice,
                numberOfNights: numberOfNights,
                checkInDate: _rangeStart!,
                checkOutDate: _rangeEnd!,
              ),
            ),
          );
        } : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9865D),
          disabledBackgroundColor: Colors.grey[300],
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Proceed to Payment',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16
          ),
        ),
      ),
    );
  }
}