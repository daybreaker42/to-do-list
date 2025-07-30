import 'package:flutter/material.dart';
import 'package:to_do_list/config/theme.dart';

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
  String? _title;
  bool? _isFinished;
  bool? _isStarred;
  bool? _isDday;
  dynamic task_status;

  // task 위젯의 상태(isStarred, isDueDate)를 화면에 그려주는 함수
  // TODO - 해당 메소드 provider을 이용해 상태관리 최적화 하기
  void set_task_status() {
    // 화면 크기에 따라 아이콘 크기 동적 조정
    final size = MediaQuery.of(context).size;
    final double starSize =
        size.width * 0.015; // 별 아이콘 너비 (예: 3% of width, 더 작게)
    final double ddaySize =
        size.width * 0.035; // D-day 아이콘 너비 (예: 7% of width, 더 작게)
    final double starDdayGap = size.height * 0.005; // 별-Dday 간격도 더 작게
    final double topStar = size.height * 0.018;
    final double rightStar = size.width * 0.03;
    final double topDday = size.height * 0.04;
    final double rightDday = size.width * 0.03;

    if (_isStarred! && _isDday!) {
      task_status = Positioned(
        top: topStar,
        right: rightStar,
        child: Column(children: [
          Image.asset(
            'assets/images/starred.png',
            width: starSize,
          ),
          SizedBox(height: starDdayGap),
          Image.asset(
            'assets/images/dday.png',
            width: ddaySize,
          ),
        ]),
      );
    } else if (_isStarred!) {
      task_status = Positioned(
        top: topDday,
        right: rightDday + starSize * 0.5,
        child: Image.asset(
          'assets/images/starred.png',
          width: starSize,
        ),
      );
    } else if (_isDday!) {
      task_status = Positioned(
        top: topDday,
        right: rightDday,
        child: Image.asset(
          'assets/images/dday.png',
          width: ddaySize,
        ),
      );
    } else {
      task_status = SizedBox();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    task_status = SizedBox();

    _title = widget.title;
    _isFinished = widget.isFinished;
    _isStarred = widget.isStarred;
    _isDday = widget.isDueDate;
    set_task_status();
  }

  @override
  Widget build(BuildContext context) {
    // 화면 크기에 따라 동적으로 스타일 조정
    final size = MediaQuery.of(context).size;
    final double containerWidth = size.width * 0.9; // 전체 너비의 90%
    final double containerHeight = size.height * 0.10; // 전체 높이의 10%
    final double borderRadius = size.width * 0.04; // 약 4% radius
    final double iconBtnWidth = size.width * 0.10; // 아이콘 버튼 너비
    final double iconImgWidth = size.width * 0.03; // 아이콘 이미지 너비
    final double textFontSize = size.width * 0.04; // 텍스트 폰트 크기
    final double marginBottom = size.height * 0.015; // 아래 마진

    return Column(children: [
      SizedBox(height: marginBottom),
      GestureDetector(
        onDoubleTap: () {
          setState(() {
            _isStarred = !_isStarred!;
            set_task_status();
          });
        },
        child: Stack(
          children: [
            Container(
              width: containerWidth,
              height: containerHeight,
              decoration: BoxDecoration(
                color: Color(0xff0A0A0A),
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: iconBtnWidth,
                    child: IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/dots.png',
                        width: iconImgWidth,
                      ),
                    ),
                  ),
                  SizedBox(width: iconBtnWidth * 0.2),
                  SizedBox(
                    width: iconBtnWidth,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          print('complete task');
                        },
                        icon: Image.asset(
                            'assets/images/not_finished_circle.png',
                            width: iconImgWidth * 1.2)),
                  ),
                  SizedBox(width: iconBtnWidth * 0.4),
                  Expanded(
                    child: Text(
                      _title!,
                      style: TextStyle(
                        fontFamily: 'pretendard',
                        fontSize: textFontSize,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // star, dday 상태 보여줌 (별/디데이 이미지도 동적으로 조정 필요시 추가)
            task_status!,
          ],
        ),
      ),
    ]);
  }
}
