import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:image_picker/image_picker.dart';

abstract interface class ReportImagePicker {
  Future<List<String>> pickFromCamera();
  Future<List<String>> pickFromGallery();
  Future<List<String>> recoverLostImages();
}

final class ImagePickerReportImagePicker implements ReportImagePicker {
  ImagePickerReportImagePicker([ImagePicker? picker])
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<List<String>> pickFromCamera() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 2400,
        maxHeight: 2400,
        imageQuality: 90,
      );
      return image == null ? const [] : [image.path];
    } catch (error) {
      throw AppException('Could not open the camera.', cause: error);
    }
  }

  @override
  Future<List<String>> pickFromGallery() async {
    try {
      final images = await _picker.pickMultiImage(
        maxWidth: 2400,
        maxHeight: 2400,
        imageQuality: 90,
      );
      return images.map((image) => image.path).toList(growable: false);
    } catch (error) {
      throw AppException('Could not open the photo library.', cause: error);
    }
  }

  @override
  Future<List<String>> recoverLostImages() async {
    try {
      final response = await _picker.retrieveLostData();
      if (response.isEmpty) return const [];
      if (response.exception != null) {
        throw AppException(
          'Could not recover the selected photos.',
          cause: response.exception,
        );
      }
      return (response.files ?? const <XFile>[])
          .map((image) => image.path)
          .toList(growable: false);
    } on AppException {
      rethrow;
    } catch (error) {
      throw AppException(
        'Could not recover the selected photos.',
        cause: error,
      );
    }
  }
}
