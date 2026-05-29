import 'dart:io';
import 'dart:typed_data';
import '../utils/contants.utils.dart';
import '../utils/general.utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

class PredictionService {
  final String baseUrl = '${AppConstants.baseUrl}/api';

  tfl.Interpreter? _interpreter;
  bool _isModelLoaded = false;

  /// Load TensorFlow Lite model from assets
  Future<void> loadModel() async {
    try {
      _interpreter = await tfl.Interpreter.fromAsset(
        'assets/models/prediction_model.tflite',
      );
      _isModelLoaded = true;
      print("PREDICTION | TFLite model loaded successfully.");
    } catch (e) {
      print("PREDICTION | Error loading TFLite model: $e");
      _isModelLoaded = false;
    }
  }

  // ─────────────────────────────────────────
  // DISEASE NAME  →  TFLite Model
  // ─────────────────────────────────────────
  Future<String> predictOffline(File imageFile) async {
    if (!_isModelLoaded) {
      await loadModel();
      if (!_isModelLoaded || _interpreter == null) {
        print("PREDICTION | ERROR | Model Load is failed");
        return "Error: Model failed to load.";
      }
    }

    // Decode and preprocess image
    final imageBytes = imageFile.readAsBytesSync();
    final decodedImage = img.decodeImage(imageBytes);
    if (decodedImage == null) {
      print("PREDICTION | ERROR | decode image failed");
      return "Error: Failed to decode image.";
    }

    img.Image image = img.copyResize(
      decodedImage,
      width: 224,
      height: 224,
      interpolation: img.Interpolation.linear,
    );
    Float32List input = imageToByteList(image, 224);

    // Prepare input tensor
    var inputTensor = input.reshape([1, 224, 224, 3]);

    // Prepare output tensor (adjust based on model output shape)
    var outputTensor = List.filled(1 * 55, 0.0).reshape([1, 55]);

    try {
      // Run inference
      _interpreter!.run(inputTensor, outputTensor);

      // Process output
      final List<double> prediction = List<double>.from(outputTensor[0]);
      final predictedClass = prediction.indexOf(
        prediction.reduce((a, b) => a > b ? a : b),
      );

      print(
        "PREDICTION | Predicted Class: $predictedClass (Scores: $prediction)",
      );
      return "$predictedClass";
    } catch (e) {
      print("PREDICTION | ERROR | during inference: $e\n");
      return "Error during inference: $e";
    }
  }

  /// Convert image to TFLite-friendly input
  Float32List imageToByteList(img.Image image, int inputSize) {
    var convertedBytes = Float32List(inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        final pixel = image.getPixel(x, y);
        final r = pixel.r / 255.0; // Extract Red
        final g = pixel.g / 255.0; // Extract Green
        final b = pixel.b / 255.0; // Extract Blue

        buffer[pixelIndex++] = r;
        buffer[pixelIndex++] = g;
        buffer[pixelIndex++] = b;
      }
    }
    return buffer;
  }

  // ─────────────────────────────────────────
  // DISEASE INFO  →  POST /prediction/disease-info
  // ─────────────────────────────────────────
  Future<Map<String, dynamic>> getDiseaseInfo({required String disease}) async {
    try {
      final headers = await GeneralUtils.authHeaders();

      final response = await http.post(
        Uri.parse("$baseUrl/predict/disease-info"),
        headers: headers,
        body: jsonEncode({"disease": disease}),
      );

      print("DISEASE INFO | ${response.statusCode} | ${response.body}");

      final decoded = jsonDecode(response.body);

      return {
        "success": decoded["success"] ?? false,
        "message": decoded["message"] ?? "Unknown error",
        "statusCode": response.statusCode,
        "description": decoded["description"],     // null if not returned
      };
    } catch (e) {
      print("Get disease info error: $e");
      throw Exception("Failed to fetch disease info: $e");
    }
  }
}

// return {
//         "success": true,
//         "message": "Successfully got the Description",
//         "statusCode": 200,
//         "description": {
//           "english": {
//             "symptoms": [
//               {
//                 "title": "Brown Spots",
//                 "description": "Circular dark spots with yellow halos",
//               },
//               {
//                 "title": "White Mold",
//                 "description": "Fuzzy growth on the underside",
//               },
//               {
//                 "title": "Leaf Curl",
//                 "description": "Leaves begin curling inward",
//               },
//             ],
//             "treatment": {
//               "spray_name": "Asdemac",
//               "dosage": "2ml / 4L",
//               "frequency": "3",
//             },
//           },

//           "hindi": {
//             "symptoms": [
//               {
//                 "title": "भूरे धब्बे",
//                 "description": "पत्तियों पर पीले घेरे वाले धब्बे",
//               },
//               {
//                 "title": "सफेद फफूंदी",
//                 "description": "पत्तियों के नीचे सफेद परत",
//               },
//             ],
//             "treatment": {
//               "spray_name": "Asdemac",
//               "dosage": "2ml / 4L",
//               "frequency": "3",
//             },
//           },
//         },
// };
