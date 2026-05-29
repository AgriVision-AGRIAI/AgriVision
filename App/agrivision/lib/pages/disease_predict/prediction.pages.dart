import 'dart:io';
import 'package:agrivision/utils/crop-prediction.utils.dart';
import 'package:agrivision/widgets/responsive-base.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';
import '../../services/prediction.services.dart';
import '../../themes/utils/colors.theme.dart';
import '../../themes/utils/spacing.theme.dart';
import '../../themes/utils/typography.theme.dart';
import '../../utils/app-localization.utils.dart';
import '../../utils/disease-names.utils.dart';
import '../../widgets/disease_predict/prediction/image.widget.dart';
import '../../widgets/disease_predict/prediction/name.widget.dart';
import '../../widgets/disease_predict/prediction/symptoms.widget.dart';
import '../../widgets/disease_predict/prediction/treatment.widget.dart';

class PredictionScreen extends StatefulWidget {
  final File image;
  const PredictionScreen({super.key, required this.image});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final ClassesList _classesList = ClassesList();
  final PredictionService _service = PredictionService();
  List<CropSymptoms> _data = [];
  Map<String, dynamic> _treatment = {};
  String _predictionResult = "";
  String? resultName;
  String? translatedDescription;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _processImage();
  }

  Future<void> _processImage() async {
    try {
      String prediction = await _predictImage();
      resultName = _classesList.getClassName(prediction);
      String translatedName = AppLocalizations.of(
        context,
      )!.translate(resultName!);
      late final description;
      if (resultName != "Not Found") {
        Map<String, dynamic> result = await _service.getDiseaseInfo(
          disease: resultName!,
        );
        description = result['description'] as Map<String, dynamic>;
      } else {
        description = {
          "english": {
            "symptoms": [
              {
                "title": "Disease Not Found",
                "description":
                    "No information available for this disease. Please consult an agricultural expert.",
              },
            ],
            "treatment": {
              "spray_name": "N/A",
              "dosage": "N/A",
              "frequency": "0",
            },
          },
          "hindi": {
            "symptoms": [
              {
                "title": "रोग नहीं मिला",
                "description":
                    "इस रोग के बारे में कोई जानकारी उपलब्ध नहीं है। कृपया कृषि विशेषज्ञ से परामर्श करें।",
              },
            ],
            "treatment": {
              "spray_name": "N/A",
              "dosage": "N/A",
              "frequency": "0",
            },
          },
          "telugu": {
            "symptoms": [
              {
                "title": "వ్యాధి కనుగొనబడలేదు",
                "description":
                    "ఈ వ్యాధికి సంబంధించిన సమాచారం అందుబాటులో లేదు. దయచేసి వ్యవసాయ నిపుణుడిని సంప్రదించండి.",
              },
            ],
            "treatment": {
              "spray_name": "N/A",
              "dosage": "N/A",
              "frequency": "0",
            },
          },
          "tamil": {
            "symptoms": [
              {
                "title": "நோய் கண்டறியப்படவில்லை",
                "description":
                    "இந்த நோயைப் பற்றிய தகவல்கள் எதுவும் இல்லை. தயவுசெய்து விவசாய நிபுணரை அணுகவும்.",
              },
            ],
            "treatment": {
              "spray_name": "N/A",
              "dosage": "N/A",
              "frequency": "0",
            },
          },
          "punjabi": {
            "symptoms": [
              {
                "title": "ਰੋਗ ਨਹੀਂ ਮਿਲਿਆ",
                "description":
                    "ਇਸ ਰੋਗ ਬਾਰੇ ਕੋਈ ਜਾਣਕਾਰੀ ਉਪਲਬਧ ਨਹੀਂ ਹੈ। ਕਿਰਪਾ ਕਰਕੇ ਖੇਤੀਬਾੜੀ ਮਾਹਰ ਨਾਲ ਸੰਪਰਕ ਕਰੋ।",
              },
            ],
            "treatment": {
              "spray_name": "N/A",
              "dosage": "N/A",
              "frequency": "0",
            },
          },
        };
      }
      final localeCode = Localizations.localeOf(context).languageCode;

      final Map<String, String> languageMap = {
        'en': 'english',
        'hi': 'hindi',
        'te': 'telugu',
        'ta': 'tamil',
        'pa': 'punjabi',
      };

      String language = languageMap[localeCode] ?? 'english';
      final symptoms = List<Map<String, dynamic>>.from(
        description[language]?['symptoms'] ?? [],
      );

      _data = symptoms.map((e) {
        return CropSymptoms(
          title: e['title'] ?? '',
          description: e['description'] ?? '',
        );
      }).toList();
      _treatment = Map<String, dynamic>.from(
        description[language]?['treatment'] ?? {},
      );

      setState(() {
        _predictionResult = translatedName;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _predictionResult = "Prediction Failed";
        print("PREDICTION | ERROR | ${e}");
        translatedDescription = "Error: $e";
        _isLoading = false;
      });
    }
  }

  Future<String> _predictImage() async {
    return await _service.predictOffline(widget.image);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppThemeColors.background,
      navigationBar: CupertinoNavigationBar(
        middle: Text(AppLocalizations.of(context)!.translate("Analysis Results"), style: AppTextStyles.h2),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Icon(CupertinoIcons.back),
        ),
        border: null,
      ),
      child: SafeArea(
        child: ResponsiveBase(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isLoading) ...[
                  _buildScanResultCardSkeleton(),

                  const SizedBox(height: AppSpacing.lg),

                  _buildDiseaseDetectedCardSkeleton(),

                  const SizedBox(height: AppSpacing.lg),

                  _buildSymptomsListSkeleton(),

                  const SizedBox(height: AppSpacing.xl),

                  _buildTreatmentPlanCardSkeleton(),
                ] else ...[
                  ScanResultCard(image: widget.image),

                  const SizedBox(height: AppSpacing.lg),

                  DiseaseDetectedCard(name: _predictionResult),

                  const SizedBox(height: AppSpacing.lg),

                  SymptomsList(data: _data),

                  const SizedBox(height: AppSpacing.xl),

                  TreatmentPlanCard(data: _treatment),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _shimmerContainer({
    double height = 100,
    double width = double.infinity,
    BorderRadius? radius,
    EdgeInsets? margin,
  }) {
    return Shimmer.fromColors(
      baseColor: CupertinoColors.systemGrey5,
      highlightColor: CupertinoColors.systemGrey4,
      child: Container(
        margin: margin,
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: radius ?? BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildScanResultCardSkeleton() {
    return _shimmerContainer(height: 220);
  }

  Widget _buildDiseaseDetectedCardSkeleton() {
    return Shimmer.fromColors(
      baseColor: CupertinoColors.systemGrey5,
      highlightColor: CupertinoColors.systemGrey4,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              height: 28,
              width: 28,
              decoration: const BoxDecoration(
                color: CupertinoColors.systemGrey,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmerContainer(
                    height: 18,
                    width: 180,
                    radius: BorderRadius.circular(8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomsListSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: CupertinoColors.systemGrey5,
          highlightColor: CupertinoColors.systemGrey4,
          child: Container(
            height: 22,
            width: 140,
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        ...List.generate(
          2,
          (_) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Shimmer.fromColors(
              baseColor: CupertinoColors.systemGrey5,
              highlightColor: CupertinoColors.systemGrey4,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 24,
                      width: 24,
                      decoration: const BoxDecoration(
                        color: CupertinoColors.systemGrey,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: AppSpacing.md),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _shimmerContainer(
                            height: 16,
                            width: 120,
                            radius: BorderRadius.circular(8),
                          ),

                          const SizedBox(height: 8),

                          _shimmerContainer(
                            height: 12,
                            width: double.infinity,
                            radius: BorderRadius.circular(8),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTreatmentPlanCardSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: CupertinoColors.systemGrey5,
          highlightColor: CupertinoColors.systemGrey4,
          child: Container(
            height: 22,
            width: 160,
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        Shimmer.fromColors(
          baseColor: CupertinoColors.systemGrey5,
          highlightColor: CupertinoColors.systemGrey4,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerContainer(
                  height: 14,
                  width: 140,
                  radius: BorderRadius.circular(8),
                ),

                const SizedBox(height: AppSpacing.md),

                _shimmerContainer(
                  height: 22,
                  width: 220,
                  radius: BorderRadius.circular(8),
                ),

                const SizedBox(height: AppSpacing.lg),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _shimmerContainer(
                        height: 40,
                        radius: BorderRadius.circular(12),
                      ),
                    ),

                    const SizedBox(width: AppSpacing.md),

                    Expanded(
                      child: _shimmerContainer(
                        height: 40,
                        radius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
