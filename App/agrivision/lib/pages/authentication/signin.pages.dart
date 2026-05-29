import 'package:agrivision/themes/utils/colors.theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../services/auth.services.dart';
import '../../themes/utils/spacing.theme.dart';
import '../../themes/utils/typography.theme.dart';
import '../../utils/app-localization.utils.dart';
import '../../utils/language.utils.dart';
import '../../widgets/responsive-base.widget.dart';
import 'otp-verify.pages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ── controllers & state ───────────────────────────────
  final TextEditingController _phoneController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _showLanguagePicker(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: Text(AppLocalizations.of(context)!.translate("Select Language")),
        actions: LanguageProvider.supportedLanguages.map((lang) {
          return CupertinoActionSheetAction(
            onPressed: () {
              languageProvider.changeLanguage(lang['locale']);
              Navigator.pop(context);
            },
            child: Text(lang['name']),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          isDefaultAction: true,
          child: Text(AppLocalizations.of(context)!.translate("Cancel")),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────
  // GET OTP  →  calls login service then navigates
  // ─────────────────────────────────────────────────────
  Future<void> _handleGetOtp() async {
    final phone = _phoneController.text.trim();

    // ── basic validation ──
    if (phone.isEmpty || phone.length != 10) {
      _showError(AppLocalizations.of(context)!.translate("Please enter a valid 10-digit mobile number."));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _authService.login(phone);

      if (!mounted) return;

      if (result['success'] == true) {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => OTPVerificationScreen(phonenumber: phone),
          ),
        );
      } else {
        _showError(result['message'] ?? AppLocalizations.of(context)!.translate("Failed to send OTP."));
      }
    } catch (e) {
      _showError(AppLocalizations.of(context)!.translate("Something went wrong. Please try again."));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── error dialog helper ───────────────────────────────
  void _showError(String message) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context)!.translate("ERROR")),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: Text(AppLocalizations.of(context)!.translate("OK")),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    // ── read current language name from provider ──
    final languageProvider = context.watch<LanguageProvider>();
    final currentLangName =
        LanguageProvider.supportedLanguages.firstWhere(
              (l) => l['locale'] == languageProvider.selectedLocale,
              orElse: () => LanguageProvider.supportedLanguages.first,
            )['name']
            as String;

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
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'assets/images/logo-transparent.png',
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(AppLocalizations.of(context)!.translate("AgriVision"), style: AppTextStyles.h2),
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
                            Text(currentLangName),
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
                  AppLocalizations.of(context)!.translate("Welcome to\nAgriVision"),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h1.copyWith(
                    color: CupertinoColors.black,
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                Text(
                  AppLocalizations.of(context)!.translate("Enter your mobile number to get started."),
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
                        AppLocalizations.of(context)!.translate("MOBILE NUMBER"),
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
                                controller: _phoneController,
                                placeholder: '9876543210',
                                keyboardType: TextInputType.phone,
                                decoration: null,
                                padding: EdgeInsets.zero,
                                maxLength: 10,
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
                          onPressed: _isLoading ? null : _handleGetOtp,
                          child: _isLoading
                              ? const CupertinoActivityIndicator(
                                  color: CupertinoColors.white,
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Center(
                                          child: Text(
                                            AppLocalizations.of(context)!.translate("Get OTP"),
                                            style: AppTextStyles.buttonStyles,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        const Icon(
                                          CupertinoIcons
                                              .arrowshape_turn_up_right_fill,
                                          color: AppThemeColors.textButton,
                                          size: 22,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(CupertinoIcons.arrow_right, size: 18),
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
                  AppLocalizations.of(context)!.translate("By continuing, you agree to our\nTerms of Service & Privacy Policy"),
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
