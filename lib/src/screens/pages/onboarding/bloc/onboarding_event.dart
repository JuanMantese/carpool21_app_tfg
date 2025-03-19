
abstract class OnboardingEvent {}

class NextPageEvent extends OnboardingEvent {}

class PreviousPageEvent extends OnboardingEvent {}

class UpdatePageEvent extends OnboardingEvent {
  final int page;
  UpdatePageEvent(this.page);
}

class SkipToLastPageEvent extends OnboardingEvent {}
