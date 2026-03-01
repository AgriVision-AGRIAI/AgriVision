import 'package:agrivision/pages/authentication/otp-verify.pages.dart';
import 'package:agrivision/pages/general/splash.pages.dart';
import 'package:agrivision/pages/weather/weather.pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../themes/utils/typography.theme.dart';
import '../../../themes/utils/spacing.theme.dart';
import '../../../themes/utils/colors.theme.dart';
import '../../../widgets/responsive-base.widget.dart';
import '../../widgets/homepage/service.widget.dart';
import '../../widgets/homepage/weather.widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    return CupertinoPageScaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: ResponsiveBase(
        child: Stack(
          children: [
            /// 🔹 MAIN CONTENT
            SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    /// 🔝 HEADER
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 22,
                            backgroundImage: AssetImage(
                              'assets/images/farmer.png',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Namaste, Ramesh 🤚🏼',
                              style: AppTextStyles.title,
                            ),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppThemeColors.cardbackground,
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x14000000),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  CupertinoIcons.bell_fill,
                                  size: 20,
                                  color: AppThemeColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    /// 🌤 WEATHER CARD
                    const HomeWeatherCard(),

                    const SizedBox(height: AppSpacing.xl),

                    /// 🧩 SERVICES
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Explore Services',
                            style: AppTextStyles.h2,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            children: const [
                              HomeServiceCard(
                                title: 'Crop Advice',
                                subtitle: 'Best for your soil',
                                icon: CupertinoIcons.crop,
                                bgColor: AppThemeColors.cropbackground,
                                iconColor: AppThemeColors.cropicon,
                                destination: SplashScreen(),
                              ),
                              HomeServiceCard(
                                title: 'Weather',
                                subtitle: '7-day forecast',
                                icon: CupertinoIcons.cloud_sun,
                                bgColor: AppThemeColors.weatherbackground,
                                iconColor: AppThemeColors.weathericon,
                                destination: WeatherScreen(),
                              ),
                              HomeServiceCard(
                                title: 'Fertilizers',
                                subtitle: 'Nutrient schedules',
                                icon: CupertinoIcons.lab_flask_solid,
                                bgColor: AppThemeColors.fertilizersbackground,
                                iconColor: AppThemeColors.fertilizersicon,
                                destination: OTPVerificationScreen(),
                              ),
                              HomeServiceCard(
                                title: 'Market Rates',
                                subtitle: 'Live Mandi prices',
                                icon: CupertinoIcons.money_dollar,
                                bgColor: AppThemeColors.marketbackground,
                                iconColor: AppThemeColors.marketicon,
                                destination: HomeScreen(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),

            // /// 🔽 FLOATING BOTTOM NAV BAR
            // const Positioned(
            //   left: 0,
            //   right: 0,
            //   bottom: 0,
            //   child: HomeBottomNav(),
            // ),
          ],
        ),
      ),
    );
  }
}
