import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/config/route.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 115),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            homeTitle(),
            homeMenu(
              context: context,
              menuItems: AppRoutes.homeMenu,
            ),
          ],
        ),
      ),
    );
  }
}

Widget homeMenu({
  required BuildContext context,
  required List<AppRouteConfig> menuItems,
}) {
  return Container(
    padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 40),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (menuItems.isNotEmpty)
          ElevatedButton(
            onPressed: () {
              if (menuItems[0].path.isNotEmpty) {
                context.go(menuItems[0].path);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF672CBC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Container(
              height: 60.0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      menuItems[0].icon,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    const SizedBox(width: 10.0),
                    Flexible(
                      child: Text(
                        menuItems[0].text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Plus Jakarta',
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(height: 16.0),
        // Grid untuk item-item menu berikutnya
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 2.5,
          ),
          itemCount: menuItems.length - 1,
          itemBuilder: (context, index) {
            int rowIndex = index ~/ 2 + 1;
            Color buttonColor = rowIndex % 2 == 0
                ? const Color(0xFF672CBC)
                : const Color(0xFF3B1D77);

            final item = menuItems[index + 1];
            return ElevatedButton(
              onPressed: () {
                if (item.path.isNotEmpty) {
                  context.go(item.path);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      item.icon,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Text(
                        item.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Plus Jakarta',
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}

Widget homeTitle() {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.only(top: 80, left: 40, right: 40, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF863ED5), Color(0xFF240F4F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/logo.png',
                height: 40, // Perkecil ukuran logo
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Assalamu’alaikum',
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Plus Jakarta',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Sebelas Maret',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Plus Jakarta',
                        fontSize: 20, // Perkecil ukuran teks
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Garis horizontal
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.white38,
          ),

          const SizedBox(height: 24), // Perkecil jarak

          // Ayat dan terjemahan
          const Center(
            child: Text(
              'إِنَّ الَّذِينَ آمَنُوا وَعَمِلُوا '
              'الصَّالِحَاتِ سَيَجْعَلُ لَهُمُ الرَّحْمَٰنُ وُدًّا',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16, // Perkecil ukuran teks
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.4, // Tinggi baris untuk estetika
              ),
            ),
          ),
          const SizedBox(height: 8), // Perkecil jarak
          const Center(
            child: Text(
              '“Indeed, those who have believed and done righteous deeds - '
              'the Most Merciful will appoint for them affection.”',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta',
                fontSize: 10, // Perkecil ukuran teks
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
                color: Color(0xFF994EF8),
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 8), // Perkecil jarak
          const Center(
            child: Text(
              'Thaha : 96',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta',
                fontSize: 10,
                fontStyle: FontStyle.italic,
                color: Color(0xFF994EF8),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

