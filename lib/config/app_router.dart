import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../s_home.dart';
import '../pages/tag_list_page.dart';
import '../pages/task_detail_page.dart';

/// GoRouter를 사용한 라우팅 설정
/// 앱의 모든 네비게이션을 관리하는 중앙 집중식 라우터
class AppRouter {
  static final GoRouter router = GoRouter(
    // 초기 경로 설정
    initialLocation: '/home',
    
    // 라우트 정의
    routes: [
      // 홈 화면 라우트
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const Home();
        },
      ),
      
      // 태그 목록 페이지 라우트
      GoRoute(
        path: '/tags',
        name: 'tags',
        builder: (BuildContext context, GoRouterState state) {
          return const TagListPage();
        },
      ),
      
      // 태스크 상세 페이지 라우트
      GoRoute(
        path: '/task-detail',
        name: 'task-detail',
        builder: (BuildContext context, GoRouterState state) {
          // 태스크 데이터를 extra 매개변수로 전달받음
          final taskData = state.extra as Map<String, dynamic>?;
          return TaskDetailPage(taskData: taskData);
        },
      ),
      
      // 새 태스크 생성 페이지 라우트
      GoRoute(
        path: '/task-create',
        name: 'task-create',
        builder: (BuildContext context, GoRouterState state) {
          return const TaskDetailPage(); // taskData 없이 호출하면 새 태스크 생성
        },
      ),
    ],
    
    // 에러 페이지 처리
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              '페이지를 찾을 수 없습니다\n${state.error}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    ),
  );
}
