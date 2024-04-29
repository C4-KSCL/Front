// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:frontend_matching/theme/colors.dart';

const List<Widget> IE = <Widget>[
  Text('I', style: TextStyle(fontSize: 20)),
  Text('E', style: TextStyle(fontSize: 20)),
];
const List<Widget> NS = <Widget>[
  Text('N', style: TextStyle(fontSize: 20)),
  Text('S', style: TextStyle(fontSize: 20)),
];
const List<Widget> FT = <Widget>[
  Text('F', style: TextStyle(fontSize: 20)),
  Text('T', style: TextStyle(fontSize: 20)),
];
const List<Widget> PJ = <Widget>[
  Text('P', style: TextStyle(fontSize: 20)),
  Text('J', style: TextStyle(fontSize: 20)),
];

class MbtiKeyWord extends StatefulWidget {
  final Function(String) onMbtiSelected;

  const MbtiKeyWord(
      {Key? key, required this.title, required this.onMbtiSelected})
      : super(key: key);

  final String title;

  @override
  State<MbtiKeyWord> createState() => _MbtiKeyWordState();
}

class _MbtiKeyWordState extends State<MbtiKeyWord> {
  final List<bool> _selectedIE = <bool>[false, false];
  final List<bool> _selectedNS = <bool>[false, false];
  final List<bool> _selectedFT = <bool>[false, false];
  final List<bool> _selectedPJ = <bool>[false, false];
  bool vertical = false;

  String selectedIE = '';
  String selectedNS = '';
  String selectedFT = '';
  String selectedPJ = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // IE
            const Text('내향적 vs 외향적', style: TextStyle(fontSize: 15)),
            const SizedBox(height: 5),
            ToggleButtons(
              direction: vertical ? Axis.vertical : Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < _selectedIE.length; i++) {
                    _selectedIE[i] = i == index;
                  }
                  selectedIE = index == 0 ? 'I' : 'E';
                });
                updateMBTI();
                widget.onMbtiSelected(MBTI);
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: blueColor3,
              selectedColor: Colors.white,
              fillColor: blueColor4,
              color: blueColor1,
              constraints: const BoxConstraints(
                minHeight: 60.0,
                minWidth: 160.0,
              ),
              isSelected: _selectedIE,
              children: IE,
            ),
            const SizedBox(height: 10),
            // NS
            const Text('비현실적 vs 현실적', style: TextStyle(fontSize: 15)),
            const SizedBox(height: 5),
            ToggleButtons(
              direction: vertical ? Axis.vertical : Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < _selectedNS.length; i++) {
                    _selectedNS[i] = i == index;
                  }
                  selectedNS = index == 0 ? 'N' : 'S';
                });
                updateMBTI();
                widget.onMbtiSelected(MBTI);
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: blueColor3,
              selectedColor: Colors.white,
              fillColor: blueColor4,
              color: blueColor1,
              constraints: const BoxConstraints(
                minHeight: 60.0,
                minWidth: 160.0,
              ),
              isSelected: _selectedNS,
              children: NS,
            ),
            const SizedBox(height: 10),
            // FT
            const Text('공감적 vs 비공감적', style: TextStyle(fontSize: 15)),
            const SizedBox(height: 5),
            ToggleButtons(
              direction: vertical ? Axis.vertical : Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < _selectedFT.length; i++) {
                    _selectedFT[i] = i == index;
                  }
                  selectedFT = index == 0 ? 'F' : 'T';
                });
                updateMBTI();
                widget.onMbtiSelected(MBTI);
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: blueColor3,
              selectedColor: Colors.white,
              fillColor: blueColor4,
              color: blueColor1,
              constraints: const BoxConstraints(
                minHeight: 60.0,
                minWidth: 160.0,
              ),
              isSelected: _selectedFT,
              children: FT,
            ),
            const SizedBox(height: 10),
            // PJ
            const Text('즉흥적 vs 계획적', style: TextStyle(fontSize: 15)),
            const SizedBox(height: 5),
            ToggleButtons(
              direction: vertical ? Axis.vertical : Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < _selectedPJ.length; i++) {
                    _selectedPJ[i] = i == index;
                  }
                  selectedPJ = index == 0 ? 'P' : 'J';
                });
                updateMBTI();
                widget.onMbtiSelected(MBTI);
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: blueColor3,
              selectedColor: Colors.white,
              fillColor: blueColor4,
              color: blueColor1,
              constraints: const BoxConstraints(
                minHeight: 60.0,
                minWidth: 160.0,
              ),
              isSelected: _selectedPJ,
              children: PJ,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  String MBTI = '';

  void updateMBTI() {
    MBTI = selectedIE + selectedNS + selectedFT + selectedPJ;
  }
}
