import '../models/userquiz.dart';
import '../providers/base_provider.dart';

class UserQuizProvider extends BaseProvider<UserQuiz> {
  UserQuizProvider() : super('UserQuizs');
  @override
  UserQuiz fromJson(data) {
    return UserQuiz.fromJson(data);
  }
}
