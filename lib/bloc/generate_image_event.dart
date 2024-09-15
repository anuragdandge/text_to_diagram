part of 'generate_image_bloc.dart';

abstract class GenerateImageEvent {}

class GenerateImageButtonClickedEvent extends GenerateImageEvent {
  late final String prompt;
  GenerateImageButtonClickedEvent({required prompt});
}
