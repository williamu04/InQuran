import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/components/error_popup.dart';
import 'package:mtqmnuns/components/popup_modal.dart';
import 'package:mtqmnuns/dto/favorites.dart';
import 'package:mtqmnuns/dto/surah.dart';
import 'package:mtqmnuns/routes/route.dart';
import 'package:mtqmnuns/state/favorites.dart';
import 'package:mtqmnuns/state/success_or_fail.dart';
import 'package:mtqmnuns/state/surah.dart';
import 'package:mtqmnuns/state/user.dart';
import 'package:mtqmnuns/viewmodel/favorites.dart';
import 'package:mtqmnuns/viewmodel/surah.dart';
import 'package:mtqmnuns/viewmodel/toggleable.dart';
import 'package:mtqmnuns/viewmodel/user.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class NormalSurahScreen extends StatefulWidget {
  final LoadType loadType;
  final bool memorize;
  const NormalSurahScreen({
    super.key,
    required this.loadType,
    this.memorize = false,
  });

  @override
  State<NormalSurahScreen> createState() => _NormalSurahScreenState();
}

class _NormalSurahScreenState extends State<NormalSurahScreen>
    with SingleTickerProviderStateMixin {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ErrorPopUpController errorController = ErrorPopUpController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  bool _isTopLoading = false;
  bool _isBottomLoading = false;
  bool _hasShownPopup = false;

  late AnimationController _bounceController;
  double _pullDistance = 0.0;
  bool _isReadyToRefresh = false;
  static const double _maxPullDistance = 120.0;
  static const double _triggerDistance = 80.0;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesViewModel>().getAllFavorites();
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _loadTop(SurahViewModel vm) {
    if (_isTopLoading) return;

    setState(() => _isTopLoading = true);
    _bounceController.forward();

    switch (widget.loadType) {
      case LoadType.surah:
        vm.prependBySurah();
        break;
      case LoadType.juz:
        vm.prependByJuz();
        break;
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetPullAnimation();
    });
  }

  Future<void> _loadBottom(SurahViewModel vm) async {
    if (_isBottomLoading) return;
    setState(() => _isBottomLoading = true);

    switch (widget.loadType) {
      case LoadType.surah:
        vm.appendBySurah();
        break;
      case LoadType.juz:
        vm.appendByJuz();
        break;
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetPullAnimation();
    });
  }

  Future<void> _resetPullAnimation() async {
    await _bounceController.reverse();
    if (mounted) {
      setState(() {
        _pullDistance = 0.0;
        _isTopLoading = false;
        _isBottomLoading = false;
        _isReadyToRefresh = false;
      });
    }
  }

  bool _handleOverscroll(OverscrollNotification overscroll, SurahViewModel vm) {
    if (_isTopLoading || _isBottomLoading) return false;

    if (overscroll.metrics.pixels <= overscroll.metrics.minScrollExtent &&
        overscroll.overscroll < 0) {
      setState(() {
        _pullDistance = (_pullDistance - overscroll.overscroll).clamp(
          0,
          _maxPullDistance,
        );
        _isReadyToRefresh = _pullDistance >= _triggerDistance;
      });

      if (_isReadyToRefresh &&
          (_pullDistance - overscroll.overscroll.abs()) < _triggerDistance) {
        HapticFeedback.lightImpact();
      }

      if (overscroll.overscroll.abs() > 0) _loadTop(vm);
    }

    if (overscroll.metrics.pixels >= overscroll.metrics.maxScrollExtent &&
        overscroll.overscroll > 0) {
      _loadBottom(vm);
    }

    return false;
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildMainScreen(context),
        ErrorPopUpModal(
          title: "Error", 
          defaultSubtitle: "Terjadi Kesalhan Tidak Terduga", 
          buttonList: [
            ButtonModalModel(
              text: "Login", 
              onButtonPressed: () {
                context.replace(AppRoutes.login.path);
              },
            ),
            ButtonModalModel(
              text: "Kembali", 
              textColor: Colors.red,
              buttonColor: Colors.white,
              onButtonPressed: () {
                context.replace(AppRoutes.home.path);
                context.read<UserViewModel>().setState(UserLoadUnauthenticated());
              },
            )
          ],
          controller: errorController
          )

      ],
    );
  }

  Widget buildMainScreen(BuildContext context) {
    return Consumer<SurahViewModel>(
      builder: (context, vm, child) {
        final state = vm.state;

        switch (state) {
          case SurahLoading():
            return const Center(child: CircularProgressIndicator());
          case SurahError(:var message):
            return Center(child: Text("Error: $message"));
          case SurahSuccess(:var ayahs, :var warning, :var jumpIndex):
            if (!_hasShownPopup && warning != null) {
              _hasShownPopup = true;
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => errorPopup(context, warning),
              );
            }

            return NotificationListener<OverscrollNotification>(
              onNotification: (overscroll) => _handleOverscroll(overscroll, vm),
              child: ScrollablePositionedList.builder(
                key: ValueKey('${ayahs.hashCode}_${jumpIndex ?? 0}'),
                itemCount: ayahs.length + (_isBottomLoading ? 1 : 0),
                itemScrollController: _itemScrollController,
                itemPositionsListener: _itemPositionsListener,
                initialScrollIndex: jumpIndex ?? 0,
                initialAlignment: _isTopLoading || _isBottomLoading ? 0.05 : 0,
                itemBuilder: (context, index) {
                  if (_isBottomLoading && index == ayahs.length) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation(Color(0xFF672CBC)),
                        ),
                      ),
                    );
                  }
                  final ayah = ayahs[index];
                  return _buildAyahCard(
                    ayah,
                    padding:
                        index == ayahs.length - 1
                            ? EdgeInsets.only(bottom: 120)
                            : null,
                  );
                },
              ),
            );
        }
      },
    );
  }

  Widget _buildAyahCard(AyahWithSurahDto ayah, {EdgeInsets? padding}) {
    final key = '${ayah.surahNumber}_${ayah.number}';

    Widget ayahCardContent = Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 36),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F9FE),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF672CBC),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${ayah.number}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xff994EF8),
                    ),
                    child: Center(
                      child: Text(
                        'Juz ${ayah.juzNumber}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Consumer<SurahViewModel>(
                    builder: (context, vm, child) {
                      final currentState = vm.state;
                      if (currentState is! SurahSuccess)
                        return const SizedBox();

                      final isCurrentAyahPlaying =
                          currentState.playingIndex == ayah.number - 1 &&
                          currentState.isPlaying;
                      return _buildActionButton(
                        icon:
                            isCurrentAyahPlaying
                                ? Icon(
                                  LucideIcons.pause,
                                  size: 20,
                                  color: Color(0xFF672CBC),
                                )
                                : Icon(
                                  LucideIcons.play,
                                  size: 20,
                                  color: Color(0xFF672CBC),
                                ),
                        onPressed: () {
                          vm.togglePlayback(ayah.number - 1);
                        },
                      );
                    },
                  ),
                  _buildActionButton(
                    icon: Icon(
                      LucideIcons.share2,
                      size: 20,
                      color: Color(0xFF672CBC),
                    ),
                    onPressed: () {
                      final text =
                          'Surah ${ayah.nameLatin}, Ayat ${ayah.number}:\n\n'
                          '${ayah.arabText}\n\n${ayah.translationText}';
                      SharePlus.instance.share(ShareParams(text: text));
                    },
                  ),
                  Consumer<FavoritesViewModel>(
                    builder: (context, favVm, child) {
                      final state = favVm.state;

                      switch (state) {
                        case FavoritesLoadLoading():
                        case FavoritesLoadUnauthenticated():
                        case FavoritesLoadError():
                          return _buildActionButton(
                            icon: const Icon(
                              LucideIcons.heart,
                              size: 20,
                              color: Color(0xFF672CBC),
                            ),
                            onPressed: () {
                              if (state is FavoritesLoadUnauthenticated) {
                                errorController.open('Fitur ini memerlukan login, login terlebih dahulu?');
                              } else if (state is FavoritesLoadError) {
                                errorController.open('Error: ${state.message}');
                              }
                            },
                          );

                        case FavoritesLoaded(:final favorites):
                          final isFav = favorites.any((f) =>
                              f.surahNumber == ayah.surahNumber && f.ayahNumber == ayah.number);

                          return _buildActionButton(
                            icon: isFav
                                ? Image.asset(
                                    'assets/img/heart.png',
                                    height: 18,
                                    fit: BoxFit.contain,
                                  )
                                : const Icon(
                                    LucideIcons.heart,
                                    size: 20,
                                    color: Color(0xFF672CBC),
                                  ),
                            onPressed: () async {
                              final favorite = FavoriteDto(
                                ayah.surahNumber,
                                ayah.number,
                              );

                              if (isFav) {
                                final res = await favVm.deleteFavorite(favorite);
                                switch (res) {
                                  case Success():
                                    break;
                                  case Failure(:final reason):
                                    errorController.open(reason);
                                }
                              } else {
                                final res = await favVm.addFavorite(favorite);
                                switch (res) {
                                  case Success():
                                    break;
                                  case Failure(:final reason):
                                    errorController.open(reason);
                                }
                              }
                            },
                          );
                      }
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            AyahCard(
              arabText: ayah.arabText,
              translationText: ayah.translationText,
              isMemorizeMode: widget.memorize,
            ),
            Divider(color: Colors.grey.shade300, thickness: 1, height: 1),
          ],
        ),
      ),
    );

    // Wrap with header for the first ayah
    if (ayah.number == 1) {
      ayahCardContent = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: SurahHeaderCard(
              name: ayah.surahName,
              nameLatin: ayah.nameLatin,
              nameIndo: ayah.nameIndo,
              showBasmallah: ayah.surahNumber != 1 && ayah.surahNumber != 9,
            ),
          ),
          ayahCardContent,
        ],
      );
    }

    if (padding != null) {
      return Padding(padding: padding, child: ayahCardContent);
    }

    return ayahCardContent;
  }

  Widget _buildActionButton({
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Container(padding: const EdgeInsets.all(8), child: icon),
        ),
      ),
    );
  }
  
}

