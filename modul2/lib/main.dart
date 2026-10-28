import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alif Alfathar — FullStack Software Engineer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFF1F6),
          secondary: Color(0xFFFF659F),
          surface: Color(0xFF241322),
        ),
        scaffoldBackgroundColor: _PortfolioColors.background,
        useMaterial3: true,
      ),
      home: const PortfolioPage(),
    );
  }
}

abstract final class _PortfolioColors {
  static const background = Color(0xFF130912);
  static const card = Color(0xFF1C0E1A);
  static const cardRaised = Color(0xFF2E182B);
  static const cardHighest = Color(0xFF3A1E36);
  static const secondary = Color(0xFFFF659F);
  static const muted = Color(0xFFD9B8CB);
  static const subtle = Color(0xFFA47997);
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _scrollController = ScrollController();
  final _sectionKeys = List.generate(5, (_) => GlobalKey());
  bool _isPlaying = false;
  int _activeSection = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openLink(String value) async {
    final uri = Uri.parse(value);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Tidak dapat membuka $value')));
    }
  }

  void _scrollTo(int index) {
    setState(() => _activeSection = index);
    final target = _sectionKeys[index].currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
      alignment: 0.04,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _TopBar(
            selectedIndex: _activeSection,
            onNavigate: _scrollTo,
            onOpenLink: _openLink,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  _HeroSection(key: _sectionKeys[0], onOpenLink: _openLink),
                  const _MetricsSection(),
                  _WorksSection(key: _sectionKeys[1], onOpenLink: _openLink),
                  _CapabilitiesSection(key: _sectionKeys[2]),
                  _WritingSection(key: _sectionKeys[3]),
                  _ListeningSection(
                    isPlaying: _isPlaying,
                    onToggle: () => setState(() => _isPlaying = !_isPlaying),
                  ),
                  _FooterSection(key: _sectionKeys[4], onOpenLink: _openLink),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.selectedIndex,
    required this.onNavigate,
    required this.onOpenLink,
  });

  final int selectedIndex;
  final ValueChanged<int> onNavigate;
  final ValueChanged<String> onOpenLink;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xF2131315),
        border: Border(bottom: BorderSide(color: Color(0xFF262629))),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 760;
                return Row(
                  children: [
                    const Text(
                      'alfathrr',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      '/dev',
                      style: TextStyle(color: _PortfolioColors.subtle),
                    ),
                    const SizedBox(width: 16),
                    if (!compact)
                      const _AvailabilityBadge()
                    else
                      const Spacer(),
                    if (!compact) const Spacer(),
                    if (compact)
                      PopupMenuButton<int>(
                        tooltip: 'Buka navigasi',
                        icon: const Icon(Icons.menu),
                        onSelected: onNavigate,
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 0, child: Text('Index')),
                          PopupMenuItem(value: 1, child: Text('Works')),
                          PopupMenuItem(value: 2, child: Text('Stack')),
                          PopupMenuItem(value: 3, child: Text('Writing')),
                          PopupMenuItem(value: 4, child: Text('Contact')),
                        ],
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _PortfolioColors.card,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final entry in [
                              (label: 'Index', index: 0),
                              (label: 'Works', index: 1),
                              (label: 'Writing', index: 3),
                              (label: 'Stack', index: 2),
                              (label: 'Contact', index: 4),
                            ])
                              _NavButton(
                                label: entry.label,
                                selected: selectedIndex == entry.index,
                                onPressed: () => onNavigate(entry.index),
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(width: 8),
                    if (!compact)
                      OutlinedButton(
                        onPressed: () => onOpenLink(
                          'mailto:hello@alfathrr.dev?subject=Resume%20request',
                        ),
                        child: const Text('RESUME'),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 8, color: _PortfolioColors.secondary),
        SizedBox(width: 8),
        Text(
          'AVAILABLE FOR WORK',
          style: TextStyle(
            color: _PortfolioColors.secondary,
            fontFamily: 'monospace',
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected ? _PortfolioColors.cardHighest : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          key: ValueKey('nav-${label.toLowerCase()}'),
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                color: selected ? Colors.white : _PortfolioColors.muted,
                fontFamily: 'monospace',
                fontSize: 10,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({super.key, required this.onOpenLink});

  final ValueChanged<String> onOpenLink;

  @override
  Widget build(BuildContext context) {
    return _PageSection(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 850;
          final intro = _HeroIntro(onOpenLink: onOpenLink, wide: wide);
          final profile = _ProfileCard(onOpenLink: onOpenLink);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 62),
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 7, child: intro),
                      const SizedBox(width: 52),
                      Expanded(flex: 4, child: profile),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [intro, const SizedBox(height: 36), profile],
                  ),
          );
        },
      ),
    );
  }
}

