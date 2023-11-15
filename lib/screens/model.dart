class StudentModel {
  int? id; // Make id field an integer and required
  final dynamic rollno;
  final String name;
  final String department;
  final dynamic phoneno;
  final String? imageurl; // Nullable field for image URL

  StudentModel({
     this.id,
    required this.rollno,
    required this.name,
    required this.department,
    required this.phoneno,
    this.imageurl,
  });

  static fromMap(Map<String, dynamic> student) {
    return StudentModel(
      id: student['id'],
      rollno: student['rollno'],
      name: student['name'],
      department: student['department'],
      phoneno: student['phoneno'],
      imageurl: student['imageurl'],
    );
  }
}
