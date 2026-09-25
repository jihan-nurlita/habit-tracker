import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();

  int currentIndex = 0;

  final List<Map<String, String>> items = [
    {
      "title": "Bangun Kebiasaan Positif",
      "desc":
          "Catat dan pantau kebiasaan harianmu agar lebih konsisten setiap hari.",
      "image": "assets/images/onboarding1.png",
    },
    {
      "title": "Fokus Dengan Timer",
      "desc": "Gunakan focus timer untuk membantu meningkatkan produktivitas.",
      "image": "assets/images/onboarding2.png",
    },
    {
      "title": "Pantau Statistik",
      "desc": "Lihat perkembangan habit dan streak yang telah kamu capai.",
      "image": "assets/images/onboarding3.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FBF7),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: items.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = items[index];

                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          item["image"]!,
                          height: 300,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          item["title"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item["desc"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                items.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentIndex == index ? 25 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? const Color(0xff69A66B)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff69A66B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    if (currentIndex < items.length - 1) {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pushReplacementNamed(
                        context,
                        '/home',
                      );
                    }
                  },
                  child: Text(
                    currentIndex == items.length - 1 ? "Mulai" : "Lanjut",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
