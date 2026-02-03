import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/index.dart';
import '../models/index.dart';

class ItemCard extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onTap;

  const ItemCard({required this.item, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(Constants.paddingMedium),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadiusLarge),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Constants.borderRadiusLarge),
                topRight: Radius.circular(Constants.borderRadiusLarge),
              ),
              child: Container(
                height: Constants.itemImageHeight,
                width: double.infinity,
                color: AppTheme.greyColor,
                child: item.imageUrls.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: item.imageUrls[0],
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.image_not_supported),
                      )
                    : const Icon(
                        Icons.image,
                        size: 80,
                        color: AppTheme.secondaryColor,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Constants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: Constants.paddingSmall),

                  /// Type badge and location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: item.type == ItemType.don
                              ? AppTheme.successColor.withAlpha(26)
                              : AppTheme.primaryColor.withAlpha(26),
                          borderRadius: BorderRadius.circular(
                            Constants.borderRadiusSmall,
                          ),
                        ),
                        child: Text(
                          item.type == ItemType.don ? 'Don' : 'Troc',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: item.type == ItemType.don
                                ? AppTheme.successColor
                                : AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppTheme.secondaryColor,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              item.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: Constants.paddingMedium),

                  /// User info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: Constants.smallAvatarRadius,
                        backgroundImage: item.userPhotoUrl != null
                            ? CachedNetworkImageProvider(item.userPhotoUrl!)
                            : null,
                        child: item.userPhotoUrl == null
                            ? const Icon(Icons.person, size: 16)
                            : null,
                      ),
                      const SizedBox(width: Constants.paddingSmall),
                      Expanded(
                        child: Text(
                          item.userName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
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
    );
  }
}
