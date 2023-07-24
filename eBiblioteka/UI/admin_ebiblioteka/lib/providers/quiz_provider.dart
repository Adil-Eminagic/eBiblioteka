
import '../models/quiz.dart';
import '../providers/base_provider.dart';

class QuizProvider extends BaseProvider<Quiz> {
  QuizProvider() : super('Quizs');
  @override
  Quiz fromJson(data) {
    return Quiz.fromJson(data);
  }
}
