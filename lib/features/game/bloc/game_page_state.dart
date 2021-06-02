import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/quiz_question.dart';
import 'package:kahootify_server/models/server_info.dart';

enum ButtonState { disabled, enabled, correct, incorrect, waiting }

class AnswerButtonState {
  final ButtonState state;
  final String answer;
  final int index;

  AnswerButtonState({required this.state, required this.answer, required this.index});

  AnswerButtonState.initial({required this.index})
      : state = ButtonState.enabled,
        answer = '';

  AnswerButtonState newQuestion(String answer) {
    return AnswerButtonState(state: ButtonState.enabled, answer: answer, index: this.index);
  }

  AnswerButtonState chooseThisAnswer() {
    return AnswerButtonState(state: ButtonState.waiting, answer: this.answer, index: this.index);
  }

  AnswerButtonState chooseAnotherAnswer() {
    return AnswerButtonState(state: ButtonState.disabled, answer: this.answer, index: this.index);
  }
}

class GamePageState {
  final List<PlayerInfo> results;
  final ServerInfo serverInfo;
  final QuizQuestion? quizQuestion;
  final int questionNumber;
  final int currentPage;
  final bool shouldProceedToResultsScreen;
  final List<AnswerButtonState> answerButtons;

  GamePageState({
    required this.results,
    required this.serverInfo,
    this.quizQuestion,
    required this.questionNumber,
    this.shouldProceedToResultsScreen = false,
    required this.currentPage,
    required this.answerButtons,
  });

  GamePageState.initial({required this.serverInfo})
      : questionNumber = 0,
        currentPage = 0,
        quizQuestion = null,
        shouldProceedToResultsScreen = false,
        answerButtons = List.generate(4, (index) => AnswerButtonState.initial(index: index)),
        results = [];

  GamePageState nextQuestion({required QuizQuestion quizQuestion}) {
    return GamePageState(
      results: this.results,
      serverInfo: this.serverInfo,
      questionNumber: this.questionNumber + 1,
      quizQuestion: quizQuestion,
      currentPage: 1,
      answerButtons: List.generate(
        quizQuestion.possibleAnswers.length,
        (index) => this.answerButtons[index].newQuestion(quizQuestion.possibleAnswers[index]),
      ),
    );
  }

  GamePageState proceedToNextScreen() {
    return GamePageState(
      results: this.results,
      serverInfo: this.serverInfo,
      questionNumber: this.questionNumber,
      quizQuestion: this.quizQuestion,
      shouldProceedToResultsScreen: true,
      currentPage: 2,
      answerButtons: this.answerButtons,
    );
  }

  GamePageState chooseAnswer(int chosenAnswerIndex) {
    return GamePageState(
      results: this.results,
      serverInfo: this.serverInfo,
      questionNumber: this.questionNumber,
      currentPage: this.currentPage,
      answerButtons: List.generate(
        quizQuestion?.possibleAnswers.length ?? 4,
        (index) {
          if (index == chosenAnswerIndex) {
            return this.answerButtons[index].chooseThisAnswer();
          }
          return this.answerButtons[index].chooseAnotherAnswer();
        },
      ),
    );
  }

  GamePageState copyWith({
    List<PlayerInfo>? results,
    ServerInfo? serverInfo,
    QuizQuestion? quizQuestion,
    int? questionNumber,
    int? currentPage,
    List<AnswerButtonState>? answerButtons,
  }) {
    return GamePageState(
      results: results ?? this.results,
      serverInfo: serverInfo ?? this.serverInfo,
      questionNumber: questionNumber ?? this.questionNumber,
      quizQuestion: quizQuestion ?? this.quizQuestion,
      currentPage: currentPage ?? this.currentPage,
      answerButtons: answerButtons ?? this.answerButtons,
    );
  }
}
