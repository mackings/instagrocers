import 'package:flutter/material.dart';


class UserDetailsWidget extends StatefulWidget {
  @override
  _UserDetailsWidgetState createState() => _UserDetailsWidgetState();
}

class _UserDetailsWidgetState extends State<UserDetailsWidget> {
  String selectedDelivery = "Priority";
  bool requestInvoice = false; 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Details Section
          _buildSectionTitle("Details"),
          _buildCard([
            _buildListTile(Icons.person, "John Doe"),
            const Divider(),
            _buildListTile(Icons.phone, "+441234567890"),
          ]),

          const SizedBox(height: 16),

          // Address Section
          _buildSectionTitle("Address"),
          _buildCard([
            _buildListTile(
              Icons.location_on,
              "Apartment 609",
              subtitle: "61, Harper Drive...",
            ),
          ]),

          const SizedBox(height: 16),

          // Delivery Section
          _buildSectionTitle("Delivery"),
          _buildCard([
            _buildRadioTile("Priority (10 - 20 mins)", "Priority"),
            const Divider(),
            _buildRadioTile("Standard (30 - 45 mins)", "Standard"),
            const Divider(),
            _buildListTile(Icons.schedule, "Schedule"),
          ]),

          const SizedBox(height: 16),
          // Request Invoice
          _buildCard([
            SwitchListTile(
              title: const Text("Request an invoice"),
              value: requestInvoice,
              onChanged: (value) {
                setState(() {
                  requestInvoice = value;
                });
              },
            ),
          ]),

          const SizedBox(height: 16),

          // Payment Method Section
          _buildSectionTitle("Payment method"),
          _buildCard([
            _buildListTile(Icons.payment, "Apple Pay", isPayIcon: true),
          ]),
        ],
      ),
    );
  }

  // Section Title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  // Custom Card Container
Widget _buildCard(List<Widget> children) {

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8), 
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column(children: children),
  );
}


  // ListTile with Icon
  Widget _buildListTile(IconData icon, String title, {String? subtitle, bool isPayIcon = false}) {
    return ListTile(
      leading: isPayIcon
          ? Icon(Icons.credit_card) // Use an Apple Pay icon
          : Icon(icon, color: Colors.black54),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.grey)) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }

  // Radio Button ListTile for Delivery Options
  Widget _buildRadioTile(String title, String value) {
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: selectedDelivery,
      onChanged: (String? newValue) {
        setState(() {
          selectedDelivery = newValue!;
        });
      },
      activeColor: Colors.orange,
    );
  }

  // Price Row with Label & Amount
  Widget _buildPriceRow(String label, String amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
