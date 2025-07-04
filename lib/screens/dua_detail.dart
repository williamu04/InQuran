import 'package:flutter/material.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';

class DuaDetailScreen extends StatelessWidget {
  final CategoryDua category;

  const DuaDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Dua>>(
        future: AppDatabase().duasDao.getDuasByCategory(category.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          final duas = snapshot.data ?? [];

          if (duas.isEmpty) {
            return const Center(
              child: Text('Belum ada doa untuk kategori ini.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: duas.length,
            itemBuilder: (context, index) {
              final dua = duas[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        dua.doaArab,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Arab Typesetting',
                          color: Color(0xFF3B1D77),
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Divider(color: Color(0xFF994EF8), thickness: 0.8),
                    const SizedBox(height: 12),
                    Text(
                      dua.doaIndo,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF3B1D77),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
