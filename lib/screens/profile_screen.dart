import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/index.dart';
import '../widgets/index.dart' as custom;
import '../providers/providers.dart';
import '../services/auth_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: currentUserAsync.when(
          data: (user) {
            if (user == null) {
              return const Center(child: Text('Not authenticated'));
            }

            final userItemsAsync = ref.watch(userItemsProvider(user.uid));

            return SingleChildScrollView(
              child: Column(
                children: [
                  /// User info section
                  Container(
                    padding: const EdgeInsets.all(Constants.paddingLarge),
                    child: Column(
                      children: [
                        /// Profile picture
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: user.photoUrl != null
                              ? CachedNetworkImageProvider(user.photoUrl!)
                              : null,
                          child: user.photoUrl == null
                              ? const Icon(Icons.person, size: 60)
                              : null,
                        ),
                        const SizedBox(height: Constants.paddingMedium),

                        /// Name
                        Text(
                          user.name,
                          style: Theme.of(context).textTheme.displaySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: Constants.paddingSmall),

                        /// Email
                        Text(
                          user.email,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppTheme.secondaryColor),
                          textAlign: TextAlign.center,
                        ),
                        if (user.location != null) ...[
                          const SizedBox(height: Constants.paddingSmall),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: AppTheme.secondaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                user.location!,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppTheme.secondaryColor),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const Divider(),

                  /// User's items section
                  Padding(
                    padding: const EdgeInsets.all(Constants.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Items',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: Constants.paddingMedium),
                        userItemsAsync.when(
                          data: (items) {
                            if (items.isEmpty) {
                              return const custom.EmptyWidget(
                                title: 'No items posted',
                                message:
                                    'Share your first item to help others!',
                                icon: Icons.inbox_outlined,
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return Card(
                                  margin: const EdgeInsets.only(
                                    bottom: Constants.paddingMedium,
                                  ),
                                  child: ListTile(
                                    leading: item.imageUrls.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              Constants.borderRadiusSmall,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: item.imageUrls[0],
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Icon(Icons.image),
                                    title: Text(item.title),
                                    subtitle: Text(item.location),
                                    trailing: PopupMenuButton(
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          onTap: () => context.push(
                                            '/home/item/${item.id}',
                                          ),
                                          child: const Text('View'),
                                        ),
                                        PopupMenuItem(
                                          onTap: () => _deleteItem(
                                            context,
                                            ref,
                                            item.id,
                                          ),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                    onTap: () =>
                                        context.push('/home/item/${item.id}'),
                                  ),
                                );
                              },
                            );
                          },
                          loading: () => const custom.LoadingWidget(
                            message: 'Loading items...',
                          ),
                          error: (error, stack) => custom.ErrorWidget(
                            message: error.toString(),
                            onRetry: () =>
                                ref.refresh(userItemsProvider(user.uid)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () =>
              const custom.LoadingWidget(message: 'Loading profile...'),
          error: (error, stack) =>
              custom.ErrorWidget(message: error.toString()),
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final authService = ref.read(authServiceProvider);
              await authService.signOut();
              if (context.mounted) {
                context.go('/auth');
              }
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _deleteItem(BuildContext context, WidgetRef ref, String itemId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final firestoreService = ref.read(firestoreServiceProvider);
                await firestoreService.deleteItem(itemId);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item deleted successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
