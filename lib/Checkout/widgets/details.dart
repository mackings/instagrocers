import 'package:flutter/material.dart';



class UserDetailsWidget extends StatefulWidget {
  final Function(Map<String, String>) onDetailsUpdated;

  UserDetailsWidget({required this.onDetailsUpdated});

  @override
  _UserDetailsWidgetState createState() => _UserDetailsWidgetState();
}

class _UserDetailsWidgetState extends State<UserDetailsWidget> {
  String selectedDelivery = "Priority";

  // Controllers for editable fields
  TextEditingController nameController = TextEditingController(text: "John Doe");
  TextEditingController phoneController = TextEditingController(text: "+441234567890");
  TextEditingController addressController = TextEditingController(text: "Apartment 609, 61 Harper Drive");

  void _updateDetails() {
    widget.onDetailsUpdated({
      "name": nameController.text,
      "phone": phoneController.text,
      "address": addressController.text,
      "delivery": selectedDelivery,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Details"),
          _buildCard([
            _buildEditableListTile(Icons.person, nameController),
            const Divider(),
            _buildEditableListTile(Icons.phone, phoneController),
          ]),
          const SizedBox(height: 16),
          _buildSectionTitle("Address"),
          _buildCard([
            _buildEditableListTile(Icons.location_on, addressController),
          ]),
          const SizedBox(height: 16),
          _buildSectionTitle("Delivery"),
          _buildCard([
            _buildRadioTile("Priority (10 - 20 mins)", "Priority"),
            const Divider(),
            _buildRadioTile("Standard (30 - 45 mins)", "Standard"),
            const Divider(),
            _buildListTile(Icons.schedule, "Schedule"),
          ]),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Editable ListTile
  Widget _buildEditableListTile(IconData icon, TextEditingController controller) {
    return GestureDetector(
      onTap: () => _showEditModalSheet(controller),
      child: ListTile(
        leading: Icon(icon, color: Colors.black54),
        title: Text(controller.text, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.edit, size: 18, color: Colors.grey),
      ),
    );
  }

  // Show Edit Modal
  void _showEditModalSheet(TextEditingController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(hintText: "Enter new value", border: InputBorder.none),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                  onPressed: () {
                    setState(() {}); // Refresh UI
                    _updateDetails(); // Notify parent widget
                    Navigator.pop(context);
                  },
                  child: Text("Save", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // Delivery Option with Radio Button
  Widget _buildRadioTile(String title, String value) {
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: selectedDelivery,
      onChanged: (String? newValue) {
        setState(() {
          selectedDelivery = newValue!;
        });
        _updateDetails();
      },
      activeColor: Colors.orange,
    );
  }

  // Section Title
  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
  }

  // Card Container
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

  Widget _buildListTile(IconData icon, String title, {String? subtitle}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.grey)) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }
}
