import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// file imports
import 'config/theme.dart';
import 'widgets/w_task_widget.dart'; // TaskWidget import 추가
import 'pages/tag_list_page.dart';
import 'pages/task_detail_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // 태스크 데이터 (새로운 디자인에 맞게 구조화)
  List<Map<String, dynamic>> tasks = [
    {
      'id': 1,
      'title': '할 일 1번',
      'description': '상세정보상세정보12312312312312...',
      'isCompleted': false,
      'isPinned': true,
      'tags': ['고정됨'],
      'hasSubtasks': true,
    },
    {
      'id': 2,
      'title': 'longlongtext12312312...',
      'description': '',
      'isCompleted': true,
      'isPinned': false,
      'tags': [],
      'hasSubtasks': false,
    },
    {
      'id': 3,
      'title': 'subtask123123',
      'description': '',
      'isCompleted': false,
      'isPinned': false,
      'tags': [],
      'hasSubtasks': false,
      'isSubtask': true,
    },
    {
      'id': 4,
      'title': '내용을 입력하세요...',
      'description': '',
      'isCompleted': false,
      'isPinned': false,
      'tags': ['오늘까지'],
      'hasSubtasks': false,
      'placeholder': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // 시스템 UI 스타일 설정
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // 새로운 디자인의 헤더 (블러 효과 포함)
          SliverAppBar(
            expandedHeight: 180.h, // 220 → 180.h로 조정
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
                      blurRadius: 4.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50.h), // 상태바 공간
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 뒤로가기 버튼
                        Padding(
                          padding: EdgeInsets.only(left: 24.w), // 48 → 24.w로 조정
                          child: GestureDetector(
                            onTap: () {
                              // 태그 목록 페이지로 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TagListPage(),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: AppColors.highlight,
                              size: 24.sp, // 36 → 24.sp로 조정
                            ),
                          ),
                        ),
                        // 메인 타이틀
                        Text('To-do', style: TextStyles.mainTitle),
                        // 더보기 버튼과 추가 버튼
                        Padding(
                          padding:
                              EdgeInsets.only(right: 24.w), // 48 → 24.w로 조정
                          child: Row(
                            children: [
                              Icon(
                                Icons.more_vert,
                                color: AppColors.highlight,
                                size: 24.sp, // 60 → 24.sp로 조정
                              ),
                              SizedBox(width: 12.w), // 20 → 12.w로 조정
                              Icon(
                                Icons.add,
                                color: AppColors.primaryText,
                                size: 20.sp, // 33 → 20.sp로 조정
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h), // 20 → 16.h로 조정
                    // 태그 목록 텍스트
                    Padding(
                      padding: EdgeInsets.only(left: 40.w), // 106 → 40.w로 조정
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // 태그 목록 페이지로 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TagListPage(),
                                ),
                              );
                            },
                            child: Text('태그 목록', style: TextStyles.subTitle),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h), // 10 → 8.h로 조정
                    // 해시태그 아이콘
                    Padding(
                      padding: EdgeInsets.only(right: 40.w), // 80 → 40.w로 조정
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('#', style: TextStyles.mainTitle),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // 메인 컨텐츠 (반응형으로 수정)
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 32.w), // 84 → 32.w로 조정
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h), // 30 → 20.h로 조정
                    // 태스크 리스트
                    ...tasks.map((task) => _buildTaskItem(task)).toList(),
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

  // 새로운 디자인의 태스크 아이템 위젯 (반응형으로 수정)
  Widget _buildTaskItem(Map<String, dynamic> task) {
    return GestureDetector(
      onTap: () {
        // 태스크 상세 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailPage(taskData: task),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h), // 20 → 16.h로 조정
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 체크박스 (새로운 디자인, 반응형으로 수정)
            GestureDetector(
              onTap: () {
                setState(() {
                  task['isCompleted'] = !task['isCompleted'];
                });
              },
              child: Container(
                width: 24.w, // 70 → 24.w로 조정
                height: 24.w, // 70 → 24.w로 조정 (정사각형 유지)
                margin: EdgeInsets.only(right: 16.w), // 45 → 16.w로 조정
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.highlight,
                    width: 1.5.w, // 2 → 1.5.w로 조정
                  ),
                  color: task['isCompleted']
                      ? AppColors.highlight
                      : Colors.transparent,
                ),
                child: task['isCompleted']
                    ? Icon(
                        Icons.check,
                        color: AppColors.background,
                        size: 16.sp, // 35 → 16.sp로 조정
                      )
                    : Container(
                        margin: EdgeInsets.all(2.w), // 6 → 2.w로 조정
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.background,
                        ),
                      ),
              ),
            ),

            // 태스크 내용
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 태스크 제목
                  Text(
                    task['title'],
                    style: task['placeholder'] == true
                        ? TextStyles.placeholder
                        : TextStyles.taskTitle,
                  ),

                  // 태스크 설명 (있는 경우)
                  if (task['description'] != null &&
                      task['description'].toString().isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h), // 8 → 4.h로 조정
                      child: Text(
                        task['description'],
                        style: TextStyles.caption,
                      ),
                    ),

                  // 태그들 (있는 경우)
                  if (task['tags'] != null && task['tags'].isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h), // 12 → 8.h로 조정
                      child: Wrap(
                        spacing: 6.w, // 8 → 6.w로 조정
                        runSpacing: 3.h, // 4 → 3.h로 조정
                        children: task['tags']
                            .map<Widget>((tag) => Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, // 12 → 8.w로 조정
                                      vertical: 4.h), // 6 → 4.h로 조정
                                  decoration: BoxDecoration(
                                    color: AppColors.accentText,
                                    borderRadius: BorderRadius.circular(
                                        8.r), // 12 → 8.r로 조정
                                  ),
                                  child: Text(
                                    tag,
                                    style: TextStyles.small.copyWith(
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),

            // 우측 아이콘들 (고정, 알림 등) - 반응형으로 수정
            if (task['isPinned'] == true)
              Padding(
                padding: EdgeInsets.only(left: 12.w), // 20 → 12.w로 조정
                child: Icon(
                  Icons.push_pin,
                  color: AppColors.accentText,
                  size: 18.sp, // 26 → 18.sp로 조정
                ),
              ),

            if (task['tags']?.contains('오늘까지') == true)
              Padding(
                padding: EdgeInsets.only(left: 8.w), // 12 → 8.w로 조정
                child: Icon(
                  Icons.schedule,
                  color: AppColors.secondaryText,
                  size: 20.sp, // 38 → 20.sp로 조정
                ),
              ),

            if (task['tags']?.contains('추가됨') == true)
              Padding(
                padding: EdgeInsets.only(left: 8.w), // 12 → 8.w로 조정
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '추가됨',
                      style: TextStyles.small.copyWith(
                        color: AppColors.accentText,
                      ),
                    ),
                    SizedBox(width: 3.w), // 4 → 3.w로 조정
                    Icon(
                      Icons.schedule,
                      color: AppColors.secondaryText,
                      size: 12.sp, // 16 → 12.sp로 조정
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
