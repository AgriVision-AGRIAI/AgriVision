import 'package:agrivision/themes/utils/colors.theme.dart';
import 'package:flutter/cupertino.dart';
import '../../themes/utils/spacing.theme.dart';
import '../../themes/utils/typography.theme.dart';
import '../../widgets/responsive-base.widget.dart';
import 'otp-verify.pages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _selectedLanguage = 'English';

  final Map<String, String> _languages = {
    'English': 'English',
    'Hindi': 'हिन्दी',
    'Telugu': 'తెలుగు',
    'Tamil': 'தமிழ்',
  };

  void _showLanguagePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Select Language'),
        actions: _languages.entries.map((entry) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedLanguage = entry.value;
              });
              Navigator.pop(context);
            },
            child: Text(entry.value),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          isDefaultAction: true,
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    return CupertinoPageScaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: ResponsiveBase(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.xl),

                /// 🔝 Top bar (logo + language)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(CupertinoIcons.leaf_arrow_circlepath),
                        SizedBox(width: 6),
                        Text('AgriVision', style: AppTextStyles.h2),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => _showLanguagePicker(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.globe, size: 14),
                            const SizedBox(width: 6),
                            Text(_selectedLanguage),
                            const SizedBox(width: 4),
                            const Icon(CupertinoIcons.chevron_down, size: 14),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xl),

                /// 🖼 Image Placeholder
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/farmer.png',
                        fit: BoxFit.contain, // 🔥 IMPORTANT
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                /// 🧠 Heading
                Text(
                  'Welcome to\nAgriVision',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h1.copyWith(
                    color: CupertinoColors.black,
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                Text(
                  'Enter your mobile number to get started.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color: CupertinoColors.systemGrey,
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                /// 📱 Mobile Number Card
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MOBILE NUMBER',
                        style: AppTextStyles.caption.copyWith(
                          letterSpacing: 1.1,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.sm),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: theme.primaryColor,
                            width: 1.2,
                          ),
                          color: CupertinoColors.white,
                        ),
                        child: Row(
                          children: [
                            const Text('+91'),
                            const SizedBox(width: 8),
                            Container(
                              width: 1,
                              height: 20,
                              color: CupertinoColors.systemGrey4,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CupertinoTextField(
                                placeholder: '9876543210',
                                keyboardType: TextInputType.phone,
                                decoration: null,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.device_phone_portrait,
                              color: theme.primaryColor,
                              size: 18,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      /// 👉 Get OTP Button
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoButton(
                          color: theme.primaryColor,
                          borderRadius: BorderRadius.circular(16),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          onPressed: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (_) => const OTPVerificationScreen(),
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Center(
                                    child: Text(
                                      'Get OTP',
                                      style: AppTextStyles.buttonStyles,
                                    ),
                                  ),
                                  SizedBox(width: 14),
                                  Icon(
                                    CupertinoIcons
                                        .arrowshape_turn_up_right_fill,
                                    color: AppThemeColors.textButton,
                                    size: 22,
                                  ),
                                ],
                              ),
                              SizedBox(width: 8),
                              Icon(CupertinoIcons.arrow_right, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                const SizedBox(height: AppSpacing.lg),

                /// 📜 Footer
                Text(
                  'By continuing, you agree to our\nTerms of Service & Privacy Policy',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: CupertinoColors.systemGrey,
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
