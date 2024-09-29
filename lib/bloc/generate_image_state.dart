part of 'generate_image_bloc.dart';

abstract class GenerateImageState {}

final class GenerateImageInitialState extends GenerateImageState {}

final class GeneratingImageState extends GenerateImageState {}

final class GeneratedImagesSuccessState extends GenerateImageState {
  late final String imageUrl;
  GeneratedImagesSuccessState({required this.imageUrl});
}

final class GenerateImageErrorState extends GenerateImageState {
  late final String errorMessage;
  GenerateImageErrorState({required this.errorMessage});
}
