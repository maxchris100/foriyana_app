import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BannerCarouselSection extends StatefulWidget {
  const BannerCarouselSection({super.key});

  @override
  State<BannerCarouselSection> createState() => _BannerCarouselSectionState();
}

class _BannerCarouselSectionState extends State<BannerCarouselSection> {
  int _currentIndex = 0;
  final List<Map<String, String>> banners = [
    {
      'image': 'assets/images/autumn_banner1.png',
      'title': 'Autumn Collection',
      'subtitle': '20% off for new arrivals',
    },
    {
      'image': 'assets/images/autumn_banner2.png',
      'title': 'Winter Deals',
      'subtitle': 'Stay warm in style',
    },
    {
      'image': 'assets/images/autumn_banner3.png',
      'title': 'Spring Look',
      'subtitle': 'Fresh styles for sunny days',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.95,
          onPageChanged: (index, _) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        items: banners.map((banner) {
          return Builder(
            builder: (context) {
              return Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage(banner['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.brown),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              banner['title']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              banner['subtitle']!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(banners.length, (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentIndex == index
                                    ? Colors.white
                                    : Colors.white38,
                              ),
                            );
                          }),
                        ),
                      ))
                ],
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
