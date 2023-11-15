import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_managemnt_app/screens/studentList.dart';

import '../functions/functions.dart';
import 'model.dart';


class AddStudent extends StatefulWidget {
  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _formKey = GlobalKey<FormState>();
  final rollnoController = TextEditingController();
  final nameController = TextEditingController();
  final departmentController = TextEditingController();
  final phonenoController = TextEditingController();
  File? _selectedImage;

  void _setImage(File image) {
    setState(() {
      _selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Student"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentInfo()),
              );
            },
            icon:const Icon(Icons.supervised_user_circle_rounded),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 60),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                maxRadius: 70,
                child: GestureDetector(
                  onTap: () async {
                    File? pickedImage = await _pickImageFromCamera();
                    if (pickedImage != null) {
                      _setImage(pickedImage);
                    }
                  },
                  child: _selectedImage != null
                      ? ClipOval(
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: 140,
                            height: 140,
                          ),
                        )
                      : const Icon(Icons.add_a_photo_rounded),
                ),
              ),
              SizedBox(height: 30),
               TextFormField(
                keyboardType: TextInputType.name,
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Student Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Name is required';
                  }
                  if(value.length<4){
                    return 'Name is too short';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: rollnoController,
                decoration: const InputDecoration(
                  labelText: "Roll number",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Roll no is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
             
              TextFormField(
                keyboardType: TextInputType.name,
                controller: departmentController,
                decoration: const InputDecoration(
                  labelText: "Department",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Department is required';
                  }
                  if (value.length < 2) {
                    return 'Department name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: phonenoController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Phone number is required';
                  }
                  final phoneRegExp = RegExp(r'^[0-9]{10}$');
                  if (!phoneRegExp.hasMatch(value)) {
                    return 'Invalid phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 45),
              SizedBox(height: 20),
             
              
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.orange,
                          content: Text(
                            "Please select an image",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                      return;
                    }
                    final student = StudentModel(
                      rollno: rollnoController.text,
                      name: nameController.text,
                      department: departmentController.text,
                      phoneno: phonenoController.text,
                      imageurl: _selectedImage != null ? _selectedImage!.path : null,
                      
                    );
                    await addStudent(student);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                          "Data Added Successfully",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                    rollnoController.clear();
                    nameController.clear();
                    departmentController.clear();
                    phonenoController.clear();
                    setState(() {
                      _selectedImage = null;
                    });
                  }
                },
                child: Text("Save"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<File?> _pickImageFromCamera() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  }
}
