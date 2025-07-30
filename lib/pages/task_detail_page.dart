import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ScreenUtil 추가
import 'package:go_router/go_router.dart'; // GoRouter import 추가
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
      // 일반 AppBar 사용 (반응형으로 수정)
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false, // 기본 뒤로가기 버튼 제거
        toolbarHeight: 56.h, // AppBar 높이 조정
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 4.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 뒤로가기 버튼
            GestureDetector(
              onTap: () {
                context.go('/home'); // GoRouter 사용
              },
              child: Icon(
                Icons.arrow_back,
                color: AppColors.highlight,
                size: 24.sp,
              ),
            ),
            // 중앙 여백
            Spacer(),
            // 고정하기 버튼과 더보기 버튼
            Row(
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
                        : AppColors.accentText,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Icon(
                  Icons.more_vert,
                  color: AppColors.highlight,
                  size: 24.sp,
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w), // 24.w → 20.w로 조정
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h), // 32.h → 24.h로 조정
            
            // 태스크 제목 입력
            Text(
              _titleController.text,
              style: TextStyles.detailTitle,
            ),
            
            SizedBox(height: 32.h), // 40.h → 32.h로 조정
            
            // 상세정보 입력 필드
            TextField(
              controller: _descriptionController,
              style: TextStyles.detailSubTitle,
              decoration: InputDecoration(
                hintText: '상세정보 작성..',
                hintStyle: TextStyles.detailSubTitle,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              maxLines: null,
            ),
            
            SizedBox(height: 32.h), // 40.h → 32.h로 조정
            
            // 완료일 설정 버튼
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: AppColors.highlight,
                  size: 20.sp, // 24.sp → 20.sp로 조정
                ),
                SizedBox(width: 10.w), // 12.w → 10.w로 조정
                Text(
                  '완료일 설정하기',
                  style: TextStyles.detailSubTitle,
                ),
              ],
            ),
            
            SizedBox(height: 32.h), // 40.h → 32.h로 조정
            
            // 하위 할 일 추가 버튼
            Row(
              children: [
                Icon(
                  Icons.add,
                  color: AppColors.secondaryText,
                  size: 20.sp, // 24.sp → 20.sp로 조정
                ),
                SizedBox(width: 10.w), // 12.w → 10.w로 조정
                Text(
                  '하위 할 일 추가하기',
                  style: TextStyles.detailSubTitle,
                ),
              ],
            ),
            
            SizedBox(height: 48.h), // 60.h → 48.h로 조정
            
            // 수정한 시각 정보
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '수정한 시각',
                    style: TextStyles.small.copyWith(
                      color: AppColors.lightGrayText,
                    ),
                  ),
                  SizedBox(height: 4.h), // 6.h → 4.h로 조정
                  Text(
                    _lastModified,
                    style: TextStyles.small.copyWith(
                      color: AppColors.lightGrayText,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 40.h), // 60.h → 40.h로 조정 (하단 여백)
          ],
        ),
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
