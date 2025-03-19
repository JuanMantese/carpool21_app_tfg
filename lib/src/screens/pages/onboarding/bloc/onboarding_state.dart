
class OnboardingState {
  final int currentPage;
  OnboardingState({required this.currentPage});

  // Método copyWith para actualizar solo el currentPage sin perder otros valores del estado
  OnboardingState copyWith({int? currentPage}) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
    );
  }
}