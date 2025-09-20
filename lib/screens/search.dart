import 'package:flutter/material.dart';
import 'package:mtqmnuns/common/top_bar_utils.dart';
import 'package:mtqmnuns/components/rounded_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  Widget _buildChip(String label, {Color? color, Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (color == null)
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor ?? const Color(0xFF672CBC),
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    String title,
    String subtitle,
    List<String> chips, {
    Color? etcColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: roundedCard(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        borderRadius: 20,
        gradient: const LinearGradient(
          colors: [Color(0xFF863ED5), Color(0xFF240F4F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        allRounded: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              children: [
                ...chips.map((chip) => _buildChip(chip)),
                _buildChip(
                  'Lainnya',
                  color: etcColor ?? const Color(0xFF672CBC),
                  textColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FE),
      body: Column(
        children: [
          // Fixed Gradient Top Section
          roundedCard(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 24
            ),
            child: Column(
              children: [
                TopBarUtility.buildDefaultTopBar(context:context, title: "Jelajahi"),  
                // Top bar spacing
                const SizedBox(height: 10),
                // Info Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF672CBC),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Al-Qur\'an dan Hadits',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11
                          ),
                        ),
                        TextSpan(
                          text: ' Sumber Petunjuk dalam Kehidupan!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 11
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          // Scrollable Category Cards
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    _buildCategoryCard(
                      'Dasar-Dasar Islam',
                      'Akidah dan Ibadah',
                      [
                        'Rukun Islam',
                        'Asmaul Husna',
                        'Taubat',
                        'Akhlak & Adab',
                      ],
                    ),
                    _buildCategoryCard('Sosial & Etika', 'Pedoman Hidup', [
                      'Hubungan Antar Manusia',
                      'Muamalah & Perdagangan',
                      'Pakaian Islami',
                      'Keadilan',
                      'Makanan Halal',
                      'Pernikahan',
                      'Peran Perempuan',
                    ]),
                    _buildCategoryCard(
                      "Hakikat Kehidupan",
                      'dan Akhirat',
                      [
                        'Ilmu & Sains',
                        'Kehidupan Akhirat',
                        'Kematian',
                        'Alam Ghaib',
                      ],
                      // etcColor: const Color(0xFF240F4F),
                    ),
                    const SizedBox(height: 32),
                    // Add bottom padding to account for bottom navigation bar
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
