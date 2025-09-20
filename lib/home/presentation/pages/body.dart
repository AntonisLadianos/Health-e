import 'package:app/home/presentation/pages/questionnaire.dart';
import 'package:app/core/utils/const.dart';
import 'package:body_part_selector/body_part_selector.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class BodyScreen extends StatefulWidget {
  const BodyScreen({super.key});

  @override
  State<BodyScreen> createState() => _BodyScreenState();
}

class _BodyScreenState extends State<BodyScreen> {
  BodyParts _bodyParts = const BodyParts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text(
          "Body Parts Selector",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: GestureDetector(
          child: Icon(
            LineIcons.angleLeft,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        actions: buildEditingActions(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Text(
              'Ιn which part of the body you feel pain?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),

      //body
      body: SizedBox(
        child: BodyPartSelectorTurnable(
          bodyParts: _bodyParts,
          onSelectionUpdated: (selectedParts) {
            setState(() {
              _bodyParts = selectedParts;
            });
          },
        ),
      ),
    );
  }

  //Save Button
  //Save Button
  List<Widget> buildEditingActions() {
    return [
      TextButton.icon(
        onPressed: () {
          List<String> selectedParts = [];
          if (_bodyParts.head) selectedParts.add('Head');
          if (_bodyParts.neck) selectedParts.add('Neck');
          if (_bodyParts.leftShoulder) selectedParts.add('LeftShoulder');
          if (_bodyParts.leftUpperArm) selectedParts.add('LeftUpperArm');
          if (_bodyParts.leftElbow) selectedParts.add('LeftElbow');
          if (_bodyParts.leftLowerArm) selectedParts.add('LeftLowerArm');
          if (_bodyParts.leftHand) selectedParts.add('LeftHand');
          if (_bodyParts.rightShoulder) selectedParts.add('RightShoulder');
          if (_bodyParts.rightUpperArm) selectedParts.add('RightUpperArm');
          if (_bodyParts.rightElbow) selectedParts.add('RightElbow');
          if (_bodyParts.rightLowerArm) selectedParts.add('RightLowerArm');
          if (_bodyParts.rightHand) selectedParts.add('RightHand');
          if (_bodyParts.upperBody) selectedParts.add('UpperBody');
          if (_bodyParts.lowerBody) selectedParts.add('LowerBody');
          if (_bodyParts.leftUpperLeg) selectedParts.add('LeftUpperLeg');
          if (_bodyParts.leftKnee) selectedParts.add('LeftKnee');
          if (_bodyParts.leftLowerLeg) selectedParts.add('LeftLowerLeg');
          if (_bodyParts.leftFoot) selectedParts.add('LeftFoot');
          if (_bodyParts.rightUpperLeg) selectedParts.add('RightUpperLeg');
          if (_bodyParts.rightKnee) selectedParts.add('RightKnee');
          if (_bodyParts.rightLowerLeg) selectedParts.add('RightLowerLeg');
          if (_bodyParts.rightFoot) selectedParts.add('RightFoot');
          if (_bodyParts.abdomen) selectedParts.add('Abdomen');
          if (_bodyParts.vestibular) selectedParts.add('Vestibular');

          if (selectedParts.isNotEmpty) {
            print('Selected Body Parts: $selectedParts');
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Questionnaire()));
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(
                  'Please select at least one body part.',
                  style: TextStyle(fontSize: 18),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  )
                ],
              ),
            );
          }
        },
        icon: const Icon(
          LineIcons.angleDoubleRight,
          color: Colors.black,
        ),
        label: Text(
          'Next',
          style: TextStyle(color: Colors.black),
        ),
      ),
    ];
  }
}
