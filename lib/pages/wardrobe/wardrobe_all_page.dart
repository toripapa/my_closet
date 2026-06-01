import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// 전체 옷장 페이지
class WardrobeAllPage extends StatefulWidget {
  const WardrobeAllPage({super.key});

  @override
  State<WardrobeAllPage> createState() => _WardrobeAllPageState();
}

class _WardrobeAllPageState extends State<WardrobeAllPage> {
  String _selectedCategory = '전체';
  final _categories = ['전체', '상의', '하의', '아우터', '원피스', '신발', '가방'];

  final _items = [
    ('화이트 티셔츠', '상의', Icons.checkroom),
    ('블랙 슬랙스', '하의', Icons.checkroom),
    ('네이비 재킷', '아우터', Icons.checkroom),
    ('그레이 후드', '상의', Icons.checkroom),
    ('데님 청바지', '하의', Icons.checkroom),
    ('화이트 스니커즈', '신발', Icons.checkroom),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 검색바
        Padding(
          padding: const EdgeInsets.all(AppSpacing.s2),
          child: TextField(
            decoration: InputDecoration(
              hintText: '옷 검색...',
              prefixIcon: const Icon(Icons.search, size: 20),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s2,
                vertical: 10,
              ),
              isDense: true,
            ),
          ),
        ),

        // 카테고리 필터
        SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2),
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final cat = _categories[i];
              final selected = cat == _selectedCategory;
              return ChoiceChip(
                label: Text(cat, style: const TextStyle(fontSize: 12)),
                selected: selected,
                onSelected: (_) => setState(() => _selectedCategory = cat),
                selectedColor: AppColors.textMain,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : AppColors.textMain,
                ),
                side: const BorderSide(color: AppColors.border),
                backgroundColor: Colors.white,
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.s2),

        // 아이템 그리드
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: AppSpacing.s2,
                mainAxisSpacing: AppSpacing.s2,
                childAspectRatio: 0.8,
              ),
              itemCount: _items.length,
              itemBuilder: (context, i) {
                final item = _items[i];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.$3, size: 40, color: AppColors.textAccent),
                      const SizedBox(height: 8),
                      Text(
                        item.$1,
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        item.$2,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textAccent,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

