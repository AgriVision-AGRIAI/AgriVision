import 'package:agrivision/themes/utils/colors.theme.dart';
import 'package:agrivision/themes/utils/spacing.theme.dart';
import 'package:agrivision/themes/utils/typography.theme.dart';
import 'package:agrivision/widgets/responsive-base.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import '../../utils/app-localization.utils.dart';
import '../../widgets/recommend/grid.crop.widget.dart';
import '../../widgets/recommend/location.crop.widget.dart';
import '../../widgets/recommend/recommend.crop.widget.dart';
import '../../widgets/recommend/header.crop.widget.dart';

class CropRecommendPage extends StatefulWidget {
  const CropRecommendPage({super.key});

  @override
  State<CropRecommendPage> createState() => _CropRecommendPageState();
}

class _CropRecommendPageState extends State<CropRecommendPage> {
  double? _lat;
  double? _lon;

  // ignore: unused_field
  String? _error;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      setState(() {
        _lat = pos.latitude;
        _lon = pos.longitude;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppThemeColors.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
          ),
          child: ResponsiveBase(
            child: Column(
              children: [
                /// HEADER
                const CropRecommendHeader(),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.xl),
                  
                        /// LOCATION
                        LocationCard(lat: _lat!, lon: _lon!),
                  
                        const SizedBox(height: AppSpacing.xl),
                  
                        /// AI RECOMMENDATION
                        Text(
                          AppLocalizations.of(context)!.translate("AI Recommendation"),
                          style: AppTextStyles.sectionTitle,
                        ),
                  
                        const SizedBox(height: AppSpacing.lg),
                  
                        AIRecommendationCard(lat: _lat!, lon: _lon!),
                  
                        const SizedBox(height: AppSpacing.xxl),
                  
                        /// LAND ANALYSIS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.translate("Land Analysis"),
                              style: AppTextStyles.sectionTitle,
                            ),
                            const Icon(
                              CupertinoIcons.info_circle,
                              size: 22,
                              color: AppThemeColors.textPrimary,
                            ),
                          ],
                        ),
                  
                        const SizedBox(height: AppSpacing.lg),
                  
                        AnalysisGrid(lat: _lat!, lon: _lon!),
                  
                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}