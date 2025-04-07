import 'package:bookworms_app/models/goals/child_goal.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  final ChildGoal goal;
  final TextEditingController controller;
  const CounterWidget({super.key, required this.goal, required this.controller});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late ChildGoal goal;
  late int count;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    goal = widget.goal;
    count = goal.progress;
    controller = widget.controller;
  }

  void updateTextField() {
    controller.text = count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: colorGrey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              style: const TextStyle(fontSize: 16),
              validator: (value) =>
                  value == null ||
                          value.isEmpty ||
                          int.parse(value) < 0 ||
                          (goal.goalMetric == "Completion" && int.parse(value) > 100)
                      ? 'Please input a valid value'
                      : null,
              onChanged: (value) {
                setState(() {
                  count = int.tryParse(value) ?? 0;
                  updateTextField();
                });
              },
            ),
          ),
          Container(
            width: 40,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: colorGrey),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _iconButton(
                  icon: Icons.keyboard_arrow_up,
                  onPressed: goal.goalMetric == "Completion" && count >= 100
                      ? null
                      : () {
                          setState(() {
                            count = goal.goalMetric == "BooksRead"
                                ? count + 1
                                : count + 10;
                            if (goal.goalMetric == "Completion" && count > 100) {
                              count = 100;
                            }
                            updateTextField();
                          });
                        },
                ),
                _iconButton(
                  icon: Icons.keyboard_arrow_down,
                  onPressed: goal.goalMetric == "Completion" && count == 0
                      ? null
                      : () {
                          setState(() {
                            count = goal.goalMetric == "BooksRead"
                                ? count - 1
                                : count - 10;
                            if (count < 0) count = 0;
                            updateTextField();
                          });
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton({required IconData icon, required VoidCallback? onPressed}) {
    return SizedBox(
      height: 20,
      width: 36,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 18,
        icon: Icon(icon, color: onPressed == null ? colorGrey : colorGreen),
        onPressed: onPressed,
      ),
    );
  }
}
