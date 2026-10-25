import 'package:flutter/material.dart';
import 'package:lost_and_found/features/item/presentation/pages/item_page.dart';
import 'package:lost_and_found/utils/colors/custom_color.dart';
import 'package:lost_and_found/utils/theme/app_theme.dart';

class ItemFeedCardData {
  final int id;
  final bool isLost;
  final String title;
  final String location;
  final String distance;
  final String date;
  final String? imageUrl;
  final String? token;
  final String? category;

  const ItemFeedCardData({
    required this.id,
    required this.isLost,
    required this.title,
    required this.location,
    required this.distance,
    required this.date,
    this.imageUrl,
    this.token,
    this.category,
  });
}

class ItemFeedCard extends StatelessWidget {
  final ItemFeedCardData item;
  final VoidCallback? onTap;

  const ItemFeedCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardFill = customColors.cardFill ?? (isDark ? const Color(0xFF131A2B) : const Color(0xFFFFFFFF));
    final borderColor = customColors.cardBorderColor ?? (isDark ? const Color(0xFF1F2B45) : const Color(0xFFEDE8E1));
    final secondaryTextColor = customColors.secondaryTextColor ?? const Color(0xFF8F99A8);
    final textPrimary = customColors.textPrimary ?? (isDark ? Colors.white : const Color(0xFF1E232A));
    final mintColor = customColors.primaryAccent ?? const Color(0xFF52C46A);

    // LOST badge: Crimson Red in Dark mode, Charcoal Dark in Light mode
    final lostBadgeColor = isDark ? const Color(0xFFA61C32) : const Color(0xFF1E232A);
    // FOUND badge: Mint Green
    final badgeColor = item.isLost ? lostBadgeColor : mintColor;
    final badgeTextColor = item.isLost
        ? Colors.white
        : (isDark ? const Color(0xFF0B101D) : Colors.white);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardFill,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.card),
          onTap: onTap ??
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ItemScreen(itemId: item.id)),
                );
              },
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail / Sketch
                Stack(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: customColors.containerSoft ?? (isDark ? const Color(0xFF192238) : const Color(0xFFF3EFEA)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: item.imageUrl != null && item.imageUrl!.startsWith("http")
                          ? Image.network(
                              item.imageUrl!,
                              fit: BoxFit.cover,
                              headers: item.token != null ? {"Authorization": "Bearer ${item.token}"} : null,
                              errorBuilder: (_, __, ___) => _buildPlaceholderIcon(context),
                            )
                          : _buildPlaceholderIllustration(context),
                    ),
                    // Small status indicator on image
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(AppRadius.badge),
                        ),
                        child: Text(
                          item.isLost ? "LOST" : "FOUND",
                          style: TextStyle(
                            color: badgeTextColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),

                // Card Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Distance and Category
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: mintColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(AppRadius.badge),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.near_me_rounded, size: 11, color: mintColor),
                                const SizedBox(width: 4),
                                Text(
                                  item.distance,
                                  style: AppTypography.sansBold(
                                    context,
                                    fontSize: 11,
                                    color: mintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            item.date,
                            style: AppTypography.sansSecondary(
                              context,
                              fontSize: 11,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Title
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.sansBold(
                          context,
                          fontSize: 17,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Location text with pin
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: secondaryTextColor,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.sansSecondary(
                                context,
                                fontSize: 12,
                                color: secondaryTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon(BuildContext context) {
    return Center(
      child: Icon(
        item.isLost ? Icons.search_off_rounded : Icons.check_circle_outline_rounded,
        size: 36,
        color: Theme.of(context).extension<CustomColors>()?.secondaryTextColor?.withOpacity(0.5) ??
            const Color(0xFF8F99A8),
      ),
    );
  }

  Widget _buildPlaceholderIllustration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = item.isLost
        ? (isDark ? const Color(0xFFA61C32) : const Color(0xFF1E232A))
        : (isDark ? const Color(0xFF63D279) : const Color(0xFF52C46A));

    return Container(
      color: iconColor.withOpacity(0.08),
      child: Center(
        child: Icon(
          item.isLost ? Icons.wallet_rounded : Icons.headphones_rounded,
          size: 40,
          color: iconColor.withOpacity(0.8),
        ),
      ),
    );
  }
}
