import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageState extends Equatable {
  const LanguageState({this.languageCode = 'en'});

  final String languageCode;

  LanguageState copyWith({String? languageCode}) {
    return LanguageState(languageCode: languageCode ?? this.languageCode);
  }

  @override
  List<Object> get props => [languageCode];
}

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const LanguageState());

  void setLanguage(String languageCode) {
    emit(state.copyWith(languageCode: languageCode));
  }
}
