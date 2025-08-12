import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool hasActiveFilters;
  final int activeFilterCount;

  const FilterButton({
    super.key,
    required this.onPressed,
    this.hasActiveFilters = false,
    this.activeFilterCount = 0,
  });

  @override
  Widget build(BuildContext context) {
        return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: hasActiveFilters ? Colors.orange.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasActiveFilters ? Colors.orange.shade300 : Colors.grey.shade300,
          width: 1.5,
        ),
        boxShadow: [
          if (hasActiveFilters)
            BoxShadow(
              color: Colors.orange.shade100.withValues(alpha:0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.tune),
            iconSize: 22,
            color: hasActiveFilters ? Colors.orange.shade700 : Colors.grey.shade600,
            onPressed: onPressed,
            tooltip: 'Filter Properties',
            padding: EdgeInsets.zero,
            splashRadius: 20,
            splashColor: Colors.orange.shade100,
          ),
          if (hasActiveFilters && activeFilterCount > 0)
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade600,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.shade300.withValues(alpha:0.5),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Text(
                  activeFilterCount > 9 ? '9+' : activeFilterCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}