import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CompanyProfileApp());
}

const _fallbackPhoto =
    'https://images.unsplash.com/photo-1497366754035-f200968a6e72?auto=format&fit=crop&w=1600&q=80';

class CompanyConfig {
  final String companyName;
  final String tagline;
  final String description;
  final String address;
  final String phone;
  final String whatsapp;
  final String email;
  final String website;
  final String companyPhoto;
  final List<String> services;
  final List<String> gallery;

  const CompanyConfig({
    required this.companyName,
    required this.tagline,
    required this.description,
    required this.address,
    required this.phone,
    required this.whatsapp,
    required this.email,
    required this.website,
    required this.companyPhoto,
    required this.services,
    required this.gallery,
  });

  factory CompanyConfig.fromJson(Map<String, dynamic> json) {
    return CompanyConfig(
      companyName: _text(json['company_name'], 'Arunika Consulting'),
      tagline: _text(json['tagline'], 'Strategic Business Partner'),
      description: _text(
        json['description'],
        'Kami membantu bisnis tumbuh melalui strategi, operasional, dan eksekusi digital yang terukur.',
      ),
      address: _text(json['address'], 'Jakarta, Indonesia'),
      phone: _text(json['phone'], '+62 812 0000 0000'),
      whatsapp: _text(json['whatsapp'], '+62 812 0000 0000'),
      email: _text(json['email'], 'hello@company.com'),
      website: _text(json['website'], 'www.company.com'),
      companyPhoto: _text(json['company_photo'], _fallbackPhoto),
      services: _list(json['services'], const [
        'Business Strategy',
        'Digital Transformation',
        'Operational Consulting',
      ]),
      gallery: _list(json['gallery'], const [
        'https://images.unsplash.com/photo-1519389950473-47ba0277781c?auto=format&fit=crop&w=900&q=80',
        'https://images.unsplash.com/photo-1556761175-b413da4baf72?auto=format&fit=crop&w=900&q=80',
        'https://images.unsplash.com/photo-1552664730-d307ca884978?auto=format&fit=crop&w=900&q=80',
      ]),
    );
  }

  static String _text(dynamic value, String fallback) {
    final result = value?.toString().trim() ?? '';
    return result.isEmpty ? fallback : result;
  }

  static List<String> _list(dynamic value, List<String> fallback) {
    if (value is! List) return fallback;
    final items = value
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
    return items.isEmpty ? fallback : items;
  }
}

class CompanyProfileApp extends StatelessWidget {
  const CompanyProfileApp({super.key});

  Future<CompanyConfig> _loadConfig() async {
    try {
      final response = await rootBundle.loadString('assets/config.json');
      final data = json.decode(response) as Map<String, dynamic>;
      return CompanyConfig.fromJson(data);
    } catch (_) {
      return CompanyConfig.fromJson(const {});
    }
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF183D3D);
    const accent = Color(0xFFD89C4A);

    return FutureBuilder<CompanyConfig>(
      future: _loadConfig(),
      builder: (context, snapshot) {
        final config = snapshot.data ?? CompanyConfig.fromJson(const {});

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: config.companyName,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: primary,
              primary: primary,
              secondary: accent,
              surface: Colors.white,
            ),
            scaffoldBackgroundColor: const Color(0xFFF7F5F0),
            textTheme: Theme.of(context).textTheme.apply(
              bodyColor: const Color(0xFF1F2933),
              displayColor: const Color(0xFF14213D),
            ),
          ),
          home: CompanyProfilePage(config: config),
        );
      },
    );
  }
}

class CompanyProfilePage extends StatelessWidget {
  const CompanyProfilePage({super.key, required this.config});

  final CompanyConfig config;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 760;
          final isTablet = constraints.maxWidth < 1040;

          return SingleChildScrollView(
            child: Column(
              children: [
                _TopBar(config: config, isMobile: isMobile),
                _HeroSection(config: config, isMobile: isMobile),
                _Section(child: _MetricsSection(isMobile: isMobile)),
                _Section(
                  child: _AboutSection(
                    config: config,
                    isMobile: isMobile,
                    isTablet: isTablet,
                  ),
                ),
                _Section(
                  child: _ServicesSection(config: config, isMobile: isMobile),
                ),
                _Section(
                  child: _GallerySection(config: config, isMobile: isMobile),
                ),
                _Section(
                  child: _ContactSection(config: config, isMobile: isMobile),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.config, required this.isMobile});

  final CompanyConfig config;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return _Section(
      top: isMobile ? 18 : 26,
      bottom: isMobile ? 12 : 16,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFF183D3D),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.business_rounded, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  config.companyName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  config.tagline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF60717B)),
                ),
              ],
            ),
          ),
          if (!isMobile) ...[
            _NavText(label: 'Tentang'),
            _NavText(label: 'Layanan'),
            _NavText(label: 'Kontak'),
          ],
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.config, required this.isMobile});

  final CompanyConfig config;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF183D3D),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              isMobile ? 32 : 58,
              24,
              isMobile ? 36 : 64,
            ),
            child: Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: isMobile ? 0 : 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        config.tagline.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFFD89C4A),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        config.companyName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 38 : 58,
                          height: 1.04,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        config.description,
                        style: const TextStyle(
                          color: Color(0xFFDCE7E3),
                          fontSize: 17,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _ActionChip(
                            icon: Icons.call_rounded,
                            label: config.phone,
                          ),
                          _ActionChip(
                            icon: Icons.mail_rounded,
                            label: config.email,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: isMobile ? 0 : 44, height: isMobile ? 32 : 0),
                Expanded(
                  flex: isMobile ? 0 : 4,
                  child: _ResponsivePhoto(
                    imageUrl: config.companyPhoto,
                    height: isMobile ? 260 : 440,
                    radius: 8,
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

class _MetricsSection extends StatelessWidget {
  const _MetricsSection({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      ('100+', 'Klien Terlayani'),
      ('10+', 'Tahun Pengalaman'),
      ('24/7', 'Dukungan Konsultasi'),
    ];

    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: metrics
          .map(
            (metric) => SizedBox(
              width: isMobile ? double.infinity : 260,
              child: _Metric(value: metric.$1, label: metric.$2),
            ),
          )
          .toList(),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({
    required this.config,
    required this.isMobile,
    required this.isTablet,
  });

  final CompanyConfig config;
  final bool isMobile;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final layout = [
      _SectionTitle(
        eyebrow: 'Tentang Perusahaan',
        title: 'Solusi bisnis yang rapi, terukur, dan mudah dijalankan.',
        body: config.description,
      ),
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE7E0D5)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _CheckText(text: 'Pendekatan berbasis data dan kebutuhan bisnis.'),
            _CheckText(
              text: 'Tim profesional untuk strategi, operasional, dan digital.',
            ),
            _CheckText(
              text: 'Komunikasi jelas dari perencanaan sampai eksekusi.',
            ),
          ],
        ),
      ),
    ];

    if (isMobile || isTablet) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [layout[0], const SizedBox(height: 18), layout[1]],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: layout[0]),
        const SizedBox(width: 42),
        Expanded(flex: 4, child: layout[1]),
      ],
    );
  }
}

