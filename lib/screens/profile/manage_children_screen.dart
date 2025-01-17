import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/child.dart';
import 'package:bookworms_app/screens/profile/edit_child_screen.dart';
import 'package:bookworms_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageChildrenScreen extends StatefulWidget {
  const ManageChildrenScreen({super.key});

  @override
  State<ManageChildrenScreen> createState() => _ManageChildrenScreenState();
}

class _ManageChildrenScreenState extends State<ManageChildrenScreen> {
  @override
  Widget build(BuildContext context) {
    List<Child> children = Provider.of<AppState>(context).children;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Manage Children", 
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: colorWhite, 
            overflow: TextOverflow.ellipsis
          )
        ),
        backgroundColor: colorGreen,
        leading: IconButton(
          color: colorWhite,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 64.0),
          const Text(
            "Click to View Child",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 32.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: children.length + 1,
                itemBuilder: (context, index) {
                  if (index != children.length) {
                    return _childWidget(index, children[index]);
                  } else if (index == children.length) {
                    return _addChildWidget();
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _childWidget(int childID, Child child) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditChildScreen(childID: childID, child: child)
              )
            );
          },
          icon: CircleAvatar(
            maxRadius: 64,
            child: Text(
              child.name[0],
            ),
          ),
        ),
        Text(
          child.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }

  Widget _addChildWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          onPressed: () {
            _addChildDialog(context);
            },
          icon: const CircleAvatar(
            maxRadius: 64,
            child: Icon(Icons.add),
          ),
        ),
        const SizedBox(height: 8.0),
        const Text(
          "Add Child",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }

  void _addChildDialog(BuildContext context) {
    TextEditingController childNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Child"),
        content: TextField(
          controller: childNameController,
          decoration: const InputDecoration(hintText: "Child's Name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              String childName = childNameController.text.isNotEmpty
                ? childNameController.text
                : "New Child";
              Child newChild = Child(name: childName);
              Provider.of<AppState>(context, listen: false).addChild(newChild);
              Navigator.of(context).pop();
            },
            child: const Text("Add")
          ),
        ],
      ),
    );
  }

}