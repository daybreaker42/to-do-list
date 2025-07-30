import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/theme.dart';

class TaskDetailPage extends StatefulWidget {
  final Map<String, dynamic>? taskData;
  
  const TaskDetailPage({super.key, this.taskData});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  bool _isPinned = false;
  String _lastModified = '';

  @override
  void initState() {
    super.initState();
    
    if (widget.taskData != null) {
      _titleController.text = widget.taskData!['title'] ?? '';
      _descriptionController.text = widget.taskData!['description'] ?? '';
      _isPinned = widget.taskData!['isPinned'] ?? false;
    } else {
      _titleController.text = '할 일 1';
    }
    
    _lastModified = '2024-01-01 18:34';
  }

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
                          padding: EdgeInsets.only(left: 48),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: AppColors.highlight,
                              size: 36,
                            ),
                          ),
                        ),
                        // 빈 공간 (중앙 정렬용)
                        Spacer(),
                        // 고정하기 버튼과 더보기 버튼
                        Padding(
                          padding: EdgeInsets.only(right: 48),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isPinned = !_isPinned;
                                  });
                                },
                                child: Icon(
                                  Icons.push_pin,
                                  color: _isPinned 
                                      ? AppColors.highlight 
                                      : AppColors.highlight,
                                  size: 40,
                                ),
                              ),
                              SizedBox(width: 25),
                              Icon(
                                Icons.more_vert,
                                color: AppColors.highlight,
                                size: 49,
                              ),
                            ],
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
                padding: EdgeInsets.symmetric(horizontal: 71),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    
                    // 태스크 제목 입력
                    Text(
                      _titleController.text,
                      style: TextStyles.detailTitle,
                    ),
                    
                    SizedBox(height: 60),
                    
                    // 상세정보 입력 필드
                    TextField(
                      controller: _descriptionController,
                      style: TextStyles.detailSubTitle,
                      decoration: InputDecoration(
                        hintText: '상세정보 작성..',
                        hintStyle: TextStyles.detailSubTitle,
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                    
                    SizedBox(height: 60),
                    
                    // 완료일 설정 버튼
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: AppColors.highlight,
                          size: 45,
                        ),
                        SizedBox(width: 20),
                        Text(
                          '완료일 설정하기',
                          style: TextStyles.detailSubTitle,
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 60),
                    
                    // 하위 할 일 추가 버튼
                    Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: AppColors.secondaryText,
                          size: 60,
                        ),
                        SizedBox(width: 20),
                        Text(
                          '하위 할 일 추가하기',
                          style: TextStyles.detailSubTitle,
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 100),
                    
                    // 수정한 시각 정보
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '수정한 시각',
                          style: TextStyles.small.copyWith(
                            color: AppColors.lightGrayText,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _lastModified,
                          style: TextStyles.small.copyWith(
                            color: AppColors.lightGrayText,
                          ),
                        ),
                      ],
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
