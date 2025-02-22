import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key});

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  final CarouselSliderController carouselController = CarouselSliderController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final carouselImages = [
      'assets/images/welcome_1.png',
      'assets/images/welcome_2.png',
      'assets/images/welcome_3.png',
      'assets/images/welcome_4.png',
    ];
    final carouselText = [
      "Find the perfect books for your child",
      "Create and fill custom bookshelves",
      "Assign and track reading goals",
      "Join and manage virtual classrooms",
    ];

    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: carouselController,
          itemCount: carouselImages.length,
          itemBuilder: (context, index, realIndex) {
            return Column(
              children: [
                Expanded(
                  child: Image.asset(
                    carouselImages[index],
                  ),
                ),
                addVerticalSpace(16),
                Text(
                  carouselText[index],
                  style: textTheme.titleSmallWhite,
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
          options: CarouselOptions(
            height: 400,
            autoPlay: true,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            }
          ),
        ),
        addVerticalSpace(24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(carouselImages.length, (index) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.7), width: 1.3),
                color: currentIndex == index ? Colors.white : Colors.transparent,
              ),
            );
          }),
        ),

      ],
    );
  }
}