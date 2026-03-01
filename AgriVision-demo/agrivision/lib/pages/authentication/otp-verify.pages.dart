import 'dart:async';
import 'package:agrivision/pages/tab-shell.pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Material, Colors;
import 'package:pinput/pinput.dart';

import '../../themes/utils/typography.theme.dart';
import '../../widgets/responsive-base.widget.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  static const int _otpLength = 5;

  final TextEditingController _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

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
                      children: const [
                        Icon(CupertinoIcons.leaf_arrow_circlepath),
                        SizedBox(width: 6),
                        Text('KRUSHIMITRA', style: AppTextStyles.h2),
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
                      const Text(
                        'Verify Your Identity',
                        style: AppTextStyles.h1,
                        textAlign: TextAlign.center,
                      ),
        
                      const SizedBox(height: 12),
        
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          "We've sent a 5-digit verification code to +91 ••••••482. Please enter it below to proceed.",
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
                              ? 'RESEND IN 00:${_secondsRemaining.toString().padLeft(2, '0')}'
                              : '',
                          style: AppTextStyles.caption,
                        ),
                      ),
        
                      const SizedBox(height: 12),
        
                      const Text(
                        "Didn't receive the code? Resend Code",
                        style: AppTextStyles.caption,
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
                            _otpLength
                        ? () {
                            Navigator.of(context).pushReplacement(
                              CupertinoPageRoute(
                                builder: (_) => MainTabShell(),
                              ),
                            );
                          }
                        : null,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Verify & Proceed',
                          style: AppTextStyles.buttonStyles,
                        ),
                        SizedBox(width: 8),
                        Icon(CupertinoIcons.arrow_right),
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
