import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';

// files
import 'package:to_do_list/config/theme.dart';

class InfoWidget extends StatefulWidget {
  const InfoWidget({super.key});

  @override
  State<InfoWidget> createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  var dateWidget;
  var currTimeWidget;
  var total_task_num;
  var dday_dask_num;
  var weekDayList = ['월', '화', '수', '목', '금', '토', '일'];

  void addTotal_task_num() {}

  void updateTime() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // var dt = DateTime.now();
    // date =
    //     '${dt.year}년 ${dt.month}월 ${dt.day}일 ${weekDayList[dteekday - 1]}요일';
    // currTime = '${dt.hour}:${dt.minute}';
  }

  @override
  Widget build(BuildContext context) {
    // 화면 크기에 따라 동적으로 스타일 조정
    final size = MediaQuery.of(context).size;
    final double horizontalPadding = size.width * 0.05; // 약 5% 패딩
    final double verticalPadding = size.height * 0.02; // 약 2% 패딩
    final double borderRadius = size.width * 0.04; // 약 4% radius
    final double borderWidth = size.width * 0.003; // 약 0.3% border
    final double titleFontSize = size.width * 0.045; // 날짜/시간 폰트
    final double infoFontSize = size.width * 0.035; // tasks 폰트

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding * 2, horizontal: horizontalPadding),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff0A0A0A), width: borderWidth),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        color: Color(0xff181818), // 배경색 추가
      ),
      margin: EdgeInsets.only(bottom: verticalPadding * 2), // 아래 마진 추가
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            child: Column(children: [
              TimerBuilder.periodic(Duration(minutes: 1), builder: (context) {
                DateTime dt = DateTime.now();
                dt = dt.add(Duration(hours: 9));
                return Text(
                  '${dt.year}년 ${dt.month}월 ${dt.day}일 ${weekDayList[dt.weekday - 1]}요일',
                  style: TextStyle(
                    fontFamily: 'pretendard',
                    fontWeight: FontWeight.bold,
                    fontSize: titleFontSize,
                    color: Colors.white,
                  ),
                );
              }),
              TimerBuilder.periodic(Duration(minutes: 1), builder: (context) {
                DateTime dt = DateTime.now();
                dt = dt.add(Duration(hours: 9));
                return Text(
                  DateFormat('HH:mm').format(dt),
                  style: TextStyle(
                    fontFamily: 'pretendard',
                    fontWeight: FontWeight.bold,
                    fontSize: titleFontSize,
                    color: Colors.white,
                  ),
                );
              }),
            ]),
          ),
          SizedBox(height: verticalPadding),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('tasks : 3',
                style: TextStyle(
                  fontFamily: 'pretendard',
                  fontWeight: FontWeight.bold,
                  fontSize: infoFontSize,
                  color: Colors.white,
                )),
            Text('D-day tasks : 2',
                style: TextStyle(
                  fontFamily: 'pretendard',
                  fontWeight: FontWeight.bold,
                  fontSize: infoFontSize,
                  color: Colors.white,
                )),
          ])
        ],
      ),
    );
  }
}
