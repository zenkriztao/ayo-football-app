import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ayo_football_app/core/services/storage_service.dart';

/// Model untuk konten onboarding dengan gambar
class OnboardingContent {
  final String title;
  final String subtitle;
  final String description;
  final String imagePath;

  const OnboardingContent({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
  });
}

/// Halaman Onboarding dengan design modern dan gambar
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Warna maroon palette
  static const Color maroonDark = Color(0xFF5D0E0E);
  static const Color maroonPrimary = Color(0xFF8B1A1A);
  static const Color maroonLight = Color(0xFFB71C1C);

  final List<OnboardingContent> _contents = const [
    OnboardingContent(
      title: 'Kelola Tim',
      subtitle: 'Sepak Bola Anda',
      description:
          'Atur dan kelola tim sepak bola dengan mudah. Tambahkan pemain, pantau perkembangan, dan raih kemenangan bersama.',
      imagePath: 'assets/images/fans_supporters.png',
    ),
    OnboardingContent(
      title: 'Manajemen',
      subtitle: 'Pemain Profesional',
      description:
          'Catat data lengkap pemain termasuk posisi, nomor punggung, statistik performa, dan prestasi di setiap pertandingan.',
      imagePath: 'assets/images/player_champion.png',
    ),
    OnboardingContent(
      title: 'Jadwal &',
      subtitle: 'Pertandingan',
      description:
          'Atur jadwal pertandingan, catat hasil pertandingan, dan analisis performa tim untuk strategi yang lebih baik.',
      imagePath: 'assets/images/players_match.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    _animationController.reset();
    _animationController.forward();
  }

  void _onNextPressed() {
    if (_currentPage < _contents.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _onSkipPressed() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    final storageService = ref.read(storageServiceProvider);
    await storageService.setOnboardingCompleted(true);

    if (mounted) {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFFAFAFA),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header dengan skip button
              _buildHeader(),

              // PageView content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _contents.length,
                  itemBuilder: (context, index) {
                    return _buildOnboardingItem(_contents[index], screenHeight);
                  },
                ),
              ),

              // Bottom section
              _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo kecil
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: maroonLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  'assets/icons/logo.png',
                  height: 24,
                ),
              ),
            ],
          ),
          // Skip button
          TextButton(
            onPressed: _onSkipPressed,
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
            ),
            child: Row(
              children: [
                Text(
                  'Lewati',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingItem(OnboardingContent content, double screenHeight) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // Image dengan container
              Container(
                height: screenHeight * 0.35,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: maroonLight.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    content.imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Title dengan style dua baris
              Column(
                children: [
                  Text(
                    content.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: maroonDark,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    content.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: maroonLight.withOpacity(0.8),
                      height: 1.1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Description
              Text(
                content.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
      child: Column(
        children: [
          // Page indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _contents.length,
              (index) => _buildDot(index),
            ),
          ),

          const SizedBox(height: 30),

          // Next/Get Started button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _onNextPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: maroonLight,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                shadowColor: maroonLight.withOpacity(0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentPage == _contents.length - 1
                        ? 'Mulai Sekarang'
                        : 'Lanjut',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (_currentPage < _contents.length - 1) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 20),
                  ],
                ],
              ),
            ),
          ),

          // Login text untuk halaman terakhir
          if (_currentPage == _contents.length - 1) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sudah punya akun? ',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.go('/login'),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(
                      color: maroonLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    final isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 32 : 8,
      decoration: BoxDecoration(
        color: isActive ? maroonLight : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: maroonLight.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
    );
  }
}
