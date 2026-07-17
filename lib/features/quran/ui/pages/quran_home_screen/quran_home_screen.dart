import 'package:quran_library/quran.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class QuranHomeScreen extends StatefulWidget {
  const QuranHomeScreen({super.key});

  @override
  State<QuranHomeScreen> createState() => _QuranHomeScreenState();
}

class _QuranHomeScreenState extends State<QuranHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RxBool isSearching = false.obs;
  final RxString searchQuery = "".obs;
  final TextEditingController _searchFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2); // Default to bookmarks tab like in screenshot
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = AppColors.getBackgroundColor(isDark);
    final Color textColor = AppColors.getTextColor(isDark);
    final Color accentColor = Theme.of(context).colorScheme.primary;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: const Color(0xff1A1A1A),
          elevation: 0,
          title: Obx(() {
            if (isSearching.value) {
              return TextField(
                controller: _searchFieldController,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontFamily: 'cairo'),
                decoration: const InputDecoration(
                  hintText: 'بحث في السور، الآيات...',
                  hintStyle: TextStyle(color: Colors.grey, fontFamily: 'cairo'),
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  searchQuery.value = val;
                },
              );
            } else {
              return Text(
                'قرآن',
                style: QuranLibrary().cairoStyle.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
              );
            }
          }),
          actions: [
            Obx(() {
              if (isSearching.value) {
                return IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    isSearching.value = false;
                    searchQuery.value = "";
                    _searchFieldController.clear();
                  },
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    isSearching.value = true;
                  },
                );
              }
            }),
            IconButton(
              icon: const Icon(Icons.book, color: Colors.white),
              onPressed: () {
                // Navigate to last read page immediately
                final last = QuranCtrl.instance.lastPage;
                _navigateToPage(context, last);
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: accentColor,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelStyle: QuranLibrary().cairoStyle.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
            unselectedLabelStyle: QuranLibrary().cairoStyle.copyWith(
                  fontSize: 15,
                ),
            tabs: const [
              Tab(text: 'المرجعيات'),
              Tab(text: 'الجزء'),
              Tab(text: 'سورة'),
            ],
          ),
        ),
        body: GetBuilder<QuranCtrl>(
          builder: (quranCtrl) {
            if (quranCtrl.state.allAyahs.isEmpty || quranCtrl.surahs.isEmpty) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            return TabBarView(
              controller: _tabController,
              children: [
                _buildBookmarksTab(context, isDark, textColor, accentColor),
                _buildJuzTab(context, quranCtrl, isDark, textColor, accentColor),
                _buildSurahTab(context, quranCtrl, isDark, textColor, accentColor),
              ],
            );
          },
        ),
      ),
    );
  }

  // ---------------- TAB 1: SURAH & JUZ INDEX ----------------
  Widget _buildSurahTab(
    BuildContext context,
    QuranCtrl quranCtrl,
    bool isDark,
    Color textColor,
    Color accentColor,
  ) {
    // Generate chronological index items
    final List<_IndexItem> indexItems = [];

    // Add Juz's
    for (int j = 1; j <= 30; j++) {
      final startPage = quranCtrl.getJuzStartPage(j).page;
      indexItems.add(_IndexItem(pageNumber: startPage, juzNumber: j));
    }

    // Add Surahs
    for (int s = 1; s <= 114; s++) {
      final startPage = quranCtrl.surahs[s - 1].ayahs.first.page;
      indexItems.add(_IndexItem(pageNumber: startPage, surah: quranCtrl.surahsList[s - 1]));
    }

    // Sort chronologically
    indexItems.sort((a, b) {
      if (a.pageNumber != b.pageNumber) {
        return a.pageNumber.compareTo(b.pageNumber);
      }
      if (a.juzNumber != null && b.surah != null) return -1;
      if (a.surah != null && b.juzNumber != null) return 1;
      return 0;
    });

    return Obx(() {
      final query = searchQuery.value.trim().toLowerCase();
      List<_IndexItem> filtered = indexItems;

      if (query.isNotEmpty) {
        // When searching, omit Juz' headers and only search Surahs
        filtered = indexItems.where((item) {
          if (item.surah == null) return false;
          final nameAr = item.surah!.name.toLowerCase();
          final nameEn = item.surah!.englishName.toLowerCase();
          return nameAr.contains(query) || nameEn.contains(query);
        }).toList();
      }

      return ListView.separated(
        itemCount: filtered.length,
        separatorBuilder: (context, index) {
          final item = filtered[index];
          if (item.juzNumber != null) return const SizedBox.shrink();
          return Divider(color: Colors.grey.withValues(alpha: 0.1), height: 1);
        },
        itemBuilder: (context, index) {
          final item = filtered[index];

          if (item.juzNumber != null) {
            // Juz' Header row
            return Container(
              color: const Color(0xff2A2A2A),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الجزء ${item.juzNumber}'.convertNumbersAccordingToLang(),
                    style: QuranLibrary().cairoStyle.copyWith(
                          color: const Color(0xffa27b5c),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                  ),
                  Text(
                    '${item.pageNumber}'.convertNumbersAccordingToLang(),
                    style: QuranLibrary().cairoStyle.copyWith(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                  ),
                ],
              ),
            );
          } else {
            // Surah Row
            final surah = item.surah!;
            final isMeccan = surah.revelationType.toLowerCase().contains('meccan');
            final typeText = isMeccan ? 'مكية' : 'مدنية';
            final ayahsWord = (surah.ayahsNumber >= 3 && surah.ayahsNumber <= 10) ? 'آيات' : 'آية';

            return ListTile(
              leading: Text(
                '${surah.number}'.convertNumbersAccordingToLang(),
                style: QuranLibrary().cairoStyle.copyWith(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
              ),
              title: Text(
                surah.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                '$typeText - ${surah.ayahsNumber} $ayahsWord'.convertNumbersAccordingToLang(),
                style: QuranLibrary().cairoStyle.copyWith(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
              ),
              trailing: Text(
                '${item.pageNumber}'.convertNumbersAccordingToLang(),
                style: QuranLibrary().cairoStyle.copyWith(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
              ),
              onTap: () {
                _navigateToPage(context, item.pageNumber);
              },
            );
          }
        },
      );
    });
  }

  // ---------------- TAB 2: JUZ & HIZB QUARTERS ----------------
  Widget _buildJuzTab(
    BuildContext context,
    QuranCtrl quranCtrl,
    bool isDark,
    Color textColor,
    Color accentColor,
  ) {
    // Generate Juz' groups with Hizb quarters
    final List<_JuzHizbGroup> groups = [];

    for (int j = 1; j <= 30; j++) {
      final List<_HizbQuarterItem> quarters = [];
      final qStart = (j - 1) * 8 + 1;
      final qEnd = (j - 1) * 8 + 8;

      for (int q = qStart; q <= qEnd; q++) {
        final startAyah = quranCtrl.getHizbStartPage(q);
        if (startAyah.page != -1) {
          quarters.add(_HizbQuarterItem(
            quarterIndex: q,
            ayah: startAyah,
            pageNumber: startAyah.page,
          ));
        }
      }

      groups.add(_JuzHizbGroup(juzNumber: j, quarters: quarters));
    }

    return Obx(() {
      final query = searchQuery.value.trim().toLowerCase();
      List<_JuzHizbGroup> filtered = groups;

      if (query.isNotEmpty) {
        filtered = groups.map((g) {
          final matchingQuarters = g.quarters.where((q) {
            final text = q.ayah.text.toLowerCase();
            final surahName = (quranCtrl.surahsList[q.ayah.surahNumber! - 1].name).toLowerCase();
            return text.contains(query) || surahName.contains(query);
          }).toList();
          return _JuzHizbGroup(juzNumber: g.juzNumber, quarters: matchingQuarters);
        }).where((g) => g.quarters.isNotEmpty).toList();
      }

      return ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final group = filtered[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Juz' Section Header
              Container(
                width: double.infinity,
                color: const Color(0xff2A2A2A),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'الجزء ${group.juzNumber}'.convertNumbersAccordingToLang(),
                  style: QuranLibrary().cairoStyle.copyWith(
                        color: const Color(0xffa27b5c),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                ),
              ),

              // Hizb Quarters
              ...group.quarters.map((q) {
                // Ayah text snippet
                String snippet = q.ayah.text.trim();
                // Clean extra line breaks or spaces
                snippet = snippet.replaceAll('\n', ' ');
                // Take first 5-6 words
                final words = snippet.split(' ');
                if (words.length > 5) {
                  snippet = '${words.sublist(0, 5).join(' ')}...';
                }

                final surahName = quranCtrl.surahsList[q.ayah.surahNumber! - 1].name;

                return ListTile(
                  leading: Text(
                    '${q.pageNumber}'.convertNumbersAccordingToLang(),
                    style: QuranLibrary().cairoStyle.copyWith(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                  ),
                  title: Text(
                    snippet,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'cairo',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '$surahName، آية ${q.ayah.ayahNumber}'.convertNumbersAccordingToLang(),
                    style: QuranLibrary().cairoStyle.copyWith(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                  ),
                  trailing: HizbQuarterIcon(quarterIndex: q.quarterIndex),
                  onTap: () {
                    _navigateToPage(context, q.pageNumber);
                  },
                );
              }),
            ],
          );
        },
      );
    });
  }

  // ---------------- TAB 3: BOOKMARKS & RECENT READS ----------------
  Widget _buildBookmarksTab(
    BuildContext context,
    bool isDark,
    Color textColor,
    Color accentColor,
  ) {
    return GetBuilder<BookmarksCtrl>(
      id: 'bookmarks',
      builder: (bmCtrl) {
        final storage = GetStorage();

        // 1. Last Read history list
        final List<dynamic> rawRecents = storage.read<List<dynamic>>('recent_pages') ?? [];
        final List<int> recents = List<int>.from(rawRecents);

        // 2. Bookmarked pages list
        final List<int> bookmarkedPages = bmCtrl.bookmarkedPages;

        // 3. Bookmarked verses list
        final List<BookmarkModel> bookmarkedVerses =
            bmCtrl.bookmarks.values.expand((list) => list).toList();

        return Obx(() {
          final query = searchQuery.value.trim().toLowerCase();

          List<int> filteredRecents = recents;
          List<int> filteredPages = bookmarkedPages;
          List<BookmarkModel> filteredVerses = bookmarkedVerses;

          if (query.isNotEmpty) {
            final quranCtrl = QuranCtrl.instance;
            filteredRecents = recents.where((page) {
              final surah = quranCtrl.getSurahsByPageNumber(page);
              return surah.any((s) => s.arabicName.toLowerCase().contains(query));
            }).toList();

            filteredPages = bookmarkedPages.where((page) {
              final surah = quranCtrl.getSurahsByPageNumber(page);
              return surah.any((s) => s.arabicName.toLowerCase().contains(query));
            }).toList();

            filteredVerses = bookmarkedVerses.where((b) {
              final text = quranCtrl.getAyahByUq(b.ayahId).text.toLowerCase();
              return text.contains(query) || b.name.toLowerCase().contains(query);
            }).toList();
          }

          final hasContent = filteredRecents.isNotEmpty || filteredPages.isNotEmpty || filteredVerses.isNotEmpty;

          if (!hasContent) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.bookmark_border,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'لا توجد مرجعيات حالية',
                      style: QuranLibrary().cairoStyle.copyWith(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView(
            children: [
              // 1. آخر المتصفحات (Recent Reads)
              if (filteredRecents.isNotEmpty) ...[
                _buildSectionHeader('آخر المتصفحات'),
                ...filteredRecents.map((page) => _buildRecentItem(context, page)),
              ],

              // 2. مرجعيات الصفحات (Page Bookmarks)
              if (filteredPages.isNotEmpty) ...[
                _buildSectionHeader('مرجعيات الصفحات'),
                ...filteredPages.map((page) => _buildPageBookmarkItem(context, page, bmCtrl)),
              ],

              // 3. مرجعيات الآيات (Ayah Bookmarks)
              if (filteredVerses.isNotEmpty) ...[
                _buildSectionHeader('مرجعيات الآيات'),
                ...filteredVerses.map((bookmark) => _buildAyahBookmarkItem(context, bookmark, bmCtrl)),
              ],
            ],
          );
        });
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      color: const Color(0xff2A2A2A),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: QuranLibrary().cairoStyle.copyWith(
              color: const Color(0xffa27b5c),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
      ),
    );
  }

  Widget _buildRecentItem(BuildContext context, int page) {
    final quranCtrl = QuranCtrl.instance;
    final firstAyah = quranCtrl.getJuzByPage(page - 1);
    final surahName = firstAyah.surahNumber != null && firstAyah.surahNumber! > 0
        ? quranCtrl.surahsList[firstAyah.surahNumber! - 1].name
        : 'سورة';

    return ListTile(
      leading: Text(
        '$page'.convertNumbersAccordingToLang(),
        style: QuranLibrary().cairoStyle.copyWith(
              color: Colors.grey,
              fontSize: 16,
            ),
      ),
      title: Text(
        surahName,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'cairo',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        'صفحة $page، جزء ${firstAyah.juz}'.convertNumbersAccordingToLang(),
        style: QuranLibrary().cairoStyle.copyWith(
              color: Colors.grey,
              fontSize: 12,
            ),
      ),
      trailing: const Icon(Icons.book, color: Colors.grey),
      onTap: () {
        _navigateToPage(context, page);
      },
    );
  }

  Widget _buildPageBookmarkItem(BuildContext context, int page, BookmarksCtrl bmCtrl) {
    final quranCtrl = QuranCtrl.instance;
    final firstAyah = quranCtrl.getJuzByPage(page - 1);
    final surahName = firstAyah.surahNumber != null && firstAyah.surahNumber! > 0
        ? quranCtrl.surahsList[firstAyah.surahNumber! - 1].name
        : 'سورة';

    return ListTile(
      leading: Text(
        '$page'.convertNumbersAccordingToLang(),
        style: QuranLibrary().cairoStyle.copyWith(
              color: Colors.grey,
              fontSize: 16,
            ),
      ),
      title: Text(
        surahName,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'cairo',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        'صفحة $page، جزء ${firstAyah.juz}'.convertNumbersAccordingToLang(),
        style: QuranLibrary().cairoStyle.copyWith(
              color: Colors.grey,
              fontSize: 12,
            ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.bookmark, color: Color(0xffa27b5c)),
        onPressed: () {
          bmCtrl.togglePageBookmark(page);
        },
      ),
      onTap: () {
        _navigateToPage(context, page);
      },
    );
  }

  Widget _buildAyahBookmarkItem(BuildContext context, BookmarkModel bookmark, BookmarksCtrl bmCtrl) {
    final quranCtrl = QuranCtrl.instance;
    final ayah = quranCtrl.getAyahByUq(bookmark.ayahId);

    // Clean and truncate text snippet
    String snippet = ayah.text.trim();
    snippet = snippet.replaceAll('\n', ' ');
    final words = snippet.split(' ');
    if (words.length > 5) {
      snippet = '${words.sublist(0, 5).join(' ')}...';
    }

    return ListTile(
      leading: Text(
        '${bookmark.page}'.convertNumbersAccordingToLang(),
        style: QuranLibrary().cairoStyle.copyWith(
              color: Colors.grey,
              fontSize: 16,
            ),
      ),
      title: Text(
        snippet,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'cairo',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        'سورة ${bookmark.name} - آية ${bookmark.ayahNumber}، جزء ${ayah.juz}'.convertNumbersAccordingToLang(),
        style: QuranLibrary().cairoStyle.copyWith(
              color: Colors.grey,
              fontSize: 12,
            ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.bookmark, color: Color(bookmark.colorCode)),
        onPressed: () {
          bmCtrl.removeBookmark(bookmark.id);
        },
      ),
      onTap: () {
        _navigateToPage(context, bookmark.page);
      },
    );
  }

  // ---------------- PAGE NAVIGATION HELPER ----------------
  void _navigateToPage(BuildContext context, int pageNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: QuranLibraryScreen(
            parentContext: context,
            isDark: true,
            pageIndex: pageNumber - 1,
            topBarStyle: QuranTopBarStyle.defaults(isDark: true, context: context).copyWith(
              showBackButton: true,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- STRUCTURAL HELPER CLASSES ----------------
class _IndexItem {
  final int pageNumber;
  final SurahNamesModel? surah;
  final int? juzNumber;

  _IndexItem({required this.pageNumber, this.surah, this.juzNumber});
}

class _JuzHizbGroup {
  final int juzNumber;
  final List<_HizbQuarterItem> quarters;

  _JuzHizbGroup({required this.juzNumber, required this.quarters});
}

class _HizbQuarterItem {
  final int quarterIndex;
  final AyahModel ayah;
  final int pageNumber;

  _HizbQuarterItem({
    required this.quarterIndex,
    required this.ayah,
    required this.pageNumber,
  });
}

// ---------------- CUSTOM HIZB QUARTER ICON PAINTER ----------------
class HizbQuarterIcon extends StatelessWidget {
  final int quarterIndex;

  const HizbQuarterIcon({super.key, required this.quarterIndex});

  @override
  Widget build(BuildContext context) {
    final int position = (quarterIndex - 1) % 4; // 0, 1, 2, 3
    final int hizbNumber = (quarterIndex - 1) ~/ 4 + 1;

    if (position == 0) {
      return Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: Color(0xff9ed5cb),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '$hizbNumber'.convertNumbersAccordingToLang(),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            fontFamily: 'cairo',
          ),
        ),
      );
    } else {
      return SizedBox(
        width: 32,
        height: 32,
        child: CustomPaint(
          painter: _HizbPiePainter(position: position),
        ),
      );
    }
  }
}

class _HizbPiePainter extends CustomPainter {
  final int position;

  _HizbPiePainter({required this.position});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw background circle
    final bgPaint = Paint()
      ..color = const Color(0xff333333)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Draw filled arc
    final fillPaint = Paint()
      ..color = const Color(0xff9ed5cb)
      ..style = PaintingStyle.fill;

    // Start angle: -pi / 2 (12 o'clock).
    // Sweep angle: position * pi / 2.
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      position * math.pi / 2,
      true,
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _HizbPiePainter oldDelegate) {
    return oldDelegate.position != position;
  }
}
