import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ScreenUtil 추가
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';

// files
import 'package:to_do_list/config/theme.dart';

// 새로운 디자인에서는 이 위젯이 필요하지 않지만, 
// 기존 코드 호환성을 위해 최소한의 기능만 유지
class InfoWidget extends StatefulWidget {
  const InfoWidget({super.key});

  @override
  State<InfoWidget> createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  var weekDayList = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  Widget build(BuildContext context) {
    // 새로운 디자인에서는 이 정보가 더 이상 필요하지 않으므로 
    // 빈 컨테이너를 반환하거나 간단한 정보만 표시 (반응형으로 수정)
    return Container(
      padding: EdgeInsets.all(12.w), // 20 → 12.w로 조정
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(12.r), // 20 → 12.r로 조정
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TimerBuilder.periodic(Duration(minutes: 1), builder: (context) {
            DateTime dt = DateTime.now();
            return Text(
              '${dt.year}년 ${dt.month}월 ${dt.day}일 ${weekDayList[dt.weekday - 1]}요일',
              style: TextStyles.caption,
            );
          }),
          SizedBox(height: 6.h), // 8 → 6.h로 조정
          TimerBuilder.periodic(Duration(minutes: 1), builder: (context) {
            DateTime dt = DateTime.now();
            return Text(
              DateFormat('HH:mm').format(dt),
              style: TextStyles.caption,
            );
          }),
          SizedBox(height: 12.h), // 16 → 12.h로 조정
          Text(
            'tasks : 3',
            style: TextStyles.small,
          ),
          Text(
            'D-day tasks : 2',
            style: TextStyles.small,
          ),
        ],
      ),
    );
  }
}
