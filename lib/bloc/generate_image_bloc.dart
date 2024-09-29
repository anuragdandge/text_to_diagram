import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

part 'generate_image_event.dart';
part 'generate_image_state.dart';

class GenerateImageBloc extends Bloc<GenerateImageEvent, GenerateImageState> {
  GenerateImageBloc() : super(GenerateImageInitialState()) {
    on<GenerateImageButtonClickedEvent>(generateImageButtonClickedEvent);
  }
  final model = GenerativeModel(
    model: 'gemini-1.5-pro',
    apiKey: "AIzaSyBQr-dciBcWT4dvY_XTvzzLljoD071ixPI",
  );
  FutureOr<void> generateImageButtonClickedEvent(
      GenerateImageButtonClickedEvent event,
      Emitter<GenerateImageState> emit) async {
    try {
      emit(GeneratingImageState());
      final content = [
        Content.text("give me only plantuml code of ${event.prompt}")
      ];
      String? diagramImage;
      final response = await model.generateContent(content);
      debugPrint(response.text);
      bool isValidPlantUML(String code) {
        return code.contains("@startuml") && code.contains("@enduml");
      }

      if (response.text != null) {
        String cleanedCode =
            response.text!.replaceAll('```', '').replaceAll('plantuml', '');
        if (isValidPlantUML(cleanedCode)) {
          diagramImage =
              'http://www.plantuml.com/plantuml/img/~h${cleanedCode.codeUnits.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join()}';
          await Future.delayed(const Duration(seconds: 1));
          emit(GeneratedImagesSuccessState(imageUrl: diagramImage));
        } else {
          emit(GenerateImageErrorState(
              errorMessage: "Error: The response is not valid PlantUML code."));
        }
      } else {
        emit(GenerateImageErrorState(
            errorMessage: "Error: Response text is null."));
      }
    } catch (e) {
      emit(GenerateImageErrorState(errorMessage: e.toString()));
    }
  }
}
