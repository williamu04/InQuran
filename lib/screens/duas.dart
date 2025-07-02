import 'package:flutter/material.dart';
import 'package:mtqmnuns/components/rounded_card.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';

class DuasScreen extends StatefulWidget {
  const DuasScreen({super.key});

  @override
  State<DuasScreen> createState() => _DuasScreenState();
}

class _DuasScreenState extends State<DuasScreen> {
  late final AppDatabase _db;
  late Future<List<Dua>> _futureDuas;

  @override
  void initState() {
    super.initState();
    _db = AppDatabase(); // langsung inisialisasi database
    _futureDuas = _db.duasDao.getAllDuas(); // ambil data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Dua>>(
        future: _futureDuas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada doa.'));
          }

          final duas = snapshot.data!;

          return Column(
            children: [
              RoundedCard(
                child: const Text("Doa-doa Harian"), // replace with actual text
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: duas.length,
                  itemBuilder: (context, index) {
                    final dua = duas[index];
                    return ListTile(
                      title: Text(dua.title),
                      subtitle: Text(dua.doaIndo),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(dua.title),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Arab:\n${dua.doaArab}', textAlign: TextAlign.right),
                                const SizedBox(height: 8),
                                Text('Latin:\n${dua.doaLatin}'),
                                const SizedBox(height: 8),
                                Text('Arti:\n${dua.doaIndo}'),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
