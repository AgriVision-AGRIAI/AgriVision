import 'package:agrivision/widgets/responsive-base.widget.dart';
import 'package:flutter/cupertino.dart';
import '../../themes/utils/colors.theme.dart';
import '../../themes/utils/spacing.theme.dart';
import '../../themes/utils/typography.theme.dart';
import '../../widgets/disease_predict/prediction/image.widget.dart';
import '../../widgets/disease_predict/prediction/name.widget.dart';
import '../../widgets/disease_predict/prediction/symptoms.widget.dart';
import '../../widgets/disease_predict/prediction/treatment.widget.dart';

class PredictionScreen extends StatelessWidget {
  const PredictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppThemeColors.background,
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          'Analysis Results',
          style: AppTextStyles.h2,
        ),
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
              children: const [
                ScanResultCard(),
          
                SizedBox(height: AppSpacing.lg),
          
                DiseaseDetectedCard(),
          
                SizedBox(height: AppSpacing.lg),
          
                SymptomsList(),
          
                SizedBox(height: AppSpacing.xl),
          
                TreatmentPlanCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
