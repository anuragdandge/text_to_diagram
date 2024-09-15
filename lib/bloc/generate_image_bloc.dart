// import 'dart:async';

// import 'package:bloc/bloc.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';

// part 'generate_image_event.dart';
// part 'generate_image_state.dart';

// class GenerateImageBloc extends Bloc<GenerateImageEvent, GenerateImageState> {
//   GenerateImageBloc() : super(GenerateImageInitialState()) {
//     on<GenerateImageButtonClickedEvent>(generateImageButtonClickedEvent);
//   }
//   final model = GenerativeModel(
//     model: 'gemini-1.5-pro',
//     apiKey: "AIzaSyBQr-dciBcWT4dvY_XTvzzLljoD071ixPI",
//   );
//   FutureOr<void> generateImageButtonClickedEvent(
//       GenerateImageButtonClickedEvent event,
//       Emitter<GenerateImageState> emit) async {
//     try {
//       emit(GeneratingImageState());
//       final content = [
//         Content.text("give me only plantuml code of ${event.prompt}")
//       ];
//       String? _diagramImage;
//       final response = await model.generateContent(content);
//       if (response.text != null) {
//         String cleanedCode =
//             response.text!.replaceAll('```', '').replaceAll('plantuml', '');

//         // Check if the cleaned code is valid PlantUML
//         if (isValidPlantUML(cleanedCode)) {
//           _plantumlCodeController.text = cleanedCode;
//           _diagramImage =
//               'http://www.plantuml.com/plantuml/img/~h${cleanedCode.codeUnits.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join()}';
//           _imageLoading = true; // Start image loading

//           print(_diagramImage);

//           // Wait for the image to load
//           await Future.delayed(
//               const Duration(seconds: 1)); // Adjust delay as needed

//           emit(GeneratedImagesSuccessState());
//         } else {
//           emit(GenerateImageErrorState(
//               errorMessage: "Error: The response is not valid PlantUML code."));
//         }
//       } else {
//         emit(GenerateImageErrorState(
//             errorMessage: "Error: Response text is null."));
//       }

//       emit(GeneratedImagesSuccessState());
//     } catch (e) {
//       emit(GenerateImageErrorState(errorMessage: e));
//     }
//   }
// }
