import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_list/config/theme.dart';

/// 홈 화면에서 사용하는 태스크 위젯
/// 새로운 디자인에 맞는 반응형 태스크 아이템
class TaskWidget extends StatefulWidget {
  final Map<String, dynamic> todo;

  const TaskWidget({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h), // 반응형 마진
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 체크박스
          GestureDetector(
            onTap: () {
              setState(() {
                widget.todo['isCompleted'] = !widget.todo['isCompleted'];
              });
            },
            child: Container(
              width: 20.w, // 반응형 크기
              height: 20.w, // 반응형 크기 (정사각형 유지)
              margin: EdgeInsets.only(right: 12.w), // 반응형 마진
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.highlight,
                  width: 1.5.w, // 반응형 너비
                ),
                color: widget.todo['isCompleted']
                    ? AppColors.highlight
                    : Colors.transparent,
              ),
              child: widget.todo['isCompleted']
                  ? Icon(
                      Icons.check,
                      color: AppColors.background,
                      size: 14.sp, // 반응형 아이콘 크기
                    )
                  : Container(
                      margin: EdgeInsets.all(2.w), // 반응형 마진
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
                  widget.todo['title'] ?? '제목 없음',
                  style: widget.todo['placeholder'] == true
                      ? TextStyles.placeholder
                      : TextStyles.taskTitle,
                ),

                // 태스크 설명 (있는 경우)
                if (widget.todo['description'] != null &&
                    widget.todo['description'].toString().isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h), // 반응형 패딩
                    child: Text(
                      widget.todo['description'],
                      style: TextStyles.caption,
                    ),
                  ),

                // 태그들 (있는 경우)
                if (widget.todo['tags'] != null && widget.todo['tags'].isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 6.h), // 반응형 패딩
                    child: Wrap(
                      spacing: 4.w, // 반응형 간격
                      runSpacing: 2.h, // 반응형 간격
                      children: widget.todo['tags']
                          .map<Widget>((tag) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.w, // 반응형 패딩
                                    vertical: 3.h), // 반응형 패딩
                                decoration: BoxDecoration(
                                  color: AppColors.accentText,
                                  borderRadius: BorderRadius.circular(6.r), // 반응형 반지름
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
        ],
      ),
    );
  }
}
