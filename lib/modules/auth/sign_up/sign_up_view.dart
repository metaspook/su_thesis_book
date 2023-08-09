import 'package:flutter/material.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const TextField(decoration: InputDecoration(hintText: 'name...')),
        const TextField(decoration: InputDecoration(hintText: 'email...')),
        const TextField(decoration: InputDecoration(hintText: 'password...')),
        const TextField(decoration: InputDecoration(hintText: 'phone...')),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 200, width: 225, child: Card()),
            Column(
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Gallery')),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: () {}, child: const Text('Camera')),
              ],
            )
          ],
        ),
        const SizedBox(height: 30),
        // Proceed button
        ElevatedButton(onPressed: () {}, child: const Text('Proceed')),
      ],
    );
  }
}
