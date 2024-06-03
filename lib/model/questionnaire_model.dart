class Question {
  final String question;
  final List<String>? options;

  Question({
    required this.question,
    this.options,
  });
}

List<Question> questions = [
  Question(
    question:
        "Please rate your pain by circling the one number that best describes your pain at its <b>worst</b> in the last 24 hours",
    options: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
  ),
  Question(
    question:
        "Please rate your pain by circling the one number that best describes your pain at its <b>least</b> in the last 24 hours",
    options: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
  ),
  Question(
    question:
        "Please rate your pain by circling the one number that best describes <b>your pain on average</b>",
    options: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
  ),
  Question(
    question:
        "Please rate your pain by circling the one number that tells how much pain you have right <b>now</b>",
    options: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
  ),
  Question(
    question:
        "What <b>treatments</b> or medications are you receiving for your pain?",
    options: null,
  ),
  Question(
    question:
        "In the last 24 hours, how much relief have pain treatments or medications provided? Please circle the one percentage that best shows how much <b>relief</b> you have received",
    options: [
      "0%",
      "10%",
      "20%",
      "30%",
      "40%",
      "50%",
      "60%",
      "70%",
      "80%",
      "90%",
      "100%"
    ],
  ),
  Question(
    question:
        "Circle the one number that describes how, during the past 24 hours, pain has interfered with your: <b>General activity</b>",
    options: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
  ),
  Question(
    question:
        "Circle the one number that describes how, during the past 24 hours, pain has interfered with your: <b>Mood</b>",
    options: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
  ),
  Question(
    question:
        "Circle the one number that describes how, during the past 24 hours, pain has interfered with your: <b>Walking ability</b>",
    options: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
  ),
  Question(
    question:
        "Circle the one number that describes how, during the past 24 hours, pain has interfered with your: <b>Normal work (includes both outside the home and housework)</b>",
    options: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
  ),
  Question(
    question:
        "Circle the one number that describes how, during the past 24 hours, pain has interfered with your: <b>Relations with other people</b>",
    options: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
  ),
  Question(
    question:
        "Circle the one number that describes how, during the past 24 hours, pain has interfered with your: <b>Sleep</b>",
    options: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
  ),
  Question(
    question:
        "Circle the one number that describes how, during the past 24 hours, pain has interfered with your: <b>Enjoyment of life</b>",
    options: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
  ),
];
