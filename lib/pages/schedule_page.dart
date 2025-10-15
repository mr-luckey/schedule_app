
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/APIS/Api_Service.dart';
import 'package:schedule_app/controllers/calender_controller.dart';
import 'package:schedule_app/pages/Calender_Main/Week_Calender.dart';
import 'package:schedule_app/pages/List/home_controller.dart';
import 'package:schedule_app/pages/List/listing_screen.dart';
// import 'package:schedule_app/pages/List/ListScreen.dart';
import 'package:table_calendar/table_calendar.dart';

import '../APIS/shared_prefs_service.dart';
import '../model/user_model.dart';
import '../theme/app_colors.dart';
import '../widgets/calendar_grid.dart';
import '../pages/booking_page.dart';
import '../widgets/filter_button.dart';
import '../widgets/nav_item.dart';
import 'Auth/Login_Signup.dart';

// Define the different sections of the app
enum AppSection { bookings, orders, users, settings }

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _currentDate = DateTime.now();
  String _selectedView = 'Week';
  bool showEmptyContainer = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Track current section
  AppSection _currentSection = AppSection.bookings;

  CalendarsController calendarsController = Get.put(CalendarsController());
  HomeController homeController = Get.put(HomeController());
  UserModel? currentUser;
  @override
  void initState() {
    super.initState();
    calendarsController.loadEventsFromApi();
    homeController.fetchOrders();



  }

  void _goToToday() {
    setState(() {
      _currentDate = DateTime.now();
    });
  }

  void _navigateWeek(int direction) {
    setState(() {
      _currentDate = _currentDate.add(Duration(days: direction * 7));
    });
  }

  void _setView(String view) {
    setState(() {
      _selectedView = view;
    });
  }

  void _toggleEmptyContainer() {
    setState(() {
      showEmptyContainer = !showEmptyContainer;
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  // Method to change current section
  void _changeSection(AppSection section) {
    setState(() {
      _currentSection = section;
    });
    // Close drawer if on mobile
    if (ResponsiveBreakpoints.of(context).smallerThan(TABLET)) {
      Navigator.pop(context);
    }
  }

  Widget _buildScheduleHeader() {
    String headerTitle;
    switch (_currentSection) {
      case AppSection.bookings:
        headerTitle = 'Booking Schedule';
        break;
      case AppSection.orders:
        headerTitle = 'Orders';
        break;
      case AppSection.users:
        headerTitle = 'Users';
        break;
      case AppSection.settings:
        headerTitle = 'Settings';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // Menu button for mobile to open drawer
          if (ResponsiveBreakpoints.of(context).smallerThan(TABLET))
            IconButton(
              onPressed: _openDrawer,
              icon: const Icon(Icons.menu),
              style: IconButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
              ),
            ),

          const SizedBox(width: 12),

          // Title - changes based on section
          Text(
            headerTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          // Only show calendar controls in bookings section
          if (_currentSection == AppSection.bookings) ...[
            const SizedBox(width: 24),

            // Today button
            TextButton(
              onPressed: _goToToday,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text('Today'),
            ),

            const SizedBox(width: 16),

            // Date navigation
            Row(
              children: [
                IconButton(
                  onPressed: () => _navigateWeek(-1),
                  icon: const Icon(Icons.chevron_left),
                  style: IconButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
                Text(
                  DateFormat('MMMM d, yyyy').format(_currentDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => _navigateWeek(1),
                  icon: const Icon(Icons.chevron_right),
                  style: IconButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],

          const Spacer(),

          // Show New Schedule button only in bookings section
          if (_currentSection == AppSection.bookings) ...[
            ElevatedButton.icon(
              onPressed: _toggleEmptyContainer,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New Schedule'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // View switcher (only show on tablet/desktop and in bookings section)
            if (!ResponsiveBreakpoints.of(context).smallerThan(TABLET))
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildViewButton('Day'),
                    _buildViewButton('Week'),
                    _buildViewButton('Month'),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildViewButton(String view) {
    final bool isSelected = _selectedView == view;
    return GestureDetector(
      onTap: () => _setView(view),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          view,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  // Build main content based on current section
  Widget _buildMainContent() {
    switch (_currentSection) {
      case AppSection.bookings:
        if (showEmptyContainer) {
          return BookingPage();
        } else {
          return Obx(() {
            final events = calendarsController.events.toList();
            return WeekTimeCalendar(
              events: events,
              currentDate: _currentDate,
              startHour: 8,
              endHour: 24,
              showWeekend: true,
              onEventTap: (e) {
                // handle tap
              },
            );
          });
        }
      case AppSection.orders:
        return ListingScreen();
      case AppSection.users:
        return _buildEmptySection('Users', Icons.group);
      case AppSection.settings:
        return _buildEmptySection('Settings', Icons.settings);
    }
  }

  Widget _buildEmptySection(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            '$title Section',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This section is under development',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
          ? Drawer(child: _buildDrawerContent())
          : null,
      body: ResponsiveBreakpoints.builder(
        child: _buildLayout(context),
        breakpoints: const [
          Breakpoint(start: 0, end: 599, name: MOBILE),
          Breakpoint(start: 600, end: 1023, name: TABLET),
          Breakpoint(start: 1024, end: 1439, name: DESKTOP),
          Breakpoint(start: 1440, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }

  Widget _buildLayout(BuildContext context) {
    final bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final bool isTablet = ResponsiveBreakpoints.of(
      context,
    ).between(TABLET, DESKTOP);

    if (isMobile) {
      return _buildMobileLayout();
    } else if (isTablet) {
      return _buildTabletLayout();
    } else {
      return _buildDesktopLayout();
    }
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildScheduleHeader(),
        Expanded(child: _buildMainContent()),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        // Sidebar for tablet (narrower)
        SizedBox(
          width: 240,
          child: Sidebar(
            currentSection: _currentSection,
            onSectionChanged: _changeSection,
          ),
        ),

        // Main content
        Expanded(
          child: Column(
            children: [
              _buildScheduleHeader(),
              Expanded(child: _buildMainContent()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Sidebar for desktop
        Sidebar(
          currentSection: _currentSection,
          onSectionChanged: _changeSection,
        ),

        // Main content
        Expanded(
          child: Column(
            children: [
              _buildScheduleHeader(),
              Expanded(child: _buildMainContent()),
            ],
          ),
        ),
      ],
    );
  }

  // Drawer content for mobile
  Widget _buildDrawerContent() {
    return DrawerContent(
      currentSection: _currentSection,
      onSectionChanged: _changeSection,
    );
  }
}

// Updated Sidebar with section management
class Sidebar extends StatefulWidget {
  final AppSection currentSection;
  final Function(AppSection) onSectionChanged;

  const Sidebar({
    super.key,
    required this.currentSection,
    required this.onSectionChanged,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedFilter = 'Confirmed';
  UserModel? currentUser;


  @override
  void initState() {
    super.initState();//
    getUserData();
  }

  getUserData()async{
    currentUser = await SharedPrefsService.getUserData();
    if (currentUser != null) {
      print('Welcome ${currentUser!.name}');
      print('Your email: ${currentUser!.email}');
      print('Your token: ${currentUser!.token}');
    }
  }
  String _getInitials(String name) {
    if (name.isEmpty) return 'U'; // Default for empty name

    List<String> names = name.trim().split(' ');

    if (names.length == 1) {
      // Single name - return first 2 characters
      return names[0].length >= 2
          ? names[0].substring(0, 2).toUpperCase()
          : names[0].toUpperCase();
    } else {
      // Multiple names - return first character of first two names
      String firstInitial = names[0].isNotEmpty ? names[0][0] : '';
      String secondInitial = names[1].isNotEmpty ? names[1][0] : '';
      return '${firstInitial.toUpperCase()}${secondInitial.toUpperCase()}';
    }
  }
  void _showLogoutPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _performLogout();
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performLogout() async {
    try {
      // Clear user data from SharedPreferences
      await SharedPrefsService.clearUserData();
      await ApiService.clearToken();


      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to login screen
      Get.offAll(()=>AuthScreen());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: AppColors.surface,
      child: Column(
        children: [
          // Branding section
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Bookings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Mini calendar section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(_focusedDay),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!mounted) return;
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarFormat: CalendarFormat.week,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerVisible: false,
                  daysOfWeekVisible: false,
                  calendarStyle: const CalendarStyle(
                    outsideDaysVisible: false,
                    weekendTextStyle: TextStyle(color: AppColors.textSecondary),
                    defaultTextStyle: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppColors.primary100,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Filter buttons (only show in bookings section)
          if (widget.currentSection == AppSection.bookings) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: FilterButton(
                      label: 'Confirmed',
                      isSelected: _selectedFilter == 'Confirmed',
                      onTap: () {
                        setState(() {
                          _selectedFilter = 'Confirmed';
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Navigation items
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  NavItem(
                    icon: Icons.receipt_long,
                    label: 'Bookings',
                    isSelected: widget.currentSection == AppSection.bookings,
                    onTap: () {
                      widget.onSectionChanged(AppSection.bookings);
                    },
                  ),
                  NavItem(
                    icon: Icons.bar_chart,
                    label: 'Orders',
                    isSelected: widget.currentSection == AppSection.orders,
                    onTap: () {
                      widget.onSectionChanged(AppSection.orders);
                    },
                  ),
                  NavItem(
                    icon: Icons.group,
                    label: 'Users',
                    isSelected: widget.currentSection == AppSection.users,
                    onTap: () {
                      widget.onSectionChanged(AppSection.users);
                    },
                  ),
                  NavItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    isSelected: widget.currentSection == AppSection.settings,
                    onTap: () {
                      widget.onSectionChanged(AppSection.settings);
                    },
                  ),
                ],
              ),
            ),
          ),

          // User profile section
          GestureDetector(
            onTap: _showLogoutPopup,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.pink,
                      shape: BoxShape.circle,
                    ),
                    child:  Center(
                      child: Text(
                          _getInitials(currentUser != null ? currentUser!.name : 'User Name'),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                   Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser != null ? currentUser!.name : 'User Name',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        // Text(
                        //   'Free Account',
                        //   style: TextStyle(
                        //     fontSize: 12,
                        //     color: AppColors.textSecondary,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Drawer content for mobile
class DrawerContent extends StatefulWidget {
  final AppSection currentSection;
  final Function(AppSection) onSectionChanged;

  const DrawerContent({
    super.key,
    required this.currentSection,
    required this.onSectionChanged,
  });

  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedFilter = 'Confirmed';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          // Branding section
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Bookings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Mini calendar section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(_focusedDay),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!mounted) return;
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarFormat: CalendarFormat.week,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerVisible: false,
                  daysOfWeekVisible: false,
                  calendarStyle: const CalendarStyle(
                    outsideDaysVisible: false,
                    weekendTextStyle: TextStyle(color: AppColors.textSecondary),
                    defaultTextStyle: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppColors.primary100,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Filter buttons (only show in bookings section)
          if (widget.currentSection == AppSection.bookings) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: FilterButton(
                      label: 'Confirmed',
                      isSelected: _selectedFilter == 'Confirmed',
                      onTap: () {
                        setState(() {
                          _selectedFilter = 'Confirmed';
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Navigation items
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  NavItem(
                    icon: Icons.receipt_long,
                    label: 'Bookings',
                    isSelected: widget.currentSection == AppSection.bookings,
                    onTap: () {
                      widget.onSectionChanged(AppSection.bookings);
                      Navigator.pop(context); // Close drawer
                    },
                  ),
                  NavItem(
                    icon: Icons.bar_chart,
                    label: 'Orders',
                    isSelected: widget.currentSection == AppSection.orders,
                    onTap: () {
                      widget.onSectionChanged(AppSection.orders);
                      Navigator.pop(context); // Close drawer
                    },
                  ),
                  NavItem(
                    icon: Icons.group,
                    label: 'Users',
                    isSelected: widget.currentSection == AppSection.users,
                    onTap: () {
                      widget.onSectionChanged(AppSection.users);
                      Navigator.pop(context); // Close drawer
                    },
                  ),
                  NavItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    isSelected: widget.currentSection == AppSection.settings,
                    onTap: () {
                      widget.onSectionChanged(AppSection.settings);
                      Navigator.pop(context); // Close drawer
                    },
                  ),
                ],
              ),
            ),
          ),

          // User profile section
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.pink,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'EA',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Easin Arafat',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Free Account',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