class _HeroIntro extends StatelessWidget {
  const _HeroIntro({required this.onOpenLink, required this.wide});

  final ValueChanged<String> onOpenLink;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final titleSize = wide ? 68.0 : 46.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: const [
            _StatusPill(label: 'CORE STATUS // SYNCED'),
            _MonoLabel('JAKARTA, ID  •  06°12′S 106°49′E'),
          ],
        ),
        const SizedBox(height: 42),
        Text.rich(
          TextSpan(
            style: TextStyle(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w500,
              height: 1.05,
              letterSpacing: -2.4,
            ),
            children: const [
              TextSpan(text: 'Building clean\n'),
              TextSpan(
                text: 'systems',
                style: TextStyle(
                  color: _PortfolioColors.muted,
                  fontWeight: FontWeight.w300,
                ),
              ),
              TextSpan(text: ' & crafted\ninterfaces'),
              TextSpan(
                text: '.',
                style: TextStyle(color: _PortfolioColors.secondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: const Text(
            'Autonomous software engineer sculpting resilient distributed runtimes and tactile, high-fidelity digital artifacts. Translating complex system logic into unhurried visual stillness.',
            style: TextStyle(
              color: _PortfolioColors.muted,
              fontSize: 17,
              height: 1.7,
            ),
          ),
        ),
        const SizedBox(height: 26),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _ActionChip(
              label: 'GITHUB',
              onTap: () => onOpenLink('https://github.com/alfathrr'),
            ),
            _ActionChip(
              label: 'LINKEDIN',
              onTap: () => onOpenLink('https://linkedin.com/in/alfathrr'),
            ),
            _ActionChip(
              label: 'EMAIL DISPATCH',
              onTap: () => onOpenLink('mailto:hello@alfathrr.dev'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.onOpenLink});

  final ValueChanged<String> onOpenLink;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _PortfolioColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF302F32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/profile.jpg',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const _ImageFallback(),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alif Alfathar  ✓',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'FULLSTACK ENGINEER & DESIGNER',
                      style: TextStyle(
                        color: _PortfolioColors.muted,
                        fontFamily: 'monospace',
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _PortfolioColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionEyebrow('CURRENT OBSESSION  /  R&D'),
                SizedBox(height: 8),
                Text(
                  'Exploring autonomous multi-agent consensus protocols, zero-knowledge proofs, and micro-frontend orchestration.',
                  style: TextStyle(height: 1.55, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _DetailRow(
            label: 'Stack focus',
            value: 'React • Node • TypeScript',
          ),
          const _DetailRow(
            label: 'Education',
            value: 'SMK Taruna Bhakti (TKJ)',
          ),
          const _DetailRow(
            label: 'Availability',
            value: 'Selected inquiries',
            valueColor: _PortfolioColors.secondary,
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => onOpenLink('mailto:hello@alfathrr.dev'),
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text('GET IN TOUCH'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsSection extends StatelessWidget {
  const _MetricsSection();

  @override
  Widget build(BuildContext context) {
    const metrics = [
      ('ANNUAL OUTPUT', '701', 'Commits'),
      ('ACTIVE PULSE', '100%', 'Operational'),
      ('PUBLIC REPOSITORIES', '18', 'Open source'),
    ];
    return Container(
      color: const Color(0xFF0E0E10),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: _PageSection(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth < 620 ? 2 : 4;
            return Wrap(
              spacing: 22,
              runSpacing: 26,
              children: [
                for (final metric in metrics)
                  SizedBox(
                    width:
                        (constraints.maxWidth - (columns - 1) * 22) / columns,
                    child: _Metric(
                      label: metric.$1,
                      value: metric.$2,
                      detail: metric.$3,
                    ),
                  ),
                SizedBox(
                  width: (constraints.maxWidth - (columns - 1) * 22) / columns,
                  child: const _TelemetryGrid(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    required this.detail,
  });

  final String label;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionEyebrow(label),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w500,
            letterSpacing: -1.5,
          ),
        ),
        Text(detail, style: const TextStyle(color: _PortfolioColors.subtle)),
      ],
    );
  }
}

class _TelemetryGrid extends StatelessWidget {
  const _TelemetryGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _SectionEyebrow('TELEMETRY GRID')),
            Text(
              '● LIVE',
              style: TextStyle(
                color: _PortfolioColors.secondary,
                fontSize: 10,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: List.generate(48, (index) {
            final intensity = (index * 7 + index ~/ 3) % 5;
            return Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: intensity < 2
                    ? _PortfolioColors.cardHighest
                    : _PortfolioColors.secondary.withValues(
                        alpha: 0.24 + intensity * 0.14,
                      ),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _WorksSection extends StatelessWidget {
  const _WorksSection({super.key, required this.onOpenLink});

  final ValueChanged<String> onOpenLink;

  @override
  Widget build(BuildContext context) {
    return _PageSection(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeading(
              eyebrow: 'INDEX 01  •  ENGINEERING ARTIFACTS',
              title: 'Selected Works',
              description: 'Curated synthesis of reactive platforms, low-latency audio applications, and commercial design systems.',
            ),
            const SizedBox(height: 30),
            _FeaturedProject(onOpenLink: onOpenLink),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth < 680 ? 1 : 2;
                final cardWidth =
                    (constraints.maxWidth - (columns - 1) * 18) / columns;
                return Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: [
                    SizedBox(
                      width: cardWidth,
                      child: _ProjectCard(
                        image: 'assets/images/ezia-optical.jpg',
                        badge: 'CLIENT COMMISSION',
                        date: '02  •  2025',
                        stack: 'Next.js • Framer',
                        title: 'Ezia Optical',
                        description: 'Avant-garde digital commerce for an upscale eyewear brand, with responsive frame customization and micro-animations.',
                        footer: 'HEADLESS ARCHITECTURE',
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: _ProjectCard(
                        image: 'assets/images/aura-commerce.jpg',
                        badge: 'FULL-STACK PLATFORM',
                        date: '03  •  2024',
                        stack: 'Node.js • PostgreSQL',
                        title: 'AURA E-Commerce',
                        description: 'A luxury shopping ecosystem featuring fast checkout pipelines, atomic inventory sync, and ACID transactions.',
                        footer: 'PAYMENT GATEWAY INTEGRATED',
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 28),
            const _SectionEyebrow('ARCHIVAL INDEX  //  04—07'),
            const SizedBox(height: 10),
            const _ArchiveProject(
              number: '04',
              title: 'Nestly Real Estate',
              description: 'Smart property marketplace & virtual tours',
              stack: 'React • Supabase',
            ),
            const _ArchiveProject(
              number: '05',
              title: 'EchoTic Engine',
              description: 'Real-time concert ticketing and seat mapping',
              stack: 'Express • React • Redis',
            ),
            const _ArchiveProject(
              number: '06',
              title: 'Artisan Roast Portal',
              description: 'Curated coffee catalog and digital checkout',
              stack: 'HTML • Tailwind • JS',
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF0E0E10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 9,
                    color: _PortfolioColors.secondary,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Project Cipher • Stealth R&D'),
                        SizedBox(height: 4),
                        Text(
                          'Autonomous AI Agent Coordinator with Local Vector Store',
                          style: TextStyle(
                            color: _PortfolioColors.subtle,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedProject extends StatelessWidget {
  const _FeaturedProject({required this.onOpenLink});

  final ValueChanged<String> onOpenLink;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        color: _PortfolioColors.card,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 760;
            final details = Padding(
              padding: const EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Tag('FEATURED RELEASE 01'),
                  const SizedBox(height: 20),
                  Text(
                    'Sonara Music',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'An immersive tactile web audio streaming engine designed for spatial acoustics. Engineered with low-latency streaming, procedural visualizers, and a minimalist player interface.',
                    style: TextStyle(
                      color: _PortfolioColors.muted,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: [
                      _Tag('React 18'),
                      _Tag('TypeScript'),
                      _Tag('Web Audio API'),
                      _Tag('Tailwind CSS'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      FilledButton.icon(
                        onPressed: () =>
                            onOpenLink('mailto:hello@alfathrr.dev'),
                        icon: const Icon(Icons.arrow_outward, size: 16),
                        label: const Text('LAUNCH LIVE SYSTEM'),
                      ),
                      TextButton.icon(
                        onPressed: () =>
                            onOpenLink('https://github.com/alfathrr'),
                        icon: const Icon(Icons.code, size: 16),
                        label: const Text('VIEW SOURCE'),
                      ),
                    ],
                  ),
                ],
              ),
            );
            final image = Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/sonara-music.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const _ImageFallback(),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xE60E0E10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Procedural FFT Synthesizer\n48kHz  •  24-bit Lossless Engine',
                      style: TextStyle(fontSize: 12, height: 1.6),
                    ),
                  ),
                ),
              ],
            );
            if (!wide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 240, child: image),
                  details,
                ],
              );
            }
            return SizedBox(
              height: 480,
              child: Row(
                children: [
                  Expanded(flex: 5, child: details),
                  Expanded(flex: 6, child: image),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    required this.image,
    required this.badge,
    required this.date,
    required this.stack,
    required this.title,
    required this.description,
    required this.footer,
  });

  final String image;
  final String badge;
  final String date;
  final String stack;
  final String title;
  final String description;
  final String footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _PortfolioColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Image.asset(
                  image,
                  width: double.infinity,
                  height: 205,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      const SizedBox(height: 205, child: _ImageFallback()),
                ),
                Positioned(top: 12, left: 12, child: _Tag(badge)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MonoLabel(date),
              Flexible(child: _MonoLabel(stack)),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: _PortfolioColors.muted,
              height: 1.5,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          _SectionEyebrow(footer),
        ],
      ),
    );
  }
}

class _ArchiveProject extends StatelessWidget {
  const _ArchiveProject({
    required this.number,
    required this.title,
    required this.description,
    required this.stack,
  });

  final String number;
  final String title;
  final String description;
  final String stack;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      decoration: BoxDecoration(
        color: _PortfolioColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            number,
            style: const TextStyle(
              color: _PortfolioColors.secondary,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(title, style: const TextStyle(fontSize: 14)),
          ),
          if (MediaQuery.sizeOf(context).width >= 650)
            Expanded(
              flex: 3,
              child: Text(
                description,
                style: const TextStyle(
                  color: _PortfolioColors.muted,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              stack,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: _PortfolioColors.subtle,
                fontFamily: 'monospace',
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CapabilitiesSection extends StatelessWidget {
  const _CapabilitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    const capabilities = [
      (
        '01',
        'Core Frontend',
        'Crafting high-fidelity interfaces with tactile motion and consistent design systems.',
        ['React • Next.js', 'TypeScript', 'Tailwind CSS', 'Vite • Webpack'],
      ),
      (
        '02',
        'Backend & Cloud',
        'Architecting microservices, relational schemas, caching, and event-driven data pipelines.',
        [
          'Node.js • Express',
          'PostgreSQL • Supabase',
          'MySQL • Prisma',
          'Docker',
        ],
      ),
      (
        '03',
        'DevOps & Tooling',
        'Automated validation pipelines and reproducible development runtimes.',
        [
          'Git • GitHub Actions',
          'Vercel • Netlify',
          'NPM • PNPM',
          'Figma • Tokens',
        ],
      ),
    ];
    return Container(
      width: double.infinity,
      color: const Color(0xFF0E0E10),
      child: _PageSection(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeading(
                eyebrow: 'INDEX 02  •  SYSTEM MACHINERY',
                title: 'Capabilities & Craft Matrix',
              ),
              const SizedBox(height: 26),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth < 680 ? 1 : 3;
                  final width =
                      (constraints.maxWidth - (columns - 1) * 16) / columns;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      for (final capability in capabilities)
                        SizedBox(
                          width: width,
                          child: _CapabilityCard(
                            number: capability.$1,
                            title: capability.$2,
                            description: capability.$3,
                            technologies: capability.$4,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CapabilityCard extends StatelessWidget {
  const _CapabilityCard({
    required this.number,
    required this.title,
    required this.description,
    required this.technologies,
  });

  final String number;
  final String title;
  final String description;
  final List<String> technologies;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: _PortfolioColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionEyebrow('ENGINE LAYER $number'),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: _PortfolioColors.muted,
              height: 1.5,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          for (final technology in technologies)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
              decoration: BoxDecoration(
                color: _PortfolioColors.background,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(technology, style: const TextStyle(fontSize: 12)),
            ),
        ],
      ),
    );
  }
}

class _WritingSection extends StatelessWidget {
  const _WritingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _PageSection(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 760;
            final intro = const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionEyebrow('INDEX 03  •  DISCOURSE'),
                SizedBox(height: 12),
                Text(
                  'Writing & Reflections',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.8,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Periodic essays documenting technical breakthroughs, mental models, and the evolution of a self-taught engineer in Indonesia.',
                  style: TextStyle(color: _PortfolioColors.muted, height: 1.6),
                ),
              ],
            );
            const article = _ArticleCard();
            if (!wide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [intro, const SizedBox(height: 24), article],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: intro),
                const SizedBox(width: 34),
                const Expanded(flex: 7, child: article),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _PortfolioColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionEyebrow('09 MEI 2026  •  10 MIN READ'),
          SizedBox(height: 16),
          Text(
            'Bagaimana Semua Dimulai — Perjalanan Pemrograman Saya',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),
          Text(
            '“Saya mulai belajar pemrograman pada tahun 2024 di SMK Taruna Bhakti. Ini adalah kisah tentang setiap asumsi yang saya buat, dinding bata yang saya temui, dan setiap kali saya membuktikan diri saya salah.”',
            style: TextStyle(
              color: _PortfolioColors.muted,
              height: 1.7,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Tag('#Perjalanan'),
              _Tag('#Pemrograman'),
              _Tag('#Refleksi'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ListeningSection extends StatelessWidget {
  const _ListeningSection({required this.isPlaying, required this.onToggle});

  final bool isPlaying;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _PortfolioColors.card,
      child: _PageSection(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final player = Row(
                children: [
                  IconButton.filled(
                    tooltip: isPlaying ? 'Jeda pemutar' : 'Putar pratinjau',
                    onPressed: onToggle,
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionEyebrow('LISTENING ON LOOP'),
                        SizedBox(height: 5),
                        Text(
                          'Best Friend — Rex Orange County',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.graphic_eq,
                    color: _PortfolioColors.secondary,
                  ),
                ],
              );
              const quote = Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '“Jika hanya terpaku pada sehelai daun, kamu tak akan melihat pohonnya.”',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 17,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 5),
                  _SectionEyebrow('SYSTEMIC PERSPECTIVE'),
                ],
              );
              if (constraints.maxWidth < 700) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [player, const SizedBox(height: 22), quote],
                );
              }
              return Row(
                children: [
                  Expanded(child: player),
                  const SizedBox(width: 32),
                  const Expanded(child: quote),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection({super.key, required this.onOpenLink});

  final ValueChanged<String> onOpenLink;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF0E0E10),
      child: _PageSection(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 38),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 700;
              final contact = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionEyebrow('DIRECT DISPATCH'),
                  const SizedBox(height: 10),
                  _FooterLink(
                    label: 'hello@alfathrr.dev',
                    onPressed: () => onOpenLink('mailto:hello@alfathrr.dev'),
                  ),
                  _FooterLink(
                    label: 'github.com/alfathrr',
                    onPressed: () => onOpenLink('https://github.com/alfathrr'),
                  ),
                  _FooterLink(
                    label: 'linkedin.com/in/alfathrr',
                    onPressed: () =>
                        onOpenLink('https://linkedin.com/in/alfathrr'),
                  ),
                ],
              );
              final identity = const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'alfathrr  — Archival Core',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Autonomous web engineer and creative technologist architecting performant digital experiences, distributed systems, and tactile interfaces.',
                    style: TextStyle(
                      color: _PortfolioColors.muted,
                      height: 1.5,
                    ),
                  ),
                ],
              );
              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    identity,
                    const SizedBox(height: 24),
                    contact,
                    const SizedBox(height: 28),
                    const _SectionEyebrow('© 2025 ALIF ALFATHAR'),
                  ],
                );
              }
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: identity),
                      const SizedBox(width: 48),
                      Expanded(child: contact),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Divider(color: Color(0xFF302F32)),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: _SectionEyebrow('© 2025 ALIF ALFATHAR'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 3),
      ),
      child: Text(label),
    );
  }
}

class _PageSection extends StatelessWidget {
  const _PageSection({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1320),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: child,
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.eyebrow,
    required this.title,
    this.description,
  });

  final String eyebrow;
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.end,
      runSpacing: 12,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionEyebrow(eyebrow),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.8,
              ),
            ),
          ],
        ),
        if (description != null)
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: Text(
              description!,
              style: const TextStyle(
                color: _PortfolioColors.muted,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
      ],
    );
  }
}

class _SectionEyebrow extends StatelessWidget {
  const _SectionEyebrow(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: _PortfolioColors.secondary,
        fontFamily: 'monospace',
        fontSize: 10,
        letterSpacing: 0.7,
      ),
    );
  }
}

class _MonoLabel extends StatelessWidget {
  const _MonoLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: _PortfolioColors.muted,
        fontFamily: 'monospace',
        fontSize: 10,
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: _PortfolioColors.cardRaised,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, size: 7, color: _PortfolioColors.secondary),
          const SizedBox(width: 7),
          _MonoLabel(label),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onTap,
      backgroundColor: _PortfolioColors.card,
      side: BorderSide.none,
      label: Text(
        '$label  ↗',
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 10,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: _PortfolioColors.subtle,
                fontSize: 12,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(color: valueColor, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: _PortfolioColors.cardHighest,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: _PortfolioColors.secondary,
          fontFamily: 'monospace',
          fontSize: 9,
        ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: _PortfolioColors.cardHighest,
      child: Center(
        child: Icon(Icons.image_outlined, color: _PortfolioColors.subtle),
      ),
    );
  }
}
