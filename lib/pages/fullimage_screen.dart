import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FullScreenImage extends StatefulWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  Future<void> _saveImage(String imageUrl) async {
    try {
      // 1. Fetch the image data
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // 2. Get the Downloads directory
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          final filePath = '${directory.path}/downloaded_image.jpg';

          // 3. Save the image to the file
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);
          final params = SaveFileDialogParams(sourceFilePath: file.path);
          final finalPath = await FlutterFileDialog.saveFile(params: params);

          // 4. Show a success message (optional)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image saved successfully to $finalPath')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Error: Downloads directory not found.')),
          );
        }
      } else {
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

  double _rotationAngle = 0;
  void _rotateImage() {
    setState(() {
      _rotationAngle += 90; // Rotate by 90 degrees
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Full Screen Image"),
        actions: [
          IconButton(
              onPressed: () => _saveImage(widget.imageUrl),
              icon: const Icon(
                Icons.save,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RotatedBox(
              quarterTurns: (_rotationAngle / 90).round(),
              child: Center(
                child: InteractiveViewer(
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.contain, // Maintain aspect ratio
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _rotateImage,
        child: const Icon(Icons.rotate_right),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_file_dialog/flutter_file_dialog.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';

// class FullScreenImage extends StatefulWidget {
//   final String imageUrl;

//   const FullScreenImage({super.key, required this.imageUrl});

//   @override
//   State<FullScreenImage> createState() => _FullScreenImageState();
// }

// class _FullScreenImageState extends State<FullScreenImage> {
//   double _rotationAngle = 0;

//   Future<void> _saveImage(String imageUrl) async {
//     try {
//       // 1. Fetch the image data
//       final response = await http.get(Uri.parse(imageUrl));
//       if (response.statusCode == 200) {
//         // 2. Get the Downloads directory
//         final directory = await getExternalStorageDirectory();
//         if (directory != null) {
//           final filePath = '${directory.path}/downloaded_image.jpg';

//           // 3. Save the image to the file
//           final file = File(filePath);
//           await file.writeAsBytes(response.bodyBytes);
//           final params = SaveFileDialogParams(sourceFilePath: file.path);
//           final finalPath = await FlutterFileDialog.saveFile(params: params);

//           // 4. Show a success message (optional)
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Image saved successfully to $finalPath')),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//                 content: Text('Error: Downloads directory not found.')),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text('Error downloading image: ${response.statusCode}')),
//         );
//       }
//     } catch (e) {
//       // Handle general errors
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error saving image: $e')),
//       );
//     }
//   }

//   void _rotateImage() {
//     setState(() {
//       _rotationAngle += 90; // Rotate by 90 degrees
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Full Screen Image"),
//         actions: [
//           IconButton(
//             onPressed: () => _saveImage(widget.imageUrl),
//             icon: const Icon(Icons.save),
//           ),
//         ],
//       ),
//       body: Center(
//         child: RotatedBox(
//           quarterTurns: (_rotationAngle / 90).round(),
//           child: Image.network(
//             widget.imageUrl,
//             fit: BoxFit.contain,
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _rotateImage,
//         child: const Icon(Icons.rotate_right),
//       ),
//     );
//   }
// }
