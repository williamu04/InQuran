import 'package:flutter/material.dart';
import 'package:inquran/common/app_color.dart';
import 'package:inquran/common/navigation.dart';
import 'package:inquran/components/ayah_search_box.dart';
import 'package:inquran/components/rounded_card.dart';
import 'package:inquran/components/tab_button.dart';
import 'package:inquran/components/top_bar_utils.dart';
import 'package:inquran/data/aggregate/surah.dart';
import 'package:inquran/services/ayah_search.dart';
import 'package:inquran/state/search.dart';
import 'package:inquran/viewmodel/search.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      namesRoute: true,
      label: 'Jelajahi',
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            TopBarUtility.buildPurpleTitleTopbar(
              context: context,
              title: "Jelajahi",
            ),
            const SizedBox(height: 10),
            AyahSearchBox(
              onChanged:
                  (query) => context.read<SearchViewModel>().updateQuery(query),
            ),
            const SizedBox(height: 20),
            const _ModeToggle(),
            Expanded(
              child: Consumer<SearchViewModel>(
                builder: (context, vm, _) {
                  return switch (vm.state) {
                    SearchIdle() => const _IdleHint(),
                    SearchLoading() => Semantics(
                      liveRegion: true,
                      label: 'Mencari ayat',
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    SearchEmpty(:final query) => Semantics(
                      liveRegion: true,
                      child: _Message(
                        text: 'Tidak ada ayat yang cocok dengan "$query"',
                      ),
                    ),
                    SearchError(:final message) => Semantics(
                      liveRegion: true,
                      child: _Message(text: "Terjadi kesalahan: $message"),
                    ),
                    SearchLoaded(
                      :final results,
                      :final totalCount,
                      :final highlightTerms,
                    ) =>
                      _ResultList(
                        results: results,
                        totalCount: totalCount,
                        highlightTerms: highlightTerms,
                      ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewModel>();

    return Row(
      children: [
        Expanded(
          child: TabButton(
            label: 'Spesifik',
            isActive: vm.mode == SearchMode.specific,
            onTap:
                () => context.read<SearchViewModel>().setMode(
                  SearchMode.specific,
                ),
          ),
        ),
        Expanded(
          child: TabButton(
            label: 'Pendekatan',
            isActive: vm.mode == SearchMode.approach,
            onTap:
                () => context.read<SearchViewModel>().setMode(
                  SearchMode.approach,
                ),
          ),
        ),
      ],
    );
  }
}

class _IdleHint extends StatelessWidget {
  const _IdleHint();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(8, 24, 8, 100),
      children: [
        // _ModeInfo(
        //   title: "Spesifik",
        //   description:
        //       "Semua kata harus muncul berurutan persis seperti yang ditulis.",
        //   example: 'Contoh: "aku dan kamu"',
        // ),
        // _ModeInfo(
        //   title: "Pendekatan",
        //   description: "Semua kata harus muncul di ayat, dengan urutan bebas.",
        //   example: 'Contoh: "aku kamu"',
        // ),
        const SizedBox(height: 10),
        const Text(
          "Ketik kata kunci di kotak pencarian di atas untuk mulai mencari isi ayat.",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }
}

/// Static explanation of a search mode. Mode switching happens in
/// `_ModeToggle` above the results — this is informational only.
class _ModeInfo extends StatelessWidget {
  final String title;
  final String description;
  final String example;

  const _ModeInfo({
    required this.title,
    required this.description,
    required this.example,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              example,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultList extends StatelessWidget {
  final List<AyahWithSurah> results;
  final int totalCount;
  final List<String> highlightTerms;

  const _ResultList({
    required this.results,
    required this.totalCount,
    required this.highlightTerms,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (results.length < totalCount)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Semantics(
              label: 'Menampilkan ${results.length} dari $totalCount hasil',
              child: Text(
                "Menampilkan ${results.length} dari $totalCount hasil",
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 90,
              left: 8,
              right: 8,
            ),
            itemCount: results.length,
            itemBuilder:
                (_, i) => _AyahResultCard(
                  ayah: results[i],
                  highlightTerms: highlightTerms,
                ),
          ),
        ),
      ],
    );
  }
}

class _AyahResultCard extends StatelessWidget {
  final AyahWithSurah ayah;
  final List<String> highlightTerms;

  const _AyahResultCard({required this.ayah, required this.highlightTerms});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label:
          'Hasil pencarian: ${ayah.ayah.indoText}. Surah ${ayah.surah.nameLatin}, ayat ${ayah.ayah.ayahNumber}',
      hint: 'Ketuk dua kali untuk membuka ayat',
      excludeSemantics: true,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 4,
        child: InkWell(
          onTap: () => navigateToAyah(context, ayah),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExcludeSemantics(
                  child: Text(
                    ayah.ayah.ayahText,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 30,
                      fontFamily: 'Arab Typesetting',
                      color: AppColors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(color: AppColors.primaryLight, thickness: 1),
                const SizedBox(height: 8),
                _HighlightedText(
                  text: ayah.ayah.indoText,
                  terms: highlightTerms,
                ),
                const SizedBox(height: 8),
                Text(
                  "[QS ${ayah.surah.nameLatin} : ${ayah.ayah.ayahNumber}]",
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
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

class _HighlightedText extends StatelessWidget {
  final String text;
  final List<String> terms;

  const _HighlightedText({required this.text, required this.terms});

  @override
  Widget build(BuildContext context) {
    final service = context.read<AyahSearchService>();
    final ranges = service.findHighlightRanges(text, terms);

    final spans = <TextSpan>[];
    var cursor = 0;
    for (final range in ranges) {
      if (range.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, range.start)));
      }
      spans.add(
        TextSpan(
          text: text.substring(range.start, range.end),
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      );
      cursor = range.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }

    return Text.rich(
      TextSpan(
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.textPrimary,
          height: 1.6,
        ),
        children: spans,
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final String text;

  const _Message({required this.text});

  @override
  Widget build(BuildContext context) =>
      Center(child: Text(text, textAlign: TextAlign.center));
}
