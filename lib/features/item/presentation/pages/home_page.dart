import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lost_and_found/core/presentation/widgets/custom_circular_progress.dart';
import 'package:lost_and_found/core/presentation/widgets/error_page.dart';
import 'package:lost_and_found/features/badges/presentation/bloc/badge_bloc.dart';
import 'package:lost_and_found/features/item/presentation/bloc/home/home_bloc.dart';
import 'package:lost_and_found/features/item/presentation/pages/filters_page.dart';
import 'package:lost_and_found/features/item/presentation/widgets/home/item_feed_card.dart';
import 'package:lost_and_found/features/user/presentation/bloc/user/user_bloc.dart';
import 'package:lost_and_found/utils/colors/custom_color.dart';
import 'package:lost_and_found/utils/constants.dart';
import 'package:lost_and_found/utils/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedFilter = "All";
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filterPills = const ["All", "Lost", "Found", "Nearby"];

  // Default high-fidelity items as specified:
  // Card 1: Red/Charcoal "LOST" badge, item sketch/photo (Gucci Wallet), Title, Distance ("0.4 km"), Location ("Central Station, Platform 4"), Date ("Today, 09:12")
  // Card 2: Green "FOUND" badge, thumbnail (Apple AirPods Pro), Title, Location, Date & Distance
  final List<ItemFeedCardData> _seedItems = const [
    ItemFeedCardData(
      id: 991,
      isLost: true,
      title: "Gucci Wallet",
      location: "Central Station, Platform 4",
      distance: "0.4 km",
      date: "Today, 09:12",
      category: "Wallets & Purses",
    ),
    ItemFeedCardData(
      id: 992,
      isLost: false,
      title: "Apple AirPods Pro",
      location: "Downtown Library, 2nd Fl",
      distance: "1.2 km",
      date: "Today, 08:30",
      category: "Electronics",
    ),
    ItemFeedCardData(
      id: 993,
      isLost: true,
      title: "Keychain with Brass Ring",
      location: "Market Square, Cafe Nero",
      distance: "0.8 km",
      date: "Yesterday, 16:40",
      category: "Keys",
    ),
    ItemFeedCardData(
      id: 994,
      isLost: false,
      title: "Sony WH-1000XM4 Headphones",
      location: "City Park, North Entrance",
      distance: "2.1 km",
      date: "Oct 24, 14:15",
      category: "Electronics",
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final secondaryTextColor = customColors.secondaryTextColor ?? const Color(0xFF8F99A8);
    final textPrimary = customColors.textPrimary ?? (isDark ? Colors.white : const Color(0xFF1E232A));
    final mintColor = customColors.primaryAccent ?? const Color(0xFF52C46A);
    final containerFill = customColors.cardFill ?? (isDark ? const Color(0xFF131A2B) : const Color(0xFFFFFFFF));
    final borderColor = customColors.cardBorderColor ?? (isDark ? const Color(0xFF1F2B45) : const Color(0xFFEDE8E1));

    // Active filter pill styling according to specification:
    // solid dark fill in light mode / solid white fill in dark mode
    final pillActiveBg = isDark ? Colors.white : const Color(0xFF1E232A);
    final pillActiveText = isDark ? const Color(0xFF0B101D) : Colors.white;

    return BlocBuilder<UserBloc, UserState>(
      builder: (userCtx, userState) {
        final userName = (userState.user?.username != null && userState.user!.username.isNotEmpty)
            ? userState.user!.username
            : "Neighbour";

        return BlocBuilder<BadgeBloc, BadgeState>(
          builder: (badgeCtx, badgeState) {
            return BlocBuilder<HomeBloc, HomeState>(
              builder: (homeCtx, homeState) {
                if (homeState.hasLoadingError) {
                  return ErrorPage(
                    onRetry: () => homeCtx.read<HomeBloc>().add(const HomeEvent.homeRefreshed()),
                  );
                }

                // Construct full item feed combining backend items and community seed items
                List<ItemFeedCardData> allItems = [];

                // Backend lost items
                for (var item in homeState.lostItems) {
                  allItems.add(
                    ItemFeedCardData(
                      id: item.id,
                      isLost: true,
                      title: item.title,
                      location: "Neighbourhood Area",
                      distance: "0.5 km",
                      date: "Recent",
                      imageUrl: "$baseUrl/api/items/${item.id}/image",
                      token: homeState.token,
                    ),
                  );
                }

                // Backend found items
                for (var item in homeState.foundItems) {
                  allItems.add(
                    ItemFeedCardData(
                      id: item.id,
                      isLost: false,
                      title: item.title,
                      location: "Neighbourhood Area",
                      distance: "1.0 km",
                      date: "Recent",
                      imageUrl: "$baseUrl/api/items/${item.id}/image",
                      token: homeState.token,
                    ),
                  );
                }

                // Seed items for high-fidelity feed
                allItems.addAll(_seedItems);

                // Filter logic
                List<ItemFeedCardData> displayedItems = allItems.where((item) {
                  // Filter pill match
                  if (_selectedFilter == "Lost" && !item.isLost) return false;
                  if (_selectedFilter == "Found" && item.isLost) return false;
                  if (_selectedFilter == "Nearby") {
                    final distDouble = double.tryParse(item.distance.split(' ').first) ?? 99.0;
                    if (distDouble > 1.0) return false;
                  }

                  // Search query match
                  if (_searchQuery.isNotEmpty) {
                    final query = _searchQuery.toLowerCase();
                    final matchesTitle = item.title.toLowerCase().contains(query);
                    final matchesLocation = item.location.toLowerCase().contains(query);
                    final matchesCat = item.category?.toLowerCase().contains(query) ?? false;
                    return matchesTitle || matchesLocation || matchesCat;
                  }

                  return true;
                }).toList();

                return RefreshIndicator(
                  color: mintColor,
                  onRefresh: () async {
                    homeCtx.read<HomeBloc>().add(const HomeEvent.homeRefreshed());
                    await Future.delayed(const Duration(milliseconds: 600));
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    children: [
                      // App Bar Header: "Good morning, [User Name]" in serif font with bell icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Good morning,",
                                  style: AppTypography.sansSecondary(
                                    context,
                                    fontSize: 14,
                                    color: secondaryTextColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  userName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.serifTitle(
                                    context,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              // Claims Button
                              badges.Badge(
                                onTap: () => Navigator.of(context).pushNamed('/claims'),
                                badgeContent: Text(
                                  "${badgeState.unreadReceivedClaims + (badgeState.hasUnreadSentClaims ? 1 : 0)}",
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                                showBadge: badgeState.unreadReceivedClaims > 0,
                                position: badges.BadgePosition.topEnd(top: -2, end: -2),
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: containerFill,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: borderColor, width: 1),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.handshake_outlined, size: 20, color: textPrimary),
                                    onPressed: () => Navigator.of(context).pushNamed('/claims'),
                                    tooltip: "Claims",
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),

                              // Top-right Bell Notification Icon with unread badge
                              badges.Badge(
                                onTap: () => Navigator.of(context).pushNamed('/notifications'),
                                badgeContent: Text(
                                  "${badgeState.unreadNews}",
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                                showBadge: badgeState.unreadNews > 0,
                                position: badges.BadgePosition.topEnd(top: -2, end: -2),
                                badgeStyle: badges.BadgeStyle(badgeColor: mintColor),
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: containerFill,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: borderColor, width: 1),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.notifications_outlined, size: 22, color: textPrimary),
                                    onPressed: () => Navigator.of(context).pushNamed('/notifications'),
                                    tooltip: "Notifications",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Search & Filter Bar: Full-width live search input + square filter button
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: containerFill,
                                borderRadius: BorderRadius.circular(AppRadius.input),
                                border: Border.all(color: borderColor, width: 1),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              child: Row(
                                children: [
                                  Icon(Icons.search_rounded, size: 22, color: secondaryTextColor),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      onChanged: (val) {
                                        setState(() {
                                          _searchQuery = val.trim();
                                        });
                                      },
                                      style: AppTypography.sansBody(context),
                                      decoration: InputDecoration(
                                        hintText: "Search reports, items, streets...",
                                        hintStyle: AppTypography.sansSecondary(context, fontSize: 14),
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                        filled: false,
                                      ),
                                    ),
                                  ),
                                  if (_searchQuery.isNotEmpty)
                                    GestureDetector(
                                      onTap: () {
                                        _searchController.clear();
                                        setState(() {
                                          _searchQuery = "";
                                        });
                                      },
                                      child: Icon(Icons.close_rounded, size: 18, color: secondaryTextColor),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Square filter icon button
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: containerFill,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: borderColor, width: 1),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.tune_rounded, size: 22, color: textPrimary),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const FiltersScreen()),
                                );
                              },
                              tooltip: "Filter options",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Filter Pills: Horizontal scrollable row: "All", "Lost", "Found", "Nearby"
                      SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _filterPills.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final pill = _filterPills[index];
                            final isActive = pill == _selectedFilter;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedFilter = pill;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? pillActiveBg
                                      : (isDark ? const Color(0xFF131A2B) : const Color(0xFFF3EFEA)),
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                  border: Border.all(
                                    color: isActive
                                        ? pillActiveBg
                                        : borderColor,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    pill,
                                    style: AppTypography.sansBold(
                                      context,
                                      fontSize: 13,
                                      color: isActive ? pillActiveText : secondaryTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Section Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedFilter == "All"
                                ? "Nearby Community Feed"
                                : "$_selectedFilter Reports",
                            style: AppTypography.serifHeading(context, fontSize: 20),
                          ),
                          Text(
                            "${displayedItems.length} items",
                            style: AppTypography.sansSecondary(context, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Feed Items List
                      if (homeState.isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child: Center(child: CustomCircularProgress(size: 60)),
                        )
                      else if (displayedItems.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 48.0),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.search_off_rounded, size: 48, color: secondaryTextColor.withOpacity(0.5)),
                                const SizedBox(height: 12),
                                Text(
                                  "No matching reports found",
                                  style: AppTypography.sansBold(context, fontSize: 16),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Try adjusting your filters or search keywords.",
                                  style: AppTypography.sansSecondary(context, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...displayedItems.map((item) => ItemFeedCard(item: item)),
                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
