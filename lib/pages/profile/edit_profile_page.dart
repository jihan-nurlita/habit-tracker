import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();

    final auth = context.read<AuthProvider>();

    nameController = TextEditingController(
      text: auth.name,
    );

    emailController = TextEditingController(
      text: auth.email,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nama",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await context.read<AuthProvider>().login(
                        name: nameController.text,
                        email: emailController.text,
                      );

                  Navigator.pop(
                    context,
                  );
                },
                child: const Text(
                  "Simpan",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
