import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/index.dart';
import '../widgets/index.dart' as custom;
import '../providers/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemsFeed = ref.watch(itemsFeedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Don & Troc'),
        elevation: 0,
        backgroundColor: AppTheme.cardColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// Search bar
            Padding(
              padding: const EdgeInsets.all(Constants.paddingMedium),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search items...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () =>
                              setState(() => _searchController.clear()),
                        )
                      : null,
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),

            /// Items feed
            Expanded(
              child: itemsFeed.when(
                data: (items) {
                  if (items.isEmpty) {
                    return const custom.EmptyWidget(
                      title: 'No items yet',
                      message: 'Start sharing items to help your community!',
                      icon: Icons.inbox_outlined,
                    );
                  }

                  /// Filter by search
                  final filteredItems = _searchController.text.isEmpty
                      ? items
                      : items
                            .where(
                              (item) => item.title.toLowerCase().contains(
                                _searchController.text.toLowerCase(),
                              ),
                            )
                            .toList();

                  return ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return custom.ItemCard(
                        item: item,
                        onTap: () => context.push('/home/item/${item.id}'),
                      );
                    },
                  );
                },
                loading: () =>
                    const custom.LoadingWidget(message: 'Loading items...'),
                error: (error, stack) => custom.ErrorWidget(
                  message: error.toString(),
                  onRetry: () => ref.refresh(itemsFeedProvider),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: custom.BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          _handleNavigation(index, context);
        },
      ),
    );
  }

  void _handleNavigation(int index, BuildContext context) {
    switch (index) {
      case 0:
        break;

      /// Already on home
      case 1:
        context.push('/home/add-item');
        setState(() => _selectedIndex = 0);
        break;
      case 2:
        context.push('/messages');
        break;
      case 3:
        context.push('/activity');
        break;
      case 4:
        context.push('/profile');
        break;
    }
  }
}
