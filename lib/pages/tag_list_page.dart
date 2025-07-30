import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          // 헤더 (블러 효과 포함)
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50), // 상태바 공간
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 뒤로가기 버튼
                        Padding(
                          padding: EdgeInsets.only(left: 93),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.keyboard_arrow_left,
                              color: AppColors.highlight,
                              size: 16,
                            ),
                          ),
                        ),
                        // 메인 타이틀
                        Text('태그 목록', style: TextStyles.mainTitle),
                        // 더보기 버튼
                        Padding(
                          padding: EdgeInsets.only(right: 93),
                          child: Icon(
                            Icons.more_vert,
                            color: AppColors.highlight,
                            size: 49,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // 메인 컨텐츠
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 39),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    
                    // 검색창
                    Container(
                      width: 996,
                      height: 124,
                      decoration: BoxDecoration(
                        color: AppColors.searchBackground,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(
                              Icons.search,
                              color: AppColors.border,
                              size: 50,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: TextStyles.mainTitle,
                              decoration: InputDecoration(
                                hintText: '검색창',
                                hintStyle: TextStyles.mainTitle,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 40),
                    
                    // 구분선
                    Container(
                      width: 1100,
                      height: 1,
                      color: AppColors.searchBackground,
                    ),
                    
                    SizedBox(height: 30),
                    
                    // 태그 리스트 섹션
                    Text('태그 리스트', style: TextStyles.sectionTitle),
                    SizedBox(height: 20),
                    
                    // 태그 목록
                    ...tags.map((tag) => _buildTagItem(tag)).toList(),
                    
                    Padding(
                      padding: EdgeInsets.only(right: 20, top: 20),
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
                    
                    SizedBox(height: 40),
                    
                    // 구분선
                    Container(
                      width: 1100,
                      height: 1,
                      color: AppColors.searchBackground,
                    ),
                    
                    SizedBox(height: 30),
                    
                    // Daily Task 섹션
                    Text('Daily Task', style: TextStyles.sectionTitle),
                    SizedBox(height: 20),
                    
                    // Daily Task 목록
                    ...dailyTasks.map((task) => _buildDailyTaskItem(task)).toList(),
                    
                    Padding(
                      padding: EdgeInsets.only(right: 20, top: 20),
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
                    
                    SizedBox(height: 100), // 하단 여백
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  // 태그 아이템 위젯
  Widget _buildTagItem(Map<String, dynamic> tag) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          // 해시태그 심볼
          Text('#', style: TextStyles.subTitle),
          SizedBox(width: 20),
          
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

  // Daily Task 아이템 위젯
  Widget _buildDailyTaskItem(Map<String, dynamic> task) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          SizedBox(width: 36), // 해시태그 자리만큼 띄우기
          
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
