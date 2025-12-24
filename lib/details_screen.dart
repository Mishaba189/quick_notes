import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final TextEditingController username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final details = Provider.of<AuthProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: username,
              decoration: const InputDecoration(
                labelText: 'Enter username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await details.fetchByName(username.text.toLowerCase());
                if (details.userData == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User not found')),
                  );
                }
              },
              child: const Text('Fetch'),
            ),
            const SizedBox(height: 24),
            Consumer<AuthProvider>(
              builder: (context,details,child) {
                final user = details.userData;
                if (user == null) {
                  return const Text('No user data');
                }
                return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${user['name']}',
                            style: const TextStyle(fontSize: 20)
                        ),
                        const SizedBox(height: 16),
                        Text('Email: ${user['email']}',
                            style: const TextStyle(fontSize: 20)),
                        const SizedBox(height: 16),
                        Text('Created At: ${user['cereatedAt'].toDate()}',
                            style: const TextStyle(fontSize: 20)),
                      ],
                    );
              }
            )
          ],
        ),
      ),
    );
  }
}

