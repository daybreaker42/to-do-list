import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// file imports
import 'package:to_do_list/s_home.dart';
import 'package:to_do_list/config/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Figma 디자인 기준 크기 (1179 x 2556)
      designSize: const Size(375, 812), // 일반적인 모바일 디자인 기준으로 변경
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'To do list',
          theme: ThemeData(
            // 새로운 디자인 시스템에 맞는 테마 설정
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: AppColors.background,
            fontFamily: 'Pretendard', // 수정: 대문자로 변경
            // 앱바 테마 설정
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.background,
              foregroundColor: AppColors.primaryText,
              elevation: 0,
            ),
            // 텍스트 테마 설정
            textTheme: TextTheme(
              bodyLarge: TextStyles.taskTitle,
              bodyMedium: TextStyles.subTitle,
              bodySmall: TextStyles.caption,
            ),
            // 다크 모드 지원
            brightness: Brightness.dark,
          ),
          home: const Home(),
          // 디버그 배너 제거
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
