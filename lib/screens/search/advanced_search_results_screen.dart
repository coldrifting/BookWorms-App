import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';

class AdvancedSearchResultsScreen extends StatefulWidget {
  const AdvancedSearchResultsScreen({super.key});

  @override
  State<AdvancedSearchResultsScreen> createState() => _AdvancedSearchResultsScreenState();
}

class _AdvancedSearchResultsScreenState extends State<AdvancedSearchResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: Text(
          "Advanced Search",
          style: const TextStyle(
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
    );
  } 
}