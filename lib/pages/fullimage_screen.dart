import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FullScreenImage extends StatefulWidget {
  final String imageUrl;

  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  Future<void> _saveImage(String imageUrl) async {
    try {
      // 1. Fetch the image data
      final response = await http.get(Uri.parse(imageUrl));
      print(response.statusCode);
      if (response.statusCode == 200) {
        // 2. Get the Downloads directory
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          final filePath = '${directory.path}/downloaded_image.jpg';

          // 3. Save the image to the file
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          // 4. Show a success message (optional)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image saved successfully!')),
          );
        } else {
          // Handle case where Downloads directory is not available
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: Downloads directory not found.')),
          );
        }
      } else {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error downloading image: ${response.statusCode}')),
        );
      }
    } catch (e) {
      // Handle general errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Full Screen Image"),
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.contain, // Maintain aspect ratio
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () => _saveImage(widget.imageUrl),
            child: Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}
