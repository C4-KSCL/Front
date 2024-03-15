// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const List<Widget> IE = <Widget>[
  Text('I'),
  Text('E'),
];
const List<Widget> NS = <Widget>[
  Text('N'),
  Text('S'),
];
const List<Widget> FT = <Widget>[
  Text('F'),
  Text('T'),
];
const List<Widget> PJ = <Widget>[
  Text('P'),
  Text('J'),
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

  // Variables to store the selected MBTI
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
            Text('내향적 vs 외향적'),
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
              selectedBorderColor: Colors.red[700],
              selectedColor: Colors.white,
              fillColor: Colors.red[200],
              color: Colors.red[400],
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 80.0,
              ),
              isSelected: _selectedIE,
              children: IE,
            ),
            const SizedBox(height: 10),
            // NS
            Text('비현실적 vs 현실적'),
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
              selectedBorderColor: Colors.red[700],
              selectedColor: Colors.white,
              fillColor: Colors.red[200],
              color: Colors.red[400],
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 80.0,
              ),
              isSelected: _selectedNS,
              children: NS,
            ),
            const SizedBox(height: 10),
            // FT
            Text('공감적 vs 비공감적'),
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
              selectedBorderColor: Colors.red[700],
              selectedColor: Colors.white,
              fillColor: Colors.red[200],
              color: Colors.red[400],
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 80.0,
              ),
              isSelected: _selectedFT,
              children: FT,
            ),
            const SizedBox(height: 10),
            // PJ
            Text('즉흥적 vs 계획적'),
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
              selectedBorderColor: Colors.red[700],
              selectedColor: Colors.white,
              fillColor: Colors.red[200],
              color: Colors.red[400],
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 80.0,
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
