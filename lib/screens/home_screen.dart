import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../helpers/nav_helper.dart';
import '../models/news_model.dart';
import '../models/event_model.dart';
import '../models/category_model.dart';
import '../services/news_service.dart';
import '../services/event_service.dart';
import '../services/user_service.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/category_card.dart';
import '../models/notification_model.dart';
import '../helpers/notification_helper.dart';
import '../widgets/notification_bell.dart';
import '../widgets/news_detail_sheet.dart';
import '../widgets/event_detail_sheet.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  const HomeScreen({super.key, this.onToggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  // ─── Data from API ──────────────────────────
  List<NewsModel> _news = [];
  List<EventModel> _events = [];
  bool _isLoadingNews = true;
  bool _isLoadingEvents = true;
  String _userName = 'User';
  bool _isLoadingUser = true;

  // ─── Static categories (no API needed) ──────────
  final List<CategoryModel> _categories = const [
    CategoryModel(name: 'Courses', imageUrl: 'assets/images/course.png'),
    CategoryModel(name: 'Schedule', imageUrl: 'assets/images/schedule.png'),
    CategoryModel(name: 'Events', imageUrl: 'assets/images/events.png'),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
    _fetchData();
    // Load notifications from API
    NotificationHelper.ensureLoaded().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    await Future.wait([_fetchNews(), _fetchEvents(), _fetchUser()]);
  }

  Future<void> _fetchUser() async {
    try {
      final userProfile = await UserService.getProfile();
      if (mounted) {
        setState(() {
          final fullName = userProfile['name'] ?? 'User';
          _userName = fullName.split(' ').first; // Just first name
          _isLoadingUser = false;
        });
      }
    } catch (e) {
      debugPrint('Fetch user error: $e');
      if (mounted) setState(() => _isLoadingUser = false);
    }
  }

  Future<void> _fetchNews() async {
    try {
      final data = await NewsService.getNews(limit: 5);
      if (mounted) {
        setState(() {
          _news = data.map((json) => NewsModel.fromJson(json)).toList();
          _isLoadingNews = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingNews = false);
    }
  }

  Future<void> _fetchEvents() async {
    try {
      final data = await EventService.getEvents(limit: 5);
      if (mounted) {
        setState(() {
          _events = data.map((json) => EventModel.fromJson(json)).toList();
          _isLoadingEvents = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingEvents = false);
    }
  }

  Future<void> _refreshAll() async {
    await Future.wait([
      _fetchNews(),
      _fetchEvents(),
      _fetchUser(),
      NotificationHelper.fetch(),
    ]);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: RefreshIndicator(
            onRefresh: _refreshAll,
            color: AppTheme.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Greeting + Theme & Notification (SAME LINE) ───
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left: Greeting text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, $_userName 👋',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                            Text(
                              'Welcome Back!',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Right: Theme toggle + Notification bell side by side
                      GestureDetector(
                        onTap: widget.onToggleTheme,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.05),
                          ),
                          child: Icon(
                            isDark
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                            size: 22,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      NotificationBell(
                        notifications: NotificationHelper.notifications,
                        onNotificationTap: (notif) async {
                          await NotificationHelper.markAsRead(notif);
                          if (mounted) setState(() {});
                        },
                        onMarkAllRead: () async {
                          await NotificationHelper.markAllAsRead();
                          if (mounted) setState(() {});
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ─── Categories (3 items with asset images) ─
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index < _categories.length - 1 ? 14 : 0,
                          ),
                          child: CategoryCard(
                            category: _categories[index],
                            onTap: () {
                              switch (index) {
                                case 0: // Courses
                                  handleNavTap(
                                    context: context,
                                    currentIndex: 0,
                                    tappedIndex: 1,
                                    onToggleTheme: widget.onToggleTheme,
                                  );
                                  break;
                                case 1: // Schedule
                                  handleNavTap(
                                    context: context,
                                    currentIndex: 0,
                                    tappedIndex: 2,
                                    onToggleTheme: widget.onToggleTheme,
                                  );
                                  break;
                                case 2: // Events → Profile tab
                                  handleNavTap(
                                    context: context,
                                    currentIndex: 0,
                                    tappedIndex: 4,
                                    onToggleTheme: widget.onToggleTheme,
                                  );
                                  break;
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ─── News Section ─────────────────────
                  Row(
                    children: [
                      Text(
                        'Latest News',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  _isLoadingNews
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : _news.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              'No news yet',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.4),
                              ),
                            ),
                          ),
                        )
                      : Column(
                          children: _news
                              .map(
                                (article) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _NewsCard(news: article),
                                ),
                              )
                              .toList(),
                        ),

                  const SizedBox(height: 28),

                  // ─── Events Section ───────────────────
                  Row(
                    children: [
                      Text(
                        'Upcoming Events',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  _isLoadingEvents
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : _events.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              'No events yet',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.4),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _events.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: index < _events.length - 1 ? 14 : 0,
                                ),
                                child: _EventCard(event: _events[index]),
                              );
                            },
                          ),
                        ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          handleNavTap(
            context: context,
            currentIndex: 0,
            tappedIndex: index,
            onToggleTheme: widget.onToggleTheme,
          );
        },
      ),
    );
  }
}

// ── News Card ───────────────────────────────────────
class _NewsCard extends StatelessWidget {
  final NewsModel news;
  const _NewsCard({required this.news});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => showNewsDetail(context, news),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 6,
              height: 50,
              decoration: BoxDecoration(
                color: news.badgeColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    news.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.5),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    news.date,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.35),
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

// ── Event Card (with cover image + asset fallback) ──
class _EventCard extends StatelessWidget {
  final EventModel event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => showEventDetail(context, event),
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Cover Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: event.imageUrl != null && event.imageUrl!.isNotEmpty
                  ? Image.network(
                      event.imageUrl!,
                      width: double.infinity,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/event_cover.png',
                        width: double.infinity,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      'assets/images/event_cover.png',
                      width: double.infinity,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 10),
            Text(
              event.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 13,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.4),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    event.location,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.45),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 13,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.4),
                ),
                const SizedBox(width: 4),
                Text(
                  event.date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.45),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
