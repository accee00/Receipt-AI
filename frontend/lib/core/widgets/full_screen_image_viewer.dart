import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showFullImage(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (_) => Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              panEnabled: true,
              scaleEnabled: true,
              minScale: 1.0,
              maxScale: 8.0,
              boundaryMargin: const EdgeInsets.all(double.infinity),
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
          ),
          SafeArea(
            child: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
          ),
        ],
      ),
    ),
  );
}
