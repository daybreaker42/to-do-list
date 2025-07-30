import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ScreenUtil 추가
import 'package:go_router/go_router.dart'; // GoRouter import 추가
import '../config/theme.dart';

class TagListPage extends StatefulWidget {
  const TagListPage({super.key});

  @override
  State<TagListPage> createState() => _TagListPageState();
}

class _TagListPageState extends State<TagListPage> {
  final TextEditingController _searchController = TextEditingController();
  
  // 태그 데이터 (새로운 디자인에 맞게)
  List<Map<String, dynamic>> tags = [
    {
      'name': '고정됨',
      'count': 59,
      'isPinned': true,
    },
    {
      'name': 'all',
      'count': 59,
      'isPinned': false,
    },
    {
      'name': '할 일 1번',
      'count': 59,
      'isPinned': false,
    },
  ];
  
  List<Map<String, dynamic>> dailyTasks = [
    {
      'name': '오늘',
      'count': 59,
      'date': null,
    },
    {
      'name': '2024-01-01',
      'count': 59,
      'date': '2024-01-01',
    },
    {
      'name': '2023-12-31',
      'count': 59,
      'date': '2023-12-31',
    },
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // 헤더 (AppBar로 통합, 반응형으로 수정)
          SliverAppBar(
            expandedHeight: 180.h, // 220 → 180.h로 조정
            floating: false,
            pinned: true,
            backgroundColor: AppColors.background,
            automaticallyImplyLeading: false, // 기본 뒤로가기 버튼 제거
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4.r, // 반응형으로 수정
                      offset: Offset(0, 4.h), // 반응형으로 수정
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w), // 반응형 패딩
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 뒤로가기 버튼 (반응형으로 수정)
                        GestureDetector(
                          onTap: () {
                            context.go('/home'); // GoRouter 사용
                          },
                          child: Icon(
                            Icons.keyboard_arrow_left,
                            color: AppColors.highlight,
                            size: 24.sp, // 16 → 24.sp로 조정
                          ),
                        ),
                        // 메인 타이틀
                        Text('태그 목록', style: TextStyles.mainTitle),
                        // 더보기 버튼 (반응형으로 수정)
                        Icon(
                          Icons.more_vert,
                          color: AppColors.highlight,
                          size: 24.sp, // 49 → 24.sp로 조정
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // 메인 컨텐츠 (반응형으로 수정)
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 24.w), // 39 → 24.w로 조정
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h), // 30 → 20.h로 조정
                    
                    // 검색창 (반응형으로 수정)
                    Container(
                      width: double.infinity, // 996 → 전체 너비로 변경
                      height: 48.h, // 124 → 48.h로 조정
                      decoration: BoxDecoration(
                        color: AppColors.searchBackground,
                        borderRadius:
                            BorderRadius.circular(24.r), // 30 → 24.r로 조정
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w), // 20 → 16.w로 조정
                            child: Icon(
                              Icons.search,
                              color: AppColors.border,
                              size: 20.sp, // 50 → 20.sp로 조정
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: TextStyles
                                  .taskTitle, // mainTitle → taskTitle로 변경
                              decoration: InputDecoration(
                                hintText: '검색창',
                                hintStyle: TextStyles
                                    .taskTitle, // mainTitle → taskTitle로 변경
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 24.h), // 40 → 24.h로 조정
                    
                    // 구분선 (반응형으로 수정)
                    Container(
                      width: double.infinity, // 1100 → 전체 너비로 변경
                      height: 1.h, // 1 → 1.h로 조정
                      color: AppColors.searchBackground,
                    ),
                    
                    SizedBox(height: 20.h), // 30 → 20.h로 조정
                    
                    // 태그 리스트 섹션
                    Text('태그 리스트', style: TextStyles.sectionTitle),
                    SizedBox(height: 16.h), // 20 → 16.h로 조정
                    
                    // 태그 목록
                    ...tags.map((tag) => _buildTagItem(tag)).toList(),
                    
                    Padding(
                      padding:
                          EdgeInsets.only(right: 16.w, top: 16.h), // 반응형으로 수정
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '더보기',
                          style: TextStyles.small.copyWith(
                            color: AppColors.highlight,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 24.h), // 40 → 24.h로 조정
                    
                    // 구분선 (반응형으로 수정)
                    Container(
                      width: double.infinity, // 1100 → 전체 너비로 변경
                      height: 1.h, // 1 → 1.h로 조정
                      color: AppColors.searchBackground,
                    ),
                    
                    SizedBox(height: 20.h), // 30 → 20.h로 조정
                    
                    // Daily Task 섹션
                    Text('Daily Task', style: TextStyles.sectionTitle),
                    SizedBox(height: 16.h), // 20 → 16.h로 조정
                    
                    // Daily Task 목록
                    ...dailyTasks.map((task) => _buildDailyTaskItem(task)).toList(),
                    
                    Padding(
                      padding:
                          EdgeInsets.only(right: 16.w, top: 16.h), // 반응형으로 수정
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '더보기',
                          style: TextStyles.small.copyWith(
                            color: AppColors.highlight,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 60.h), // 100 → 60.h로 조정 (하단 여백)
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  // 태그 아이템 위젯 (반응형으로 수정)
  Widget _buildTagItem(Map<String, dynamic> tag) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h), // 15 → 12.h로 조정
      child: Row(
        children: [
          // 해시태그 심볼
          Text('#', style: TextStyles.subTitle),
          SizedBox(width: 12.w), // 20 → 12.w로 조정
          
          // 태그 이름
          Expanded(
            child: Text(
              tag['name'],
              style: TextStyles.subTitle,
            ),
          ),
          
          // 카운트
          Text(
            tag['count'].toString(),
            style: TextStyles.subTitle.copyWith(
              color: AppColors.grayText,
            ),
          ),
        ],
      ),
    );
  }

  // Daily Task 아이템 위젯 (반응형으로 수정)
  Widget _buildDailyTaskItem(Map<String, dynamic> task) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h), // 15 → 12.h로 조정
      child: Row(
        children: [
          SizedBox(width: 24.w), // 36 → 24.w로 조정 (해시태그 자리만큼 띄우기)
          
          // 태스크 이름
          Expanded(
            child: Text(
              task['name'],
              style: TextStyles.subTitle,
            ),
          ),
          
          // 카운트
          Text(
            task['count'].toString(),
            style: TextStyles.subTitle.copyWith(
              color: AppColors.grayText,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
