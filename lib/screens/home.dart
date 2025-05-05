import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child : Column(
        children: [
          homeTitle(),
          homeMenu()
        ],

      ),
    );
  }
}

Widget homeMenu() {
  // List of menu items
  final List<String> menuItems = [
    'The Holy Quran',
    'Duas Collection',
    'Prayer Times',
    'Prayer Qibla',
    'Favourites',
    'Etc',
    'Etc',
  ];

  return Container(
    padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 55.0, bottom: 38.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Full-width button for the first item
        ElevatedButton(
          onPressed: () {
            print('${menuItems[0]} pressed');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF672CBC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: EdgeInsets.zero, // Important: to control padding
          ),
          child: Container(
            height: 60.0,
            padding: const EdgeInsets.symmetric(horizontal: 14.0), // Outer padding
            child: Row(
              mainAxisSize: MainAxisSize.min, // Important: to prevent Row from expanding full width
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.book,
                  color: Colors.white,
                  size: 24.0,
                ),
                const SizedBox(width: 10.0), // Reduced spacing between icon and text
                Expanded(
                  child: Text(
                    menuItems[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Plus Jakarta',
                    ),
                    overflow: TextOverflow.ellipsis, // Allow text to wrap
                    softWrap: false, // Enable wrapping to the next line
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        // Grid for the remaining items
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 2.5,
          ),
          itemCount: menuItems.length - 1,
          itemBuilder: (context, index) {
            // Calculate row index (0-based) for the grid items
            int rowIndex = index ~/ 2 + 1;
            Color buttonColor = rowIndex % 2 == 0
                ? const Color(0xFF672CBC)
                : const Color(0xFF3B1D77);

            return ElevatedButton(
            onPressed: () {
              print('${menuItems[index + 1]} pressed');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: EdgeInsets.zero, // penting agar kita kontrol penuh padding
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14.0), // padding luar
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, // untuk vertikal center
                children: [
                  const Icon(
                    Icons.book,
                    color: Colors.white,
                    size: 24.0,
                  ),
                  const SizedBox(width: 10.0), // jarak dari icon ke teks
                  Expanded( // biar teks isi sisa ruang
                    child: Text(
                      menuItems[index + 1],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Plus Jakarta',
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
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
  return Flexible(
    child: Container(
    ),
  );
}
