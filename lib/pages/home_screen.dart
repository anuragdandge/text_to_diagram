import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:text_to_diagram/bloc/generate_image_bloc.dart';
import 'package:text_to_diagram/pages/fullimage_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final model = GenerativeModel(
    model: 'gemini-1.5-pro',
    apiKey: "AIzaSyBQr-dciBcWT4dvY_XTvzzLljoD071ixPI",
  );

  final _plantumlCodeController = TextEditingController();
  final _promptController = TextEditingController();
  String? _diagramImage;
  bool _isLoading = false;
  String? _errorMessage;
  bool _imageLoading = false; // Track image loading
  final GenerateImageBloc generateImageBloc = GenerateImageBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Text-To-Diagram"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _promptController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Please describe your project idea here...",
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: const WidgetStatePropertyAll(
                        Colors.deepPurpleAccent,
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    onPressed: () {
                      generateImageBloc.add(GenerateImageButtonClickedEvent(
                          prompt: _promptController.text));
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Generate Diagram',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 5,
                    thickness: 3,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            BlocConsumer<GenerateImageBloc, GenerateImageState>(
              bloc: generateImageBloc,
              listener: (context, state) {
                if (state is GeneratedImagesSuccessState) {}
              },
              builder: (context, state) {
                if (state is GenerateImageInitialState) {
                  return Center(
                      child: Image.asset('assets/generating_image.png'));
                } else if (state is GeneratedImagesSuccessState) {
                  debugPrint(" Success ");
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImage(
                              imageUrl: (state).imageUrl,
                            ),
                          ),
                        );
                      },
                      child: InteractiveViewer(
                          child: Image.network((state).imageUrl)),
                    ),
                  );
                } else if (state is GeneratingImageState) {
                  debugPrint(" Generating ");
                  return const CircularProgressIndicator();
                } else if (state is GenerateImageErrorState) {
                  debugPrint((state).errorMessage);
                  return Center(child: Text((state).errorMessage));
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
