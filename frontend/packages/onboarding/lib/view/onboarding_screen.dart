library onboarding;

import 'package:flutter/material.dart';

import '../onboarding.dart';

extension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  double get shortestDim => MediaQuery.of(this).size.shortestSide;
}

class OnboardingScreen extends StatefulWidget {
  final double padding;
  final Function()? onDone;

  const OnboardingScreen({
    this.padding = 20,
    this.onDone,
    super.key,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController pageController = PageController(initialPage: 0);

  int currentPage = 0;

  void onPageChanged(int page) => setState(() => currentPage = page);

  void nextPage() => pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );

  bool get lastPage => currentPage == OnboardingData.data.length - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // view pages
          PageView.builder(
            itemCount: OnboardingData.data.length,
            itemBuilder: (context, index) => _OnboardingPage(
              data: OnboardingData.data[index],
              padding: widget.padding,
            ),
            controller: pageController,
            onPageChanged: onPageChanged,
          ),
          // skipbutton
          Positioned(
            top: widget.padding,
            right: widget.padding,
            child: SafeArea(
              child: TextButton(
                onPressed: widget.onDone,
                child: Text('Skip', style: context.textTheme.labelLarge),
              ),
            ),
          ),
          Positioned(
            bottom: widget.padding,
            left: widget.padding,
            right: widget.padding,
            child: SafeArea(
              child: Row(
                children: [
                  // indicator dots
                  for (int i = 0; i < OnboardingData.data.length; i++)
                    if (i == currentPage)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.all(2),
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      )
                    else
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.all(2),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                  const Spacer(),

                  // nextbutton
                  TextButton(
                    onPressed: lastPage ? widget.onDone : nextPage,
                    child: Text(
                      lastPage ? 'Get Started' : 'Next',
                      style: context.textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;
  final double padding;
  const _OnboardingPage({required this.data, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: data.color,
      child: Column(
        children: [
          const Spacer(flex: 2),
          Image.asset(
            data.image,
            width: context.shortestDim / 2,
            height: context.shortestDim / 2,
          ),
          const Spacer(),
          Text(
            data.title,
            style: context.textTheme.titleLarge,
          ),
          SizedBox(height: padding),
          Text(
            data.description,
            style: context.textTheme.labelSmall,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
