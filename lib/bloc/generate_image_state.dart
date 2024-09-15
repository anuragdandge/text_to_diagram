part of 'generate_image_bloc.dart';

abstract class GenerateImageState {}

final class GenerateImageInitialState extends GenerateImageState {}

final class GeneratingImageState extends GenerateImageState {}

final class GeneratedImagesSuccessState extends GenerateImageState {}

final class GenerateImageErrorState extends GenerateImageState {
  late String errorMessage;
  GenerateImageErrorState({required errorMessage});
}
