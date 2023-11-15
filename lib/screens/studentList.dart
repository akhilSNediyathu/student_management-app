import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_managemnt_app/screens/profile.dart';

import '../functions/functions.dart';
import 'model.dart';


class StudentInfo extends StatefulWidget {
  const StudentInfo({Key? key}) : super(key: key);

  @override
  State<StudentInfo> createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  late List<Map<String, dynamic>> _studentsData = [];
    TextEditingController searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _fetchStudentsData();
  }

  Future<void> _fetchStudentsData() async {
    List<Map<String, dynamic>> students = await getAllStudents();
    if (searchController.text.isNotEmpty) {
    students = students.where((student) =>
        student['name']
            .toString()
            .toLowerCase()
            .contains(searchController.text.toLowerCase())).toList(); 
  }

    
    setState(() {
      _studentsData = students;
    });
  }

  Future<void> _showEditDialog(int index) async {
    final student = _studentsData[index];
    final TextEditingController nameController =
        TextEditingController(text: student['name']);
    final TextEditingController rollnoController =
        TextEditingController(text: student['rollno'].toString());
    final TextEditingController departmentController =
        TextEditingController(text: student['department']);
    final TextEditingController phonenoController =
        TextEditingController(text: student['phoneno'].toString());
        TextEditingController searchController = TextEditingController();


    showDialog(
      context: context,
      builder: (BuildContext) => AlertDialog(
        title: const Text("Edit Student"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextFormField(
                controller: rollnoController,
                decoration: const InputDecoration(labelText: "Roll No"),
              ),
              TextFormField(
                controller: departmentController,
                decoration: const InputDecoration(labelText: "Department"),
              ),
              TextFormField(
                controller: phonenoController,
                decoration: const InputDecoration(labelText: "Phone No"),
              ),
              TextFormField(
                controller: phonenoController,
                decoration: const InputDecoration(labelText: "Phone No"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await updateStudent(
                StudentModel(
                  id: student['id'], 
                  rollno: rollnoController.text,
                  name: nameController.text,
                  department: departmentController.text,
                  phoneno: phonenoController.text,
                  imageurl: student['imageurl'],
                ),
              );
              Navigator.of(context).pop(); 
              _fetchStudentsData(); // Refresh the list
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text("Changes Saved Successfully")));
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text("Student Information"),
  bottom: PreferredSize(
  
    preferredSize: const Size.fromHeight(60),
    child: Container(
        color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: searchController,
          onChanged: (value) {
            setState(() {
              _fetchStudentsData();
            });
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            labelText: "Search by Name",
            border: OutlineInputBorder(),
          ),
        ),
      ),
    ),
  ),
),

      body: _studentsData.isEmpty
          ? const Center(child: Text("No students available."))
          : ListView.separated(
              itemBuilder: (context, index) {
                final student = _studentsData[index];
                final id = student['id']; 
                final imageUrl = student['imageurl'];

                return ListTile(
                  onTap: () { 
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StudentProfileScreen(
                            student: StudentModel.fromMap(student)),
                      ),
                    );
                  },
                  leading: GestureDetector(
                    onTap: () {
                      if (imageUrl != null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.file(File(imageUrl)),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: CircleAvatar(
                      backgroundImage:
                          imageUrl != null ? FileImage(File(imageUrl)) : null,
                      child: imageUrl == null ? const Icon(Icons.person) : null,
                    ),
                  ),
                  title: Text(student['name']),
                  subtitle: Text(student['department']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          _showEditDialog(index);
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext) => AlertDialog(
                              title: const Text("Delete Student"),
                              content: const Text("Are you sure you want to delete?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await deleteStudent(id); // Delete the student
                                    _fetchStudentsData(); // Refresh the list
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            backgroundColor: Colors.red,
                                            content:
                                                Text("Deleted Successfully")));
                                  },
                                  child: const Text("Ok"),
                                )
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: _studentsData.length,
            ),
    );
  }
}
