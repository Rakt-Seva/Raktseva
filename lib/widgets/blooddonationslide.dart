import 'dart:async';
import 'package:flutter/material.dart';

class BloodDonationSlides extends StatefulWidget {
  @override
  _BloodDonationSlidesState createState() => _BloodDonationSlidesState();
}

class _BloodDonationSlidesState extends State<BloodDonationSlides> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  final List<Map<String, String>> slides = [
    {"title": "Save Lives", "description": "A single donation can save up to 3 lives."},
    {"title": "Eligibility", "description": "You can donate blood every 56 days."},
    {"title": "Blood Types", "description": "O-negative is the universal donor."},
    {"title": "Myths vs Facts", "description": "Myth: Blood donation makes you weak."},
    {"title": "Global Need", "description": "Every 2 seconds, someone needs blood."},
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_currentIndex < slides.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        SizedBox(
          height: 150, // Adjust height as needed
          child: PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildSlide(slides[index]);
            },
          ),
        ),
        SizedBox(height: 10),
        // Dot Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            slides.length,
                (index) => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == index ? Colors.redAccent : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlide(Map<String, String> slide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                slide["title"]!,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                slide["description"]!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
