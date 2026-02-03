import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/index.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Constants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// New Requests Section
              Text(
                'New Requests',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: Constants.paddingMedium),
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.person_add,
                    color: AppTheme.primaryColor,
                  ),
                  title: const Text('Someone requested your item'),
                  subtitle: const Text('2 hours ago'),
                  onTap: () => context.push('/messages'),
                ),
              ),
              const SizedBox(height: Constants.paddingMedium),
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.check_circle,
                    color: AppTheme.successColor,
                  ),
                  title: const Text('Your request was accepted'),
                  subtitle: const Text('1 day ago'),
                  onTap: () => context.push('/messages'),
                ),
              ),
              const SizedBox(height: Constants.paddingLarge),

              /// New Messages Section
              Text(
                'New Messages',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: Constants.paddingMedium),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.chat, color: AppTheme.primaryColor),
                  title: const Text('You have 3 new messages'),
                  subtitle: const Text('in 2 conversations'),
                  onTap: () => context.push('/messages'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
