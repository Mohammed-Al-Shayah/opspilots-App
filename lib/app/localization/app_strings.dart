import 'package:flutter/material.dart';

class AppStrings {
  const AppStrings._();

  static const supportedLocales = [Locale('en'), Locale('ar')];

  static TextDirection textDirection(String languageCode) {
    return languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
  }

  static String t(String key, String languageCode) {
    return _values[languageCode]?[key] ?? _values['en']![key] ?? key;
  }

  static const Map<String, Map<String, String>> _values = {
    'en': {
      'back': 'Back',
      'home': 'Home',
      'myTasks': 'My Tasks',
      'map': 'Map',
      'chat': 'Chat',
      'profile': 'Profile',
      'settings': 'Settings',
      'notifications': 'Notifications',
      'selectLanguage': 'Select Language',
      'language': 'Language',
      'english': 'English',
      'arabic': 'Arabic',
      'liveMap': 'Live Map',
      'filter': 'Filter',
      'reset': 'Reset',
      'markAllRead': 'Mark all read',
      'search': 'Search',
      'searchConversations': 'Search conversations...',
      'attendance': 'Attendance',
      'taskCalendar': 'Task Calendar',
      'taskDetails': 'Task Details',
      'applyFilters': 'Apply Filters',
      'rolePreviewTitle': 'OpsPilot role preview',
      'rolePreviewSubtitle':
          'Switch roles to verify permissions and navigation.',
      'continue': 'Continue',
    },
    'ar': {
      'back': 'رجوع',
      'home': 'الرئيسية',
      'myTasks': 'مهامي',
      'map': 'الخريطة',
      'chat': 'المحادثات',
      'profile': 'الملف الشخصي',
      'settings': 'الإعدادات',
      'notifications': 'الإشعارات',
      'selectLanguage': 'اختيار اللغة',
      'language': 'اللغة',
      'english': 'الإنجليزية',
      'arabic': 'العربية',
      'liveMap': 'الخريطة المباشرة',
      'filter': 'تصفية',
      'reset': 'إعادة ضبط',
      'markAllRead': 'تحديد الكل كمقروء',
      'search': 'بحث',
      'searchConversations': 'البحث في المحادثات...',
      'attendance': 'الحضور',
      'taskCalendar': 'تقويم المهام',
      'taskDetails': 'تفاصيل المهمة',
      'applyFilters': 'تطبيق الفلاتر',
      'rolePreviewTitle': 'معاينة أدوار OpsPilot',
      'rolePreviewSubtitle': 'بدّل الدور لاختبار الصلاحيات والتنقل.',
      'continue': 'متابعة',
    },
  };
}
