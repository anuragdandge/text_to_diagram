import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:text_to_diagram/pages/fullimage_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: "AIzaSyBQr-dciBcWT4dvY_XTvzzLljoD071ixPI",
  );

  final _plantumlCodeController = TextEditingController();
  final _promptController = TextEditingController();
  String? _diagramImage;
  bool _isLoading = false;
  String? _errorMessage;
  bool _imageLoading = false; // Track image loading

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Text-to-Diagram",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                onPressed: _isLoading ? null : () => _generateDiagram(),
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
              TextField(
                controller: _plantumlCodeController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Your code will appear here </>",
                ),
                readOnly: true, // Make the field read-only
              ),
              const SizedBox(height: 10),
              if (_diagramImage != null)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImage(
                          imageUrl: _diagramImage!,
                        ),
                      ),
                    );
                  },
                  child: _imageLoading
                      ? const Center(
                          child:
                              CircularProgressIndicator()) // Loading animation
                      : InteractiveViewer(child: Image.network(_diagramImage!)),
                )
              else
                const Text("Diagram will appear here "),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generateDiagram() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final content = [
        Content.text("give me only plantuml code of ${_promptController.text}")
      ];
      final response = await model.generateContent(content);

      if (response.text != null) {
        String cleanedCode =
            response.text!.replaceAll('```', '').replaceAll('plantuml', '');

        // Check if the cleaned code is valid PlantUML
        if (isValidPlantUML(cleanedCode)) {
          setState(() {
            _plantumlCodeController.text = cleanedCode;
            _diagramImage =
                'http://www.plantuml.com/plantuml/img/~h${cleanedCode.codeUnits.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join()}';
            _imageLoading = true; // Start image loading
          });

          print(_diagramImage);

          // Wait for the image to load
          await Future.delayed(
              const Duration(seconds: 1)); // Adjust delay as needed

          setState(() {
            _imageLoading = false; // Image loaded
          });
        } else {
          // Handle case where the response is not valid PlantUML
          setState(() {
            _errorMessage = "Error: The response is not valid PlantUML code.";
          });
        }
      } else {
        // Handle case where response.text is null
        setState(() {
          _errorMessage = "Error: Response text is null.";
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = "Error generating diagram: ${error.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to check if the code is valid PlantUML
  bool isValidPlantUML(String code) {
    // You can implement a more robust validation here,
    // but for simplicity, we'll just check for the presence of "@startuml" and "@enduml"
    return code.contains("@startuml") && code.contains("@enduml");
  }
}
