import 'package:flutter/material.dart';
import 'package:app_tinh_diem/model/round.dart';

class AddRoundScreen extends StatefulWidget {
  final List<String> playerNames;
  final Function(Round) onSave; // Single Round parameter
  final int roundNumber; // Add roundNumber

  const AddRoundScreen({
    Key? key,
    required this.playerNames,
    required this.onSave,
    required this.roundNumber, // Add this
  }) : super(key: key);

  @override
  _AddRoundScreenState createState() => _AddRoundScreenState();
}

class _AddRoundScreenState extends State<AddRoundScreen> {
  late List<TextEditingController> _scoreControllers;
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _scoreControllers = List.generate(
      widget.playerNames.length,
          (index) => TextEditingController(text: '0'),
    );
  }

  @override
  void dispose() {
    for (final controller in _scoreControllers) {
      controller.dispose();
    }
    _notesController.dispose();
    super.dispose();
  }

  void _toggleNegative(int index) {
    setState(() {
      final currentText = _scoreControllers[index].text;
      if (currentText.startsWith('-')) {
        _scoreControllers[index].text = currentText.substring(1);
      } else {
        _scoreControllers[index].text = '-$currentText';
      }
    });
  }


  void _saveRound() {
    if (_formKey.currentState!.validate()) {
      final List<int> scores = _scoreControllers
          .map((controller) => int.tryParse(controller.text) ?? 0)
          .toList();
      final String notes = _notesController.text;

      // Create the Round object
      final newRound = Round(
        roundNumber: widget.roundNumber, // Use passed-in roundNumber
        scores: scores,
        notes: notes,
      );

      widget.onSave(newRound); // Pass the Round object
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm ván mới'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton( // Back button
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // widget.onCancel?.call();
              Navigator.pop(context);
            }
        ),
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView( // Allow scrolling if content overflows
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Nếu bàn phím hiện tại không có phím - (dấu âm), bạn có thể bấm vào nút (-)(+) để chuyển đổi qua lại giữa điểm âm / điểm dương.',
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 16),

                      // Player Scores Input
                      Wrap(
                        spacing: 16.0, // Horizontal spacing
                        runSpacing: 16.0, // Vertical spacing
                        children: List.generate(widget.playerNames.length, (index) {
                          return SizedBox( // Constrain the width of each input
                            width: (MediaQuery.of(context).size.width - 48) / 4, // 4 items per row, with padding
                            child: Column( // Display name and score vertically
                              children: [
                                Text(
                                  widget.playerNames[index], // "8", "9", "10", "11"
                                  style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Expanded( // Make the TextFormField take the available width
                                      child: TextFormField(
                                        controller: _scoreControllers[index],
                                        keyboardType: TextInputType.numberWithOptions(signed: true),
                                        decoration:  InputDecoration(
                                          labelText: 'Điểm',
                                          labelStyle: TextStyle(color: Colors.black),
                                          hintText: '0',
                                          hintStyle: TextStyle(color: Colors.black),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black)
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.red),
                                          ),
                                        ),

                                        style: const TextStyle(color: Colors.black),
                                        textAlign: TextAlign.center,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Nhập điểm'; // Basic validation
                                          }
                                          if(int.tryParse(value) == null){
                                            return 'Sai định dạng';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),

                                    InkWell( // Use InkWell for tap feedback
                                        onTap: () => _toggleNegative(index),
                                        child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: Colors.grey[700],
                                                borderRadius: BorderRadius.circular(4)
                                            ),
                                            child: Text('(-)(+)', style: TextStyle(color: Colors.black, fontSize: 12))
                                        )
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      ),


                      const SizedBox(height: 24),

                      // Notes Input
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                            labelText: 'Nhập ghi chú',
                            labelStyle: TextStyle(color: Colors.black),
                            hintText: 'Ghi chú...',
                            hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),

                            focusedBorder: OutlineInputBorder(
                                borderSide:  BorderSide(color: Colors.black)
                            ),
                            filled: true,
                            fillColor: Colors.white
                        ),
                        style: const TextStyle(color: Colors.black),
                        maxLines: 3, // Allow multiple lines for notes
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Buttons (THÔI / LƯU)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // widget.onCancel?.call();
                    Navigator.pop(context); // Cancel and go back
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text('THÔI', style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: _saveRound, // Save the round
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text('LƯU', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
            SizedBox(height: 16,), // Add spacing at the bottom
          ],
        ),
      ),
    );
  }
}