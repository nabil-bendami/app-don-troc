import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../config/index.dart';
import '../models/index.dart';
import '../providers/providers.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key});

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  List<File> _selectedImages = [];

  String? _selectedCategory;
  ItemType _selectedType = ItemType.don;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages = images.map((e) => File(e.path)).toList();
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error picking images: ${e.toString()}');
    }
  }

  Future<void> _handleCreateItem() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedImages.isEmpty) {
      setState(
        () => _errorMessage = 'Please fill in all fields and select images',
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final currentUserAsync = await ref.read(currentUserProvider.future);
      if (currentUserAsync == null) {
        throw Exception('User not authenticated');
      }

      final storageService = ref.read(storageServiceProvider);
      final firestoreService = ref.read(firestoreServiceProvider);

      /// Upload images
      final imageUrls = await storageService.uploadItemImages(
        images: _selectedImages,
        userId: currentUserAsync.uid,
      );

      /// Create item
      await firestoreService.createItem(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory!,
        type: _selectedType,
        imageUrls: imageUrls,
        userId: currentUserAsync.uid,
        userName: currentUserAsync.name,
        userPhotoUrl: currentUserAsync.photoUrl,
        location: _locationController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item created successfully!')),
        );
        context.pop();
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Constants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Error message
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(Constants.paddingMedium),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(
                      Constants.borderRadiusMedium,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppTheme.errorColor,
                      ),
                      const SizedBox(width: Constants.paddingMedium),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: AppTheme.errorColor),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Constants.paddingMedium),
              ],

              /// Image picker
              GestureDetector(
                onTap: _isLoading ? null : _pickImages,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.greyColor, width: 2),
                    borderRadius: BorderRadius.circular(
                      Constants.borderRadiusLarge,
                    ),
                    color: AppTheme.greyColor,
                  ),
                  child: _selectedImages.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.image_outlined,
                              size: 60,
                              color: AppTheme.secondaryColor,
                            ),
                            const SizedBox(height: Constants.paddingMedium),
                            Text(
                              'Tap to select images',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppTheme.secondaryColor),
                            ),
                          ],
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ..._selectedImages.asMap().entries.map((entry) {
                                final index = entry.key;
                                final image = entry.value;
                                return Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(
                                        Constants.paddingSmall,
                                      ),
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          Constants.borderRadiusMedium,
                                        ),
                                        image: DecorationImage(
                                          image: FileImage(image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.close),
                                        color: Colors.white,
                                        style: IconButton.styleFrom(
                                          backgroundColor: Colors.black54,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _selectedImages.removeAt(index);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              if (_selectedImages.length < 5)
                                GestureDetector(
                                  onTap: _isLoading ? null : _pickImages,
                                  child: Container(
                                    margin: const EdgeInsets.all(
                                      Constants.paddingSmall,
                                    ),
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        Constants.borderRadiusMedium,
                                      ),
                                      border: Border.all(
                                        color: AppTheme.primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: AppTheme.primaryColor,
                                      size: 40,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: Constants.paddingLarge),

              /// Title field
              Text('Title', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: Constants.paddingSmall),
              TextField(
                controller: _titleController,
                enabled: !_isLoading,
                decoration: const InputDecoration(hintText: 'Item title'),
              ),
              const SizedBox(height: Constants.paddingMedium),

              /// Description field
              Text(
                'Description',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: Constants.paddingSmall),
              TextField(
                controller: _descriptionController,
                enabled: !_isLoading,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Describe your item...',
                ),
              ),
              const SizedBox(height: Constants.paddingMedium),

              /// Category dropdown
              Text('Category', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: Constants.paddingSmall),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(hintText: 'Select category'),
                items: Constants.categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: _isLoading
                    ? null
                    : (value) => setState(() => _selectedCategory = value),
              ),
              const SizedBox(height: Constants.paddingMedium),

              /// Type selection
              Text('Type', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: Constants.paddingSmall),
              Row(
                children: [
                  Expanded(
                    child: SegmentedButton<ItemType>(
                      segments: const [
                        ButtonSegment(value: ItemType.don, label: Text('Don')),
                        ButtonSegment(
                          value: ItemType.troc,
                          label: Text('Troc'),
                        ),
                      ],
                      selected: {_selectedType},
                      onSelectionChanged: (newSelection) {
                        setState(() => _selectedType = newSelection.first);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Constants.paddingMedium),

              /// Location field
              Text('Location', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: Constants.paddingSmall),
              TextField(
                controller: _locationController,
                enabled: !_isLoading,
                decoration: const InputDecoration(
                  hintText: 'Your location',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: Constants.paddingXLarge),

              /// Create button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleCreateItem,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text('Create Item'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
