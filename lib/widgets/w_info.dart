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
    return Container(
      // height: 392,
      padding: EdgeInsets.symmetric(vertical: 35, horizontal: 96),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff0A0A0A), width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            child: Column(children: [
              // Text(date, style: TextStyles.title2),
              TimerBuilder.periodic(Duration(minutes: 1), builder: (context) {
                DateTime dt = DateTime.now();
                // 시간 보정
                dt = dt.add(Duration(hours: 9));
                return Text(
                    '${dt.year}년 ${dt.month}월 ${dt.day}일 ${weekDayList[dt.weekday - 1]}요일',
                    style: TextStyles.title2);
              }),
              TimerBuilder.periodic(Duration(minutes: 1), builder: (context) {
                DateTime dt = DateTime.now();
                // 시간 보정
                dt = dt.add(Duration(hours: 9));
                // return Text(DateFormat('HH:mm:ss').format(dt),
                return Text(DateFormat('HH:mm').format(dt),
                    style: TextStyles.title2);
              }),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('tasks : 3', style: TextStyles.title3),
            Text('D-day tasks : 2', style: TextStyles.title3),
          ])
        ],
      ),
    );
  }
}
