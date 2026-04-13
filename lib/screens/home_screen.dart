import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../helpers/nav_helper.dart';
import '../models/category_model.dart';
import '../models/class_model.dart';
import '../models/news_model.dart';
import '../models/event_model.dart';
import '../widgets/category_card.dart';
import '../widgets/class_card.dart';
import '../widgets/news_card.dart';
import '../widgets/event_card.dart';
import '../widgets/bottom_nav_bar.dart';
import '../models/notification_model.dart';
import '../helpers/notification_data.dart';
import '../widgets/notification_bell.dart';
import '../widgets/news_detail_sheet.dart';
import '../widgets/event_detail_sheet.dart';

// Add state variable in _HomeScreenState:
final List<NotificationModel> _notifications = getSampleNotifications();

class HomeScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  const HomeScreen({super.key, this.onToggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<CategoryModel> _categories = const [
    CategoryModel(
      name: 'Computer Science',
      imageUrl:
          'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=300',
    ),
    CategoryModel(
      name: 'Mathematics',
      imageUrl:
          'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=300',
    ),
    CategoryModel(
      name: 'History & Geography',
      imageUrl:
          'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=300',
    ),
    CategoryModel(
      name: 'Art & Culture',
      imageUrl:
          'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=300',
    ),
    CategoryModel(
      name: 'Physics',
      imageUrl:
          'https://images.unsplash.com/photo-1636466497217-26a8cbeaf0aa?w=300',
    ),
  ];

  final List<ClassModel> _todayClasses = const [
    ClassModel(
      name: 'Digital Thinking',
      startTime: '09:00',
      endTime: '11:00',
      location: 'Main auditorium',
      teacher: 'Mam Mahnoor',
    ),
  ];

  final List<NewsModel> _newsList = [
    NewsModel(
      title: 'FBISE',
      description:
          'The Federal Board of Intermediate and Secondary Education (FBISE) has officially announced the date for the results of the SSC Part I & II 1st Annual Examinations.',
      fullContent:
          'The Federal Board of Intermediate and Secondary Education (FBISE) has officially announced the date for the results of the Secondary School Certificate (SSC) Part I & II 1st Annual Examinations 2024.\n\nAccording to the official notification released by FBISE, the SSC Part I results will be announced on July 15, 2024, while the SSC Part II results will follow on July 22, 2024.\n\nStudents who appeared in the examinations can check their results online through the official FBISE website. The board has also set up a dedicated helpline for students who may have queries regarding their results.\n\nThe examinations were conducted across multiple centers nationwide, with over 200,000 students participating this year. The board has emphasized that the results have been compiled with utmost transparency and accuracy.\n\nStudents are advised to keep their roll number slips ready for checking results online. The detailed mark sheets will be available for collection from respective schools within two weeks of the result announcement.',
      date: 'May 01',
      source: 'Federal Board of Education',
      badgeColor: AppTheme.primary,
    ),
    NewsModel(
      title: 'Gaza',
      description:
          'The Pakistan Medical and Dental Council (PM&DC) has permitted medical/dental students from Gaza to complete their studies in Pakistan.',
      fullContent:
          'The Pakistan Medical and Dental Council (PM&DC) has permitted medical/dental students from Gaza to complete their studies in Pakistan, in a landmark humanitarian decision.\n\nThe PM&DC announced that displaced students from Gaza who were pursuing medical and dental degrees can now enroll in Pakistani medical colleges to continue their education without any additional entrance examination requirements.\n\nThis decision was made following a special meeting of the PM&DC executive committee, which reviewed the humanitarian crisis affecting students in the region. The council noted that education is a fundamental right and should not be disrupted by conflict.\n\nSeveral prominent medical colleges across Pakistan, including those in Islamabad, Lahore, and Karachi, have already expressed willingness to accommodate these students. Scholarships and financial aid programs are also being arranged to support the incoming students.\n\nThe Higher Education Commission (HEC) of Pakistan has also pledged its support, offering to facilitate the credit transfer process and ensure that the students\' previous academic work is recognized.',
      date: 'June 07',
      source: 'Pakistan Medical & Dental Council',
      badgeColor: const Color(0xFF4CAF50),
    ),
    NewsModel(
      title: 'LUMS',
      description:
          'LUMS recently celebrated the graduation of its latest cohort of talented graduates across multiple disciplines.',
      fullContent:
          'LUMS recently celebrated the graduation of its latest cohort of talented graduates across multiple disciplines in a grand convocation ceremony held at the main campus.\n\nThe Class of 2024 saw over 1,200 students receive their degrees in various programs including Business, Computer Science, Engineering, Social Sciences, and Law. The ceremony was graced by distinguished guests from academia, industry, and government.\n\nThe keynote address was delivered by a renowned tech entrepreneur who emphasized the importance of innovation, resilience, and ethical leadership in today\'s rapidly changing world.\n\nNotable achievements of this graduating class include:\n\n• 15 students graduated with Summa Cum Laude honors\n• 42 students received Dean\'s Honor Roll recognition\n• The class collectively completed over 50,000 hours of community service\n• 23 student-led startups were launched during their time at LUMS\n\nThe Vice Chancellor congratulated the graduates and encouraged them to become agents of positive change in society. Alumni from previous years also attended the event, creating a vibrant atmosphere of celebration and mentorship.',
      date: 'May 01',
      source: 'LUMS Communications',
      badgeColor: AppTheme.primary,
    ),
  ];

  final List<EventModel> _eventsList = const [
    EventModel(
      title: 'IDP Study Abroad Expo',
      location: 'Islamabad',
      date: 'Wed, 28 Feb 2024',
      time: '10:00 AM - 5:00 PM',
      venue: 'Serena Hotel, Convention Center',
      organizer: 'IDP Education',
      imageUrl:
          'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=600',
      description:
          'The IDP Study Abroad Expo is your one-stop destination to explore international education opportunities. Meet representatives from over 100 universities across Australia, UK, Canada, USA, and New Zealand.\n\nWhat to expect:\n\n• One-on-one consultations with university representatives\n• Free IELTS preparation workshops\n• Scholarship information sessions\n• Visa guidance and application support\n• Live campus tours via VR headsets\n\nWhether you\'re looking for undergraduate, postgraduate, or PhD programs, this expo has something for every aspiring international student. Entry is free but registration is recommended to skip the queue.',
    ),
    EventModel(
      title: 'Pathways to Development Conference',
      location: 'Lahore',
      date: 'Fri, 19 Apr 2024',
      time: '9:00 AM - 4:30 PM',
      venue: 'LUMS, Suleman Dawood School of Business',
      organizer: 'LUMS Development Society',
      imageUrl:
          'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=600',
      description:
          'The annual Pathways to Development Conference brings together thought leaders, policymakers, academics, and students to discuss Pakistan\'s most pressing development challenges.\n\nThis year\'s theme: "Innovation for Inclusive Growth"\n\nHighlights include:\n\n• Keynote by Dr. Atif Mian (Princeton University)\n• Panel discussions on education reform, climate resilience, and digital economy\n• Student research poster presentations\n• Networking lunch with industry professionals\n• Certificate of participation for all attendees\n\nThis conference is an excellent opportunity for students interested in public policy, economics, and social sciences.',
    ),
    EventModel(
      title: 'IELTS Information Workshop',
      location: 'Karachi',
      date: 'Sat, 25 May 2024',
      time: '2:00 PM - 5:00 PM',
      venue: 'British Council, Clifton',
      organizer: 'British Council Pakistan',
      imageUrl:
          'https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=600',
      description:
          'Planning to take the IELTS exam? Attend this free information workshop hosted by the British Council to learn everything you need to know about the test.\n\nTopics covered:\n\n• IELTS test format and scoring explained\n• Tips and strategies for each section (Listening, Reading, Writing, Speaking)\n• Common mistakes and how to avoid them\n• Free practice materials and resources\n• Q&A session with certified IELTS trainers\n\nThis workshop is suitable for first-time test takers as well as those looking to improve their band score. Seats are limited, so early registration is encouraged.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    // Dark mode toggle
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
                          Theme.of(context).brightness == Brightness.dark
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
                    // Notification bell
                    NotificationBell(
                      notifications: _notifications,
                      onNotificationTap: (notif) {
                        setState(() => notif.isRead = true);
                        // Navigate based on notif.type if needed
                      },
                      onMarkAllRead: () {
                        setState(() {
                          for (var n in _notifications) {
                            n.isRead = true;
                          }
                        });
                      },
                      onViewAll: () {
                        // Navigate to a full notifications page if you build one
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Categories
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: SizedBox(
                  height: 135,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) =>
                        CategoryCard(category: _categories[index]),
                  ),
                ),
              ),
            ),

            // Today's Classes Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today's Classes",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        handleNavTap(
                          context: context,
                          currentIndex: 0,
                          tappedIndex: 2,
                          onToggleTheme: widget.onToggleTheme,
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            'Open schedule',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: AppTheme.primary,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Today's Classes List
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: _todayClasses
                      .map(
                        (c) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ClassCard(classItem: c),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            // News / Events Tabs
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppTheme.primary,
                  unselectedLabelColor: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.45),
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  indicatorColor: AppTheme.primary,
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: const [
                    Tab(text: 'News'),
                    Tab(text: 'Events'),
                  ],
                  onTap: (_) => setState(() {}),
                ),
              ),
            ),

            // Tab Content
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _tabController.index == 0
                      ? Column(
                          key: const ValueKey('news'),
                          children: _newsList
                              .map(
                                (n) => NewsCard(
                                  news: n,
                                  onTap: () => showNewsDetail(context, n),
                                ),
                              )
                              .toList(),
                        )
                      : Column(
                          key: const ValueKey('events'),
                          children: _eventsList
                              .map(
                                (e) => EventCard(
                                  event: e,
                                  onTap: () => showEventDetail(context, e),
                                ),
                              )
                              .toList(),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ✅ Bottom Nav using handleNavTap
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