class _ServicesSection extends StatelessWidget {
  const _ServicesSection({required this.config, required this.isMobile});

  final CompanyConfig config;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          eyebrow: 'Layanan',
          title: 'Area kerja utama kami',
          body:
              'Daftar layanan ini bisa langsung diatur dari file JSON sesuai kebutuhan perusahaan.',
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: config.services
              .map(
                (service) => SizedBox(
                  width: isMobile ? double.infinity : 360,
                  child: _ServiceCard(title: service),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection({required this.config, required this.isMobile});

  final CompanyConfig config;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          eyebrow: 'Foto Perusahaan',
          title: 'Ruang kerja, tim, dan aktivitas perusahaan.',
          body:
              'Jika data foto kosong, tampilan otomatis memakai gambar online cadangan.',
        ),
        const SizedBox(height: 22),
        GridView.builder(
          itemCount: config.gallery.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 1 : 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isMobile ? 1.55 : 1.18,
          ),
          itemBuilder: (context, index) {
            return _ResponsivePhoto(
              imageUrl: config.gallery[index],
              height: 240,
              radius: 8,
            );
          },
        ),
      ],
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection({required this.config, required this.isMobile});

  final CompanyConfig config;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 22 : 30),
      decoration: BoxDecoration(
        color: const Color(0xFF14213D),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: isMobile ? 0 : 4,
            child: const _SectionTitle(
              eyebrow: 'Kontak',
              title: 'Mari diskusikan kebutuhan perusahaan Anda.',
              body: 'Hubungi kami melalui kanal resmi berikut.',
              light: true,
            ),
          ),
          SizedBox(width: isMobile ? 0 : 40, height: isMobile ? 22 : 0),
          Expanded(
            flex: isMobile ? 0 : 5,
            child: Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                _ContactTile(
                  icon: Icons.location_on_rounded,
                  label: 'Alamat',
                  value: config.address,
                ),
                _ContactTile(
                  icon: Icons.phone_rounded,
                  label: 'Telepon',
                  value: config.phone,
                ),
                _ContactTile(
                  icon: Icons.chat_rounded,
                  label: 'WhatsApp',
                  value: config.whatsapp,
                ),
                _ContactTile(
                  icon: Icons.language_rounded,
                  label: 'Website',
                  value: config.website,
                ),
                _ContactTile(
                  icon: Icons.email_rounded,
                  label: 'Email',
                  value: config.email,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponsivePhoto extends StatelessWidget {
  const _ResponsivePhoto({
    required this.imageUrl,
    required this.height,
    required this.radius,
  });

  final String imageUrl;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Image.network(
          imageUrl.trim().isEmpty ? _fallbackPhoto : imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const _PhotoFallback();
          },
        ),
      ),
    );
  }
}

class _PhotoFallback extends StatelessWidget {
  const _PhotoFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE8DED1),
      child: const Center(
        child: Icon(Icons.image_rounded, color: Color(0xFFB77724), size: 44),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.child, this.top = 34, this.bottom = 34});

  final Widget child;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, top, 24, bottom),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: child,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.eyebrow,
    required this.title,
    required this.body,
    this.light = false,
  });

  final String eyebrow;
  final String title;
  final String body;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: TextStyle(
            color: light ? const Color(0xFFD89C4A) : const Color(0xFFB77724),
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            color: light ? Colors.white : const Color(0xFF14213D),
            fontSize: 30,
            height: 1.18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          body,
          style: TextStyle(
            color: light ? const Color(0xFFDDE5EC) : const Color(0xFF53636D),
            fontSize: 16,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

class _NavText extends StatelessWidget {
  const _NavText({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 26),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Color(0xFF344955),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFD89C4A), size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE7E0D5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: Color(0xFF183D3D),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF53636D),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckText extends StatelessWidget {
  const _CheckText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFFD89C4A),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(height: 1.45, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 144),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE7E0D5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.auto_graph_rounded,
            color: Color(0xFFD89C4A),
            size: 28,
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: Color(0xFF14213D),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFD89C4A), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFFB8C4CC),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
