import 'dart:io';

import 'package:flutter/material.dart';

import 'model.dart';

class StudentProfileScreen extends StatelessWidget {
  final StudentModel student;

  StudentProfileScreen({required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 65),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 80,
              backgroundImage: student.imageurl != null
                  ? FileImage(File(student.imageurl!))
                  : null,
            ),
            if (student.imageurl == null)
              Positioned(
                top: 0,
                right: 0,
                child: Icon(Icons.camera_alt, size: 30),
              ),
            SizedBox(height: 20),
            Text(
              student.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Roll No: ${student.rollno}",
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            SizedBox(height: 10),
            Text("Department: ${student.department}",
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Phone Number: ${student.phoneno.toString()}",
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
