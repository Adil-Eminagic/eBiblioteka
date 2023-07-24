
import '../models/question.dart';
import '../providers/base_provider.dart';

class QuestionProvider extends BaseProvider<Question> {
  QuestionProvider() : super('Questions');
  @override
  Question fromJson(data) {
    return Question.fromJson(data);
  }
}
