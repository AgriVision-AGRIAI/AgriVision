import 'dart:async';
import 'package:agrivision/pages/tab-shell.pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Material, Colors;
import 'package:pinput/pinput.dart';
import '../../services/auth.services.dart';
import '../../themes/utils/typography.theme.dart';
import '../../utils/app-localization.utils.dart';
import '../../widgets/responsive-base.widget.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phonenumber;
  const OTPVerificationScreen({super.key, required this.phonenumber});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  static const int _otpLength = 5;

  final TextEditingController _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final AuthService _authService = AuthService();
  bool _isVerifying = false;
  bool _isResending = false;

  int _secondsRemaining = 59;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();

    /// Auto-open keyboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining = 59;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  // ─────────────────────────────────────────────────────
  // VERIFY OTP  →  calls verify service then navigates
  // ─────────────────────────────────────────────────────
  Future<void> _handleVerify() async {
    setState(() => _isVerifying = true);

    try {
      final result = await _authService.verify(
        widget.phonenumber,
        _otpController.text.trim(),
      );

      if (!mounted) return;

      if (result['success'] == true) {
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (_) => MainTabShell(),
          ),
        );
      } else {
        _showError(result['message'] ?? AppLocalizations.of(context)!.translate("Invalid OTP. Please try again."));
      }
    } catch (e) {
      _showError(AppLocalizations.of(context)!.translate("Something went wrong. Please try again."));
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  // ─────────────────────────────────────────────────────
  // RESEND OTP  →  calls resendOtp service & restarts timer
  // ─────────────────────────────────────────────────────
  Future<void> _handleResend() async {
    if (_secondsRemaining > 0 || _isResending) return;

    setState(() => _isResending = true);

    try {
      final result = await _authService.resendOtp(widget.phonenumber);

      if (!mounted) return;

      if (result['success'] == true) {
        _startTimer();                          // restart countdown
        _otpController.clear();                 // clear previous OTP input
        setState(() {});
      } else {
        _showError(result['message'] ?? AppLocalizations.of(context)!.translate("Failed to resend OTP."));
      }
    } catch (e) {
      _showError(AppLocalizations.of(context)!.translate("Something went wrong. Please try again."));
    } finally {
      if (mounted) setState(() => _isResending = false);
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
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    /// 🎨 PIN THEMES (rounded, filled)
    final defaultPinTheme = PinTheme(
      width: 54,
      height: 54,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CupertinoColors.systemGrey4,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.primaryColor,
          width: 1.8,
        ),
      ),
    );

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: ResponsiveBase(
          child: SafeArea(
            child: Column(
              children: [
                /// 🔝 HEADER
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.pop(context),
                        child: const Icon(CupertinoIcons.back),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 6),
                        Text(AppLocalizations.of(context)!.translate("OTP Verification"), style: AppTextStyles.h2),
                      ],
                    ),
                  ],
                ),
        
                /// 🔥 CENTER CONTENT
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// 🧠 TITLE
                      Text(
                        AppLocalizations.of(context)!.translate("Verify Your Identity"),
                        style: AppTextStyles.h1,
                        textAlign: TextAlign.center,
                      ),
        
                      const SizedBox(height: 12),
        
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          AppLocalizations.of(context)!.translate(
                            "otp_message",
                            params: {
                              "phone": "+91 ${widget.phonenumber}",
                            }
                          ),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body,
                        ),
                      ),
        
                      const SizedBox(height: 36),
        
                      /// 🔢 OTP INPUT (Material wrapped)
                      Material(
                        color: Colors.transparent,
                        child: Pinput(
                          length: _otpLength,
                          controller: _otpController,
                          focusNode: _focusNode,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          keyboardType: TextInputType.number,
                          mainAxisAlignment: MainAxisAlignment.center,
                          separatorBuilder: (_) =>
                              const SizedBox(width: 12),
                          autofillHints: const [AutofillHints.oneTimeCode],
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
        
                      const SizedBox(height: 28),
        
                      /// ⏱ TIMER
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Text(
                          _secondsRemaining > 0
                              ? AppLocalizations.of(context)!.translate("RESEND IN ")+"00:${_secondsRemaining.toString().padLeft(2, '0')}"
                              : '',
                          style: AppTextStyles.caption,
                        ),
                      ),
        
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context)!.translate("Didn't receive the code? "), style: AppTextStyles.caption.copyWith(
                                  color: _secondsRemaining > 0
                                      ? CupertinoColors.systemGrey
                                      : theme.primaryColor,
                                ),),
                      GestureDetector(
                        onTap: _handleResend,
                        child: _isResending
                            ? CupertinoActivityIndicator(
                                color: theme.primaryColor,
                              )
                            : Text(
                        AppLocalizations.of(context)!.translate("Resend Code"),
                        style: AppTextStyles.caption.copyWith(
                                  color: _secondsRemaining > 0
                                      ? CupertinoColors.systemGrey
                                      : theme.primaryColor,
                                ),
                              ),
                      ),
                        ],
                      ),
                    ],
                  ),
                ),
        
                /// ✅ BOTTOM BUTTON (FIXED)
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: CupertinoButton(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(28),
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 24),
                    onPressed: _otpController.text.length ==
                            _otpLength && !_isVerifying
                        ? _handleVerify
                        : null,
                    child:  _isVerifying
                        ? const CupertinoActivityIndicator(
                            color: CupertinoColors.white,
                          )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate("Verify & Proceed"),
                          style: AppTextStyles.buttonStyles,
                        ),
                        const SizedBox(width: 8),
                        const Icon(CupertinoIcons.arrow_right),
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
