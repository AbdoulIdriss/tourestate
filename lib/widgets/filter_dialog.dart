import 'package:flutter/material.dart';

class FilterCriteria {
  double minPrice;
  double maxPrice;
  int? minBeds;
  int? maxBeds;
  int? minBaths;
  int? maxBaths;
  double? minArea;
  double? maxArea;
  List<String> selectedAmenities;
  double? minRating;
  bool? hasGarage;
  List<String> selectedLocations;
  // New filter options
  List<String> selectedPropertyTypes;
  List<String> selectedListingTypes;
  bool? hasVirtualTour;

  FilterCriteria({
    this.minPrice = 0,
    this.maxPrice = 500000000, // 500M CFA to accommodate both rent and sale properties
    this.minBeds,
    this.maxBeds,
    this.minBaths,
    this.maxBaths,
    this.minArea,
    this.maxArea,
    this.selectedAmenities = const [],
    this.minRating,
    this.hasGarage,
    this.selectedLocations = const [],
    this.selectedPropertyTypes = const [],
    this.selectedListingTypes = const [],
    this.hasVirtualTour,
  });

  FilterCriteria copyWith({
    double? minPrice,
    double? maxPrice,
    int? minBeds,
    int? maxBeds,
    int? minBaths,
    int? maxBaths,
    double? minArea,
    double? maxArea,
    List<String>? selectedAmenities,
    double? minRating,
    bool? hasGarage,
    List<String>? selectedLocations,
    List<String>? selectedPropertyTypes,
    List<String>? selectedListingTypes,
    bool? hasVirtualTour,
  }) {
    return FilterCriteria(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minBeds: minBeds ?? this.minBeds,
      maxBeds: maxBeds ?? this.maxBeds,
      minBaths: minBaths ?? this.minBaths,
      maxBaths: maxBaths ?? this.maxBaths,
      minArea: minArea ?? this.minArea,
      maxArea: maxArea ?? this.maxArea,
      selectedAmenities: selectedAmenities ?? this.selectedAmenities,
      minRating: minRating ?? this.minRating,
      hasGarage: hasGarage ?? this.hasGarage,
      selectedLocations: selectedLocations ?? this.selectedLocations,
      selectedPropertyTypes: selectedPropertyTypes ?? this.selectedPropertyTypes,
      selectedListingTypes: selectedListingTypes ?? this.selectedListingTypes,
      hasVirtualTour: hasVirtualTour ?? this.hasVirtualTour,
    );
  }

  bool get hasActiveFilters {
    return minPrice > 0 ||
        // Don't count maxPrice as active filter since it's set to a very high default
        minBeds != null ||
        maxBeds != null ||
        minBaths != null ||
        maxBaths != null ||
        minArea != null ||
        maxArea != null ||
        selectedAmenities.isNotEmpty ||
        minRating != null ||
        hasGarage != null ||
        selectedLocations.isNotEmpty ||
        selectedPropertyTypes.isNotEmpty ||
        selectedListingTypes.isNotEmpty ||
        hasVirtualTour != null;
  }

  FilterCriteria clear() {
    return FilterCriteria();
  }
}

class FilterDialog extends StatefulWidget {
  final FilterCriteria initialFilters;
  final List<String> availableAmenities;
  final List<String> availableLocations;

