import 'package:agrivision/pages/disease_predict/prediction.pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import '../../themes/utils/colors.theme.dart';
import '../../themes/utils/spacing.theme.dart';
import '../../themes/utils/typography.theme.dart';
import '../../widgets/disease_predict/scanner/circleicon.widget.dart';
import '../../widgets/disease_predict/scanner/pill.widget.dart';
import '../../widgets/disease_predict/scanner/scanframe.widget.dart';

class CropScannerScreen extends StatefulWidget {
  const CropScannerScreen({super.key});

  @override
  State<CropScannerScreen> createState() => _CropScannerScreenState();
}

class _CropScannerScreenState extends State<CropScannerScreen> {
  CameraController? _controller;
  late Future<void> _initializeCamera;

  bool _flashOn = false;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );

    _controller = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _initializeCamera = _controller!.initialize();
    setState(() {});
  }

  /// 🔦 TOGGLE FLASH
  Future<void> _toggleFlash() async {
    if (_controller == null) return;

    _flashOn = !_flashOn;
    await _controller!.setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);

    setState(() {});
  }

  /// 🖼 PICK IMAGE FROM GALLERY
  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // TODO: Send image.path to ML model
      debugPrint('Picked image: ${image.path}');

      /// 👉 Navigate to Analysis Result screen
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (_) => const PredictionScreen()),
      );
    }
  }

  /// 📸 CAPTURE IMAGE
  Future<void> _captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final image = await _controller!.takePicture();

      debugPrint('Captured image: ${image.path}');

      if (!mounted) return;

      /// 👉 Navigate to Analysis Result screen
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (_) => const PredictionScreen()),
      );
    } catch (e) {
      debugPrint('Error capturing image: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.black,
      child: Stack(
        children: [
          /// 🔹 LIVE CAMERA PREVIEW
          Positioned.fill(
            child: _controller == null
                ? const Center(child: CupertinoActivityIndicator())
                : FutureBuilder(
                    future: _initializeCamera,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CameraPreview(_controller!);
                      }
                      return const Center(child: CupertinoActivityIndicator());
                    },
                  ),
          ),

          /// 🔹 DARK OVERLAY
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.35)),
          ),

          /// 🔹 TOP BAR
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleIconButton(
                    icon: CupertinoIcons.xmark,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Pill(
                    icon: CupertinoIcons.leaf_arrow_circlepath,
                    label: 'CROP SCANNER',
                  ),
                  Icon(
                    CupertinoIcons.question,
                    color: AppThemeColors.cardbackground,
                  ),
                ],
              ),
            ),
          ),

          /// 🔹 CENTER FRAME
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Pill(label: 'Align leaf within the frame'),
                SizedBox(height: AppSpacing.xl),
                ScanFrame(),
                SizedBox(height: AppSpacing.lg),
                Text(
                  'Keep the camera steady for a better scan',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),

          /// 🔹 BOTTOM CONTROLS
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: AppSpacing.xl,
                  left: AppSpacing.xl,
                  right: AppSpacing.xl,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// 🖼 GALLERY
                    CircleIconButton(
                      icon: CupertinoIcons.photo,
                      onTap: _pickFromGallery,
                    ),

                    /// 📸 CAPTURE
                    GestureDetector(
                      onTap: _captureImage,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppThemeColors.success,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          CupertinoIcons.camera_fill,
                          size: 30,
                          color: CupertinoColors.white,
                        ),
                      ),
                    ),

                    /// 🔦 FLASH
                    CircleIconButton(
                      icon: _flashOn
                          ? CupertinoIcons.bolt_fill
                          : CupertinoIcons.bolt_slash,
                      onTap: _toggleFlash,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
