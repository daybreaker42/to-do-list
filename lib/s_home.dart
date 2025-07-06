import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list/widgets/w_info.dart';
import 'package:to_do_list/widgets/w_task.dart';

// file imports
import 'config/theme.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // learn - AppBar가 없는 화면에서 앱 상태바 색상 변경하는 법
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    // 화면 크기에 맞게 동적으로 사이즈 조정
    final size = MediaQuery.of(context).size;
    final double horizontalPadding = size.width * 0.06; // 약 6% 패딩
    final double verticalPadding = size.height * 0.03; // 약 3% 패딩
    final double titleFontSize = size.width * 0.06; // 화면 너비의 6% 크기
    final double iconSize = size.width * 0.08; // 화면 너비의 8% 크기
    final double listViewHeight = size.height * 0.65; // 전체 높이의 65%
    final double listViewWidth = size.width * 0.92; // 전체 너비의 92%
    final double addBtnHeight = size.height * 0.09; // 전체 높이의 9%
    final double addBtnWidth = size.width * 0.9; // 전체 너비의 90%

    return Scaffold(
      body: Container(
        color: Color(0xff292929),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            // title
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding * 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)), // radius 축소
                color: Color(0xff0E0E0E),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('To-do list',
                      style: TextStyle(
                        fontFamily: 'pretendard',
                        fontWeight: FontWeight.bold,
                        fontSize: titleFontSize, // 동적 폰트 크기
                        color: Colors.white,
                      )), // 주석: 동적 폰트 크기 적용
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.delete, color: Colors.grey[400]),
                        iconSize: iconSize, // 동적 아이콘 크기
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.menu_rounded, color: Colors.grey[400]),
                        iconSize: iconSize, // 동적 아이콘 크기
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ListView 영역
            SizedBox(
              height: listViewHeight,
              width: listViewWidth,
              child: ListView(
                padding: EdgeInsets.only(top: verticalPadding),
                children: [
                  // Info Widget
                  InfoWidget(),
                  SizedBox(height: verticalPadding),
                  // tasks
                  Task(
                    title: '123',
                    content: '123',
                    date: '2023-12-12',
                    isStarred: true,
                    isDueDate: true,
                    isFinished: false,
                  ),
                  SizedBox(height: verticalPadding * 0.7),
                  Task(
                    title: '123',
                    content: '123',
                    date: '2023-12-12',
                    isStarred: true,
                    isDueDate: false,
                    isFinished: false,
                  ),
                  SizedBox(height: verticalPadding * 0.7),
                  Task(
                    title: '123',
                    content: '123',
                    date: '2023-12-12',
                    isStarred: false,
                    isDueDate: true,
                    isFinished: false,
                  ),
                ],
              ),
            ),

            // Task Add Button
            SizedBox(
                width: addBtnWidth,
                height: addBtnHeight,
                child: IconButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xff0A0A0A)),
                  ),
                  icon: Icon(
                    Icons.add_rounded,
                    size: iconSize * 1.2, // add 버튼은 좀 더 크게
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ))
            // 주석: 버튼, 리스트, 타이틀 등 모두 화면 크기에 맞게 동적으로 조정
          ],
        ),
      ),
    );
  }
}