  const FilterDialog({
    super.key,
    required this.initialFilters,
    required this.availableAmenities,
    required this.availableLocations,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late FilterCriteria _filters;

  final List<String> _propertyTypes = ['House', 'Office', 'Apartment', 'Studio'];
  final List<String> _listingTypes = ['For Rent', 'For Sale'];

  @override
  void initState() {
    super.initState();
    _filters = FilterCriteria(
      minPrice: widget.initialFilters.minPrice,
      maxPrice: widget.initialFilters.maxPrice,
      minBeds: widget.initialFilters.minBeds,
      maxBeds: widget.initialFilters.maxBeds,
      minBaths: widget.initialFilters.minBaths,
      maxBaths: widget.initialFilters.maxBaths,
      minArea: widget.initialFilters.minArea,
      maxArea: widget.initialFilters.maxArea,
      selectedAmenities: List.from(widget.initialFilters.selectedAmenities),
      minRating: widget.initialFilters.minRating,
      hasGarage: widget.initialFilters.hasGarage,
      selectedLocations: List.from(widget.initialFilters.selectedLocations),
      selectedPropertyTypes: List.from(widget.initialFilters.selectedPropertyTypes),
      selectedListingTypes: List.from(widget.initialFilters.selectedListingTypes),
      hasVirtualTour: widget.initialFilters.hasVirtualTour,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.tune,
                      color: Colors.orange.shade700,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Filter Properties',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (_filters.hasActiveFilters)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _filters = _filters.clear();
                        });
                      },
                      icon: Icon(Icons.refresh, size: 18, color: Colors.orange.shade600),
                      label: Text(
                        'Clear',
                        style: TextStyle(color: Colors.orange.shade600),
                      ),
                    ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.grey),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      shape: const CircleBorder(),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Filter Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPropertyTypeFilter(),
                    const SizedBox(height: 24),
                    _buildListingTypeFilter(),
                    const SizedBox(height: 24),
                    _buildPriceRangeFilter(),
                    const SizedBox(height: 24),
                    _buildRoomsFilter(),
                    const SizedBox(height: 24),
                    _buildAreaFilter(),
                    const SizedBox(height: 24),
                    _buildLocationFilter(),
                    const SizedBox(height: 24),
                    _buildRatingFilter(),
                    const SizedBox(height: 24),
                    _buildAdditionalFilters(),
                    const SizedBox(height: 24),
                    _buildAmenitiesFilter(),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(_filters);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildPropertyTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Property Type'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _propertyTypes.map((type) {
            final isSelected = _filters.selectedPropertyTypes.contains(type);
            return _buildFilterChip(
              label: type,
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  final newTypes = List<String>.from(_filters.selectedPropertyTypes);
                  if (selected) {
                    newTypes.add(type);
                  } else {
                    newTypes.remove(type);
                  }
                  _filters = _filters.copyWith(selectedPropertyTypes: newTypes);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildListingTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Listing Type'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: _listingTypes.map((type) {
            final isSelected = _filters.selectedListingTypes.contains(type);
            return _buildFilterChip(
              label: type,
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  final newTypes = List<String>.from(_filters.selectedListingTypes);
                  if (selected) {
                    newTypes.add(type);
                  } else {
                    newTypes.remove(type);
                  }
                  _filters = _filters.copyWith(selectedListingTypes: newTypes);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Price Range (FCFA)'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildPriceTextField(
                      'Min Price',
                      _filters.minPrice.toInt().toString(),
                      (value) {
                        final price = double.tryParse(value) ?? 0;
                        setState(() {
                          _filters = _filters.copyWith(minPrice: price);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildPriceTextField(
                      'Max Price',
                      _filters.maxPrice.toInt().toString(),
                      (value) {
                        final price = double.tryParse(value) ?? 200000;
                        setState(() {
                          _filters = _filters.copyWith(maxPrice: price);
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              RangeSlider(
                values: RangeValues(_filters.minPrice, _filters.maxPrice),
                min: 0,
                max: 500000000,
                divisions: 20,
                activeColor: Colors.orange.shade600,
                inactiveColor: Colors.orange.shade200,
                onChanged: (RangeValues values) {
                  setState(() {
                    _filters = _filters.copyWith(
                      minPrice: values.start,
                      maxPrice: values.end,
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceTextField(String label, String value, Function(String) onChanged) {
    return TextFormField(
      initialValue: value,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixText: 'FCFA ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildRoomsFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Bedrooms & Bathrooms'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bedrooms', style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: [0, 1, 2, 3, 4, 5].map((count) {
                      final isSelected = _filters.minBeds == count;
                      return _buildChoiceChip(
                        count == 0 ? 'Any' : '$count+',
                        isSelected,
                        () {
                          setState(() {
                            _filters = _filters.copyWith(
                              minBeds: isSelected ? null : (count == 0 ? null : count),
                            );
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bathrooms', style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: [0, 1, 2, 3, 4].map((count) {
                      final isSelected = _filters.minBaths == count;
                      return _buildChoiceChip(
                        count == 0 ? 'Any' : '$count+',
                        isSelected,
                        () {
                          setState(() {
                            _filters = _filters.copyWith(
                              minBaths: isSelected ? null : (count == 0 ? null : count),
                            );
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAreaFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Property Area (sqm)'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: _filters.minArea?.toInt().toString() ?? '',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Min Area',
                  suffixText: 'sqm',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onChanged: (value) {
                  final area = double.tryParse(value);
                  setState(() {
                    _filters = _filters.copyWith(minArea: area);
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                initialValue: _filters.maxArea?.toInt().toString() ?? '',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Max Area',
                  suffixText: 'sqm',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onChanged: (value) {
                  final area = double.tryParse(value);
                  setState(() {
                    _filters = _filters.copyWith(maxArea: area);
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Location'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.availableLocations.map((location) {
            final isSelected = _filters.selectedLocations.contains(location);
            return _buildFilterChip(
              label: location,
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  final newLocations = List<String>.from(_filters.selectedLocations);
                  if (selected) {
                    newLocations.add(location);
                  } else {
                    newLocations.remove(location);
                  }
                  _filters = _filters.copyWith(selectedLocations: newLocations);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRatingFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Minimum Rating'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [0.0, 3.0, 3.5, 4.0, 4.5, 4.8].map((rating) {
            final isSelected = _filters.minRating == rating;
            return _buildChoiceChip(
              rating > 0 ? '$rating + ⭐' : 'Any',
              isSelected,
              () {
                setState(() {
                  _filters = _filters.copyWith(
                    minRating: isSelected ? null : (rating == 0 ? null : rating),
                  );
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAdditionalFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Additional Features'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildSwitchTile(
                'Has Garage',
                'Properties with parking garage',
                Icons.garage,
                _filters.hasGarage,
                (value) {
                  setState(() {
                    _filters = _filters.copyWith(hasGarage: value);
                  });
                },
              ),
              _buildSwitchTile(
                'Virtual Tour Available',
                'Properties with 360° virtual tours',
                Icons.view_in_ar,
                _filters.hasVirtualTour,
                (value) {
                  setState(() {
                    _filters = _filters.copyWith(hasVirtualTour: value);
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool? value, Function(bool?) onChanged) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange.shade600),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      trailing: Switch(
        value: value ?? false,
        onChanged: onChanged,
        activeColor: Colors.orange.shade600,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildAmenitiesFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Amenities'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.availableAmenities.map((amenity) {
            final isSelected = _filters.selectedAmenities.contains(amenity);
            return _buildFilterChip(
              label: amenity,
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  final newAmenities = List<String>.from(_filters.selectedAmenities);
                  if (selected) {
                    newAmenities.add(amenity);
                  } else {
                    newAmenities.remove(amenity);
                  }
                  _filters = _filters.copyWith(selectedAmenities: newAmenities);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required Function(bool) onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: Colors.white,
      selectedColor: Colors.orange.shade100,
      checkmarkColor: Colors.orange.shade700,
      side: BorderSide(
        color: selected ? Colors.orange.shade300 : Colors.grey.shade300,
      ),
      labelStyle: TextStyle(
        color: selected ? Colors.orange.shade800 : Colors.grey.shade700,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildChoiceChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.orange.shade100 : Colors.white,
          border: Border.all(
            color: selected ? Colors.orange.shade300 : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.orange.shade800 : Colors.grey.shade700,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// Helper function to show the filter dialog
Future<FilterCriteria?> showFilterDialog({
  required BuildContext context,
  required FilterCriteria currentFilters,
  required List<String> availableAmenities,
  required List<String> availableLocations,
}) {
  return showDialog<FilterCriteria>(
    context: context,
    builder: (context) => FilterDialog(
      initialFilters: currentFilters,
      availableAmenities: availableAmenities,
      availableLocations: availableLocations,
    ),
  );
}