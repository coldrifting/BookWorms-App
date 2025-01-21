import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/child.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeChildWidget extends StatefulWidget {
  const ChangeChildWidget({super.key});

  @override
  State<ChangeChildWidget> createState() => _ChangeChildWidgetState();
}

class _ChangeChildWidgetState extends State<ChangeChildWidget> {
  @override
  Widget build(BuildContext context) {

    int selectedChildID = Provider.of<AppState>(context).selectedChild;
    Child selectedChild = Provider.of<AppState>(context).children[selectedChildID];
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          _showChildSelection();
        },
        child: CircleAvatar(
          child: Text(
            selectedChild.name[0],
          ),
        ),
      ),
    );
  }

  void _showChildSelection() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Switch Profiles",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),
              Expanded (
                child: ListView.builder(
                  itemCount: Provider.of<AppState>(context).children.length,
                  itemBuilder: (context, index) {
                    Child child = Provider.of<AppState>(context).children[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          child.name[0],
                        ),
                      ),
                      title: Text(child.name),
                      onTap: () {
                        Provider.of<AppState>(context, listen: false).setSelectedChild(index);
                        Navigator.pop(context);
                      },
                      selected: index == Provider.of<AppState>(context).selectedChild,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}