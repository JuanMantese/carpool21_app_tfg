import 'package:carpool_21_app/src/screens/pages/onboarding/bloc/onboarding_event.dart';
import 'package:carpool_21_app/src/screens/pages/onboarding/bloc/onboarding_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final PageController pageController = PageController();
  final int totalPages = 3;

  OnboardingBloc() : super(OnboardingState(currentPage: 0)) {
    on<NextPageEvent>((event, emit) {
      if (state.currentPage < totalPages) {
        pageController.animateToPage(
          state.currentPage + 1,
          duration: const Duration(milliseconds: 400),
          curve: Curves.ease,
        );
        emit(OnboardingState(currentPage: state.currentPage + 1));
      }
    });

    on<PreviousPageEvent>((event, emit) {
      if (state.currentPage > 0) {
        pageController.animateToPage(
          state.currentPage - 1,
          duration: const Duration(milliseconds: 400),
          curve: Curves.ease,
        );
        emit(OnboardingState(currentPage: state.currentPage - 1));
      }
    });

    on<UpdatePageEvent>((event, emit) {
      emit(state.copyWith(currentPage: event.page));
    });

    on<SkipToLastPageEvent>((event, emit) {
      emit(state.copyWith(currentPage: 3));
      pageController.jumpToPage(3);
    });
  }
}