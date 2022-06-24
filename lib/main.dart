import 'package:dtc_manager/pages/home_page.dart';
import 'package:dtc_manager/provider/authentication_provider.dart';
import 'package:dtc_manager/provider/bottom_navigation_provider.dart';
import 'package:dtc_manager/provider/maria_db_provider.dart';
import 'package:dtc_manager/provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Ctrl + Shift + P -> Flutter: Inspect Widget : 위젯 검사 기능
// Ctrl + Shift + ` -> Terminal -> flutter doctor -v : 개발 환경 검사

// 최초 실행 함수
void main() async {
  // main 함수를 비동기로 다루기 위한 위젯 바인딩
  WidgetsFlutterBinding.ensureInitialized();
  // EasyLocalization (현지화 패키지 https://pub.dev/packages/easy_localization) 라이브러리 초기화
  await EasyLocalization.ensureInitialized();

  // await dotenv.load(fileName: 'assets/.env');

  // 전체 화면으로 뿌릴 첫 Widget
  runApp(
    // EasyLocalization 설정
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('ko', 'KR')], // 지원하는 전체 언어
      path: 'assets/translations', // 번역할 언어 파일의 위치
      fallbackLocale: Locale('en', 'US'),
      child: MyApp(), // MyApp Widget 호출
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 여러 Provider를 사용하기 위한 MultiProvider
    return MultiProvider(
      providers: [
        // Provider를 구독하는 청취자(listener)에게 상태 변경 알림
        ChangeNotifierProvider(create: (_) => MariaDBProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavigationProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      // MultiProivder의 child Widget들은 모두 providers 내의 모든 Provider에 접근 가능
      child: MaterialApp(
        // 앱 제목
        title: 'KaGA Tech',
        // 테마 설정
        theme: ThemeData(
          // 앱 주요 부분의 배경색
          primaryColor: Colors.white,
          // 구성 요소의 색상 속성
          colorScheme: ColorScheme.fromSwatch(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
          ).copyWith(
            primary: Colors.black,
            secondary: Colors.grey[700],
          ),
          // AppBar 테마
          appBarTheme: AppBarTheme(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
          ),
          // BottomNavigationBar 테마
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            unselectedItemColor: const Color(0xFF8D99AE).withOpacity(0.4),
            selectedItemColor: Colors.black,
          ),
        ),
        // 현지화 관련 설정
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        // 앱 기본 경로 (초기 화면)
        home: HomePage(),
      ),
    );
  }
}
