class QuestionAnswer {
  final String question;
  final String answer;

  QuestionAnswer({
    required this.question,
    required this.answer,
  });

  factory QuestionAnswer.fromMap(Map<String, dynamic> map) {
    return QuestionAnswer(
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
    );
  }
}
