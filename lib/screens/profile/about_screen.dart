import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: Text(
          "About",
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
      body: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              child: SvgPicture.asset(
                'assets/images/bookworms_logo.svg',
                width: 100,
                semanticsLabel: "BookWorms Logo",
              ),
            ),
            addVerticalSpace(16),
            Text(
              "BookWorms", 
              style: TextStyle(color: colorGreen, fontSize: 32, fontWeight: FontWeight.bold)
            ),
            addVerticalSpace(16),
            Text(
              "University of Utah Spring 2025\n Senior Capstone Project",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            addVerticalSpace(16),
            Text(
              "Created by Aiden Van Dyke, Braden Fiedel, Caden Erickson, and Josie Fiedel", 
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            )
          ]
        ),
      ),
    );
  }
}