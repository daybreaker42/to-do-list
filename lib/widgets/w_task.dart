import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ScreenUtil 추가
import 'package:to_do_list/config/theme.dart';

// 새로운 디자인에서는 홈 화면에서 직접 태스크를 렌더링하므로
// 이 위젯은 호환성을 위해 유지하되 새로운 디자인 시스템 사용
class Task extends StatefulWidget {
  final String title;
  final String content;
  final String date;
  final bool isStarred;
  final bool isDueDate;
  final bool isFinished;

  const Task({
    super.key,
    required this.title,
    required this.content,
    required this.date,
    required this.isStarred,
    required this.isDueDate,
    required this.isFinished,
  });

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  bool? _isFinished;
  bool? _isStarred;
  bool? _isDday;

  @override
  void initState() {
    super.initState();
    _isFinished = widget.isFinished;
    _isStarred = widget.isStarred;
    _isDday = widget.isDueDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h), // 20 → 12.h로 조정
      padding: EdgeInsets.all(12.w), // 20 → 12.w로 조정
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(12.r), // 20 → 12.r로 조정
      ),
      child: Row(
        children: [
          // 체크박스 (새로운 디자인 스타일, 반응형으로 수정)
          GestureDetector(
            onTap: () {
              setState(() {
                _isFinished = !_isFinished!;
              });
            },
            child: Container(
              width: 20.w, // 50 → 20.w로 조정
              height: 20.w, // 50 → 20.w로 조정 (정사각형 유지)
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.highlight,
                  width: 1.5.w, // 2 → 1.5.w로 조정
                ),
                color: _isFinished! ? AppColors.highlight : Colors.transparent,
              ),
              child: _isFinished!
                  ? Icon(
                      Icons.check,
                      color: AppColors.background,
                      size: 14.sp, // 25 → 14.sp로 조정
                    )
                  : Container(
                      margin: EdgeInsets.all(2.w), // 4 → 2.w로 조정
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.background,
                      ),
                    ),
            ),
          ),
          
          SizedBox(width: 12.w), // 20 → 12.w로 조정

          // 태스크 제목
          Expanded(
            child: Text(
              widget.title,
              style: TextStyles.taskTitle, // fontSize 60 제거하고 기본 스타일 사용
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // 상태 아이콘들 (반응형으로 수정)
          if (_isStarred!)
            Padding(
              padding: EdgeInsets.only(left: 8.w), // 10 → 8.w로 조정
              child: Icon(
                Icons.star,
                color: AppColors.warning,
                size: 16.sp, // 20 → 16.sp로 조정
              ),
            ),
          
          if (_isDday!)
            Padding(
              padding: EdgeInsets.only(left: 6.w), // 8 → 6.w로 조정
              child: Icon(
                Icons.schedule,
                color: AppColors.error,
                size: 16.sp, // 20 → 16.sp로 조정
              ),
            ),
        ],
      ),
    );
  }
}
