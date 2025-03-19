import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _auth = FirebaseAuth.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    User? user = _auth.currentUser;
    nameController.text = user?.displayName ?? "";
    phoneController.text = user?.phoneNumber ?? "";
  }

  void _updateUserProfile() async {
    User? user = _auth.currentUser;

    try {
      await user?.updateDisplayName(nameController.text);
      await user?.reload();
      setState(() => isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile updated successfully"), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing) {
                _updateUserProfile();
              } else {
                setState(() => isEditing = true);
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 📸 Profile Picture
              CircleAvatar(
                radius: 50,
                backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                backgroundColor: Colors.green.shade800,
                child: user?.photoURL == null ? Icon(Icons.person, size: 60, color: Colors.white) : null,
              ),

              SizedBox(height: 15),

              // 🏷 Editable Name Field
              TextFormField(
                controller: nameController,
                enabled: isEditing,
                decoration: InputDecoration(
                  labelText: "Name",
                  prefixIcon: Icon(Icons.person, color: Colors.green.shade700),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),

              SizedBox(height: 15),

              // 📩 Email (Non-editable)
              TextFormField(
                initialValue: user?.email ?? "N/A",
                enabled: false,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email, color: Colors.green.shade700),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),

              SizedBox(height: 15),

              // 📞 Editable Phone Number
              TextFormField(
                controller: phoneController,
                enabled: isEditing,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  prefixIcon: Icon(Icons.phone, color: Colors.green.shade700),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),

              SizedBox(height: 20),

              // 🔴 Logout Button
              ElevatedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context); // Go back after logout
                },
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