// ignore: must_be_immutable
class AyahCard extends StatefulWidget {
  final String arabText;
  final String translationText;
  final bool isMemorizeMode;
  late bool showArabic;

  AyahCard({
    super.key,
    required this.arabText,
    required this.translationText,
    required this.isMemorizeMode,
  }) {
    showArabic = isMemorizeMode ? false : true;
  }

  @override
  State<AyahCard> createState() => _AyahCardState();
}

class _AyahCardState extends State<AyahCard> {
  void _toggleArabic() {
    setState(() {
      widget.showArabic = !widget.showArabic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isMemorizeMode ? _toggleArabic : () => {},
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Visibility(
              visible: widget.showArabic,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  widget.arabText,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF3B1D77),
                    fontFamily: 'Arab Typesetting',
                    height: 1.8,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              widget.translationText,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF3B1D77),
                height: 1.6,
                letterSpacing: 0.2,
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class SurahHeaderCard extends StatelessWidget {
  final String nameLatin;
  final String name;
  final String nameIndo;
  final bool showBasmallah;

  const SurahHeaderCard({
    super.key,
    required this.nameLatin,
    required this.name,
    required this.nameIndo,
    this.showBasmallah = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.only(top: 80, left: 40, right: 40, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF994EF8), Color(0xFF240F4F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Row: Latin Name & Arabic Name
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Kolom: Latin + Indo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nameLatin,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      // const SizedBox(height: 4),
                      Text(
                        nameIndo,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Nama Arab
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    name,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'Al Jazeera',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(thickness: 0.5, color: Color(0xFF994EF8)),
            const SizedBox(height: 16),

            // Basmallah
            if (showBasmallah)
              Center(
                child: Image.asset(
                  'assets/img/basmala.png',
                  height: 64, // sesuaikan ukuran
                  fit: BoxFit.contain,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
