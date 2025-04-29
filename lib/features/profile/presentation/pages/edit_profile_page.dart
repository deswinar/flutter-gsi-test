import 'package:flutter/material.dart';
import 'package:keanggotaan/shared/widgets/atoms/primary_button.dart';
import 'package:keanggotaan/shared/widgets/atoms/input_field.dart';
import 'package:keanggotaan/shared/widgets/atoms/dropdown_field.dart';
import 'package:keanggotaan/shared/widgets/atoms/identity_photo_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController =
      TextEditingController(text: 'Ahmad Fadli');
  final TextEditingController _identityNumberController =
      TextEditingController(text: '1234567890');
  final TextEditingController _addressController =
      TextEditingController(text: 'Jl. Merdeka No. 10');
  final TextEditingController _emailController =
      TextEditingController(text: 'ahmad.fadli@example.com');
  final TextEditingController _phoneController =
      TextEditingController(text: '+62 812 3456 7890');

  String _selectedGender = 'Laki-laki';
  String? _identityPhoto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFF40916C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InputField(
                label: 'Full Name',
                controller: _fullNameController,
                icon: Icons.person,
              ),
              DropdownField(
                label: 'Gender',
                icon: Icons.wc,
                value: _selectedGender,
                items: const ['Laki-laki', 'Perempuan'],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                validator: (value) {
                  // Check if value is null or empty
                  if (value == null || value.isEmpty) {
                    return 'Field Gender cannot be empty'; // Return a string message if invalid
                  }
                  return 'null'; // Return null when the input is valid
                },
              ),

              InputField(
                label: 'Identity Number',
                controller: _identityNumberController,
                icon: Icons.credit_card,
                keyboardType: TextInputType.number,
              ),
              InputField(
                label: 'Address',
                controller: _addressController,
                icon: Icons.home,
                keyboardType: TextInputType.text,
              ),
              InputField(
                label: 'Email',
                controller: _emailController,
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              InputField(
                label: 'Phone Number',
                controller: _phoneController,
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              IdentityPhotoPicker(
                photo: _identityPhoto,
                onPick: () {
                  // Implement photo picker logic here
                },
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Save Changes',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile saved successfully')),
                    );
                    Navigator.pop(context); // Navigate back to the previous page
                  }
                },
                isLoading: false, // You can set this to true to show a loading indicator
              ),
            ],
          ),
        ),
      ),
    );
  }
}
