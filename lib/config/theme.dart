import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 새로운 디자인 시스템에 맞는 색상 정의
class AppColors {
  static const Color background = Color(0xFF292929); // 기본 배경색
  static const Color darkBackground = Color(0xFF0A0A0A); // 어두운 배경색
  static const Color primaryText = Color(0xFFFFFFFF); // 기본 글씨색
  static const Color secondaryText = Color(0xFF676767); // 보조 글씨색
  static const Color accentText = Color(0xFF696969); // 액센트 글씨색
  static const Color grayText = Color(0xFF8E8E8E); // 회색 글씨색
  static const Color lightGrayText = Color(0xFF9D9D9D); // 연한 회색 글씨색
  static const Color highlight = Color(0xFF1381FE); // 하이라이트 색상
  static const Color warning = Color(0xFFF1FF9D); // 경고색
  static const Color error = Color(0xFFFB382D); // 에러색
  static const Color accent = Color(0xFF1F1F1F); // 액센트 배경색
  static const Color surface = Color(0xFF373737); // 서페이스 색상
  static const Color surfaceVariant = Color(0xFF212121); // 서페이스 변형색
  static const Color searchBackground = Color(0xFF373737); // 검색창 배경색
  static const Color border = Color(0xFF7C7C7C); // 경계선 색상
}

class TextStyles {
  // 메인 타이틀 (To-do) - Figma 65sp → 적절한 크기로 조정
  static TextStyle get mainTitle => TextStyle(
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w400,
        fontSize: 24.sp, // 65sp → 24sp로 조정
        color: AppColors.primaryText,
        letterSpacing: -1.7,
      );

  // 섹션 타이틀 (태그 목록) - Figma 80sp → 적절한 크기로 조정
  static TextStyle get sectionTitle => TextStyle(
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w400,
        fontSize: 20.sp, // 80sp → 20sp로 조정
        color: AppColors.primaryText,
        letterSpacing: -1.7,
      );

  // 서브 타이틀 - Figma 60sp → 적절한 크기로 조정
  static TextStyle get subTitle => TextStyle(
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w400,
        fontSize: 16.sp, // 60sp → 16sp로 조정
        color: AppColors.highlight,
        letterSpacing: -1.7,
      );

  // 태스크 타이틀 - Figma 87sp → 적절한 크기로 조정
  static TextStyle get taskTitle => TextStyle(
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w400,
        fontSize: 18.sp, // 87sp → 18sp로 조정
        color: AppColors.primaryText,
        letterSpacing: -1.7,
      );

  // 보조 텍스트 - Figma 55sp → 적절한 크기로 조정
  static TextStyle get caption => TextStyle(
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w400,
        fontSize: 14.sp, // 55sp → 14sp로 조정
        color: AppColors.accentText,
        letterSpacing: -1.7,
  );
  
  // 작은 텍스트 - Figma 40sp → 적절한 크기로 조정
  static TextStyle get small => TextStyle(
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w400,
        fontSize: 12.sp, // 40sp → 12sp로 조정
        color: AppColors.accentText,
        letterSpacing: -1.7,
  );
  
  // 플레이스홀더 텍스트 - Figma 87sp → 적절한 크기로 조정
  static TextStyle get placeholder => TextStyle(
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w400,
        fontSize: 18.sp, // 87sp → 18sp로 조정
        color: AppColors.secondaryText,
        letterSpacing: -1.7,
  );
  
  // 디테일 페이지 타이틀 - Figma 80sp → 적절한 크기로 조정
  static TextStyle get detailTitle => TextStyle(
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w400,
        fontSize: 22.sp, // 80sp → 22sp로 조정
        color: AppColors.primaryText,
        letterSpacing: -1.7,
  );
  
  // 디테일 페이지 서브 타이틀 - Figma 65sp → 적절한 크기로 조정
  static TextStyle get detailSubTitle => TextStyle(
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w400,
        fontSize: 16.sp, // 65sp → 16sp로 조정
        color: AppColors.secondaryText,
        letterSpacing: -1.7,
  );
}
