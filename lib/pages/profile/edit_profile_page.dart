import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/pages/auth/providers/auth_provider.dart';
import 'package:habit_tracker/providers/theme_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  File? _selectedImage;
  bool _useDefaultIcon = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    nameController = TextEditingController(text: auth.name);

    if (auth.profileImagePath != null && auth.profileImagePath!.isNotEmpty) {
      _selectedImage = File(auth.profileImagePath!);
    }
    _useDefaultIcon = auth.useDefaultIcon;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  // Fungsi memilih gambar dari galeri
  Future<void> _pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _useDefaultIcon = false;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  // Bottom Sheet Pilihan Foto Profil yang Rapi & Bertahap ke Bawah
  void _showImageOptionsBottomSheet(dynamic theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Garis handle kecil di atas
              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.textColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 17),
              Text(
                "Ubah Foto Profil",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textColor,
                ),
              ),
              const SizedBox(height: 20),

              // Opsi 1: Galeri
              _buildBottomSheetOption(
                icon: Icons.photo_library_outlined,
                title: "Pilih dari Galeri",
                theme: theme,
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImageFromGallery();
                },
              ),
              const SizedBox(height: 12),

              // Opsi 2: Icon Person
              _buildBottomSheetOption(
                icon: Icons.person_outline_rounded,
                title: "Gunakan Icon Person",
                theme: theme,
                onTap: () {
                  setState(() {
                    _selectedImage = null;
                    _useDefaultIcon = true;
                  });
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 12),

              // Opsi 3: Hapus Foto
              _buildBottomSheetOption(
                icon: Icons.delete_outline_rounded,
                title: "Hapus Foto",
                isDestructive: true,
                theme: theme,
                onTap: () {
                  setState(() {
                    _selectedImage = null;
                    _useDefaultIcon = false;
                  });
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetOption({
    required IconData icon,
    required String title,
    required dynamic theme,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.redAccent : theme.primaryColor,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: isDestructive ? Colors.redAccent : theme.textColor,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: theme.textColor.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: theme.primaryColor),
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.textColor),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // =========================
              // AVATAR PREVIEW DENGAN TOMBOL KAMERA
              // =========================
              Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: _buildAvatarDisplay(auth, theme),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _showImageOptionsBottomSheet(theme),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.cardColor,
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // =========================
              // CARD FORM EDIT NAMA
              // =========================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Informasi Akun",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      style: GoogleFonts.poppins(
                        color: theme.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        labelText: "Username",
                        labelStyle: TextStyle(
                          color: theme.textColor.withOpacity(0.6),
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                          color: theme.primaryColor,
                        ),
                        filled: true,
                        fillColor: theme.backgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.primaryColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // =========================
              // TOMBOL SIMPAN
              // =========================
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () async {
                    final newName = nameController.text.trim();
                    if (newName.isNotEmpty) {
                      await auth.updateUser(
                        name: newName,
                        email: auth.email,
                      );
                    }

                    // Simpan status foto profil atau icon person secara permanen
                    await auth.updateProfileImage(
                      path: _selectedImage?.path,
                      defaultIcon: _useDefaultIcon,
                    );

                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Simpan Perubahan",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Tampilan Avatar Dinamis
  Widget _buildAvatarDisplay(AuthProvider auth, dynamic theme) {
    if (_selectedImage != null) {
      return CircleAvatar(
        radius: 56,
        backgroundImage: FileImage(_selectedImage!),
      );
    } else if (_useDefaultIcon) {
      return CircleAvatar(
        radius: 56,
        backgroundColor: theme.softColor,
        child: Icon(
          Icons.person_rounded,
          size: 55,
          color: theme.primaryColor,
        ),
      );
    } else {
      final nameText = nameController.text.trim();
      final initial = nameText.isNotEmpty ? nameText[0].toUpperCase() : "U";
      return CircleAvatar(
        radius: 56,
        backgroundColor: theme.softColor,
        child: Text(
          initial,
          style: GoogleFonts.poppins(
            fontSize: 44,
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
      );
    }
  }
}
