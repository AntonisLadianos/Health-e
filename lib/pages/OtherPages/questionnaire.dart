// ignore_for_file: deprecated_member_use

import 'package:app/db/helper.dart';
import 'package:app/model/questionnaire_model.dart';
import 'package:app/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class Questionnaire extends StatefulWidget {
  const Questionnaire({super.key});

  @override
  State<Questionnaire> createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  int _currentQuestionIndex = 0;
  int _selectedValue = -1;
  final _scrollController = ScrollController();
  List<String> answerList = [];
  final TextEditingController _textEditingController = TextEditingController();
  String textAnswer = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          radioTheme: RadioThemeData(
            fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
          ),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              "Pain Questionnaire",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            backgroundColor: Constants.primarycolor,
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Constants.secondarycolor, Constants.primarycolor],
                ),
              ),
            ),
            leading: GestureDetector(
              child: Icon(
                LineIcons.angleLeft,
                color: Colors.black,
              ),
              onTap: () {
                _goToPreviousQuestion();
              },
            ),
            actions: _nextQuestion(),
          ),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                          color: Constants.primarycolor,
                          value: (_currentQuestionIndex + 1) / questions.length,
                          minHeight: 8.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Constants.primarycolor,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        'Question ${_currentQuestionIndex + 1}/${questions.length}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    //Questions
                    Container(
                      decoration: BoxDecoration(
                        color: Constants.primarycolor,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: RichText(
                          text: TextSpan(
                              text: "",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                              children: <TextSpan>[
                                ...parseHtmlTags(
                                    questions[_currentQuestionIndex].question),
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        // Show the answer options as radio buttons
                        if (_currentQuestionIndex != 4)
                          for (var i = 0;
                              i <
                                  questions[_currentQuestionIndex]
                                      .options!
                                      .length;
                              i++)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 5),
                                decoration: BoxDecoration(
                                  color: Constants.primarycolor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Constants.primarycolor
                                          .withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: RadioListTile(
                                  title: RichText(
                                    text: TextSpan(
                                      text: questions[_currentQuestionIndex]
                                          .options![i],
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  value: i,
                                  groupValue: _selectedValue,
                                  onChanged: (value) {
                                    setState(() {
                                      // update the selected value
                                      _selectedValue = value!;
                                    });
                                  },
                                ),
                              ),
                            )
                        else
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              margin: EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Constants.backgroundColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Constants.primarycolor.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: TextFormField(
                                  controller: _textEditingController,
                                  decoration: InputDecoration(
                                    hintText: "Enter your answer",
                                    hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Constants.primarycolor,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      // Update the selected value with the entered text
                                      textAnswer = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your answer';
                                    }
                                    // Add any additional validation rules here if needed
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }

  List<Widget> _nextQuestion() {
    if (_selectedValue != -1 || textAnswer.isNotEmpty) {
      return [
        TextButton.icon(
          onPressed: () {
            setState(() {
              if (_currentQuestionIndex < questions.length - 1) {
                if (_currentQuestionIndex == 4) {
                  answerList.add(textAnswer);
                } else {
                  answerList.add(_selectedValue.toString());
                }
                _currentQuestionIndex++;
              } else {
                Navigator.of(context).pop(context);
                Navigator.of(context).pop(context);
                // Show a message and return to the home page
                alertDialogsuccess(context,
                    "Questionnaire Was Successfully Sent To Your Doctor");
                // saveAnswerListToFile(answerList);
                print(answerList);
                // answerList.clear();
              }
              print(answerList);
              _scrollController.jumpTo(0);
              _selectedValue = -1;
              textAnswer = '';
            });
          },
          icon: const Icon(
            LineIcons.angleDoubleRight,
            color: Colors.black,
          ),
          label: Text(
            'Next',
            style: TextStyle(color: Colors.black),
          ),
        )
      ];
    } else {
      return [];
    }
  }

  void _goToPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        answerList.removeAt(_currentQuestionIndex);
        _selectedValue = -1;
      });
    } else {
      Navigator.pop(context);
    }
  }

//make bold some words
  List<TextSpan> parseHtmlTags(String question) {
    final List<TextSpan> textSpans = [];
    final RegExp regex = RegExp(r"<b>(.*?)<\/b>");

    final Iterable<Match> matches = regex.allMatches(question);
    int currentPosition = 0;

    for (final Match match in matches) {
      final String normalText =
          question.substring(currentPosition, match.start);
      final String boldText =
          question.substring(match.start + 3, match.end - 4);

      if (normalText.isNotEmpty) {
        textSpans.add(TextSpan(text: normalText));
      }
      if (boldText.isNotEmpty) {
        textSpans.add(
          TextSpan(
            text: boldText,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      }

      currentPosition = match.end;
    }

    if (currentPosition < question.length) {
      final String remainingText = question.substring(currentPosition);
      textSpans.add(TextSpan(text: remainingText));
    }

    return textSpans;
  }

  //save answers
  // Future<void> saveAnswerListToFile(List<String> answerList) async {
  //   try {
  //     // Get the directory for storing files
  //     final directory = await getApplicationDocumentsDirectory();
  //     final file = File('${directory.path}/answer_list.txt');

  //     print(file);
  //     // Convert the answer list to a string
  //     final answerListString = answerList.join(',');

  //     // Write the answer list to the file
  //     await file.writeAsString(answerListString);

  //     print('Answer list saved to file');
  //   } catch (e) {
  //     print('Error saving answer list to file: $e');
  //   }
  // }
}
