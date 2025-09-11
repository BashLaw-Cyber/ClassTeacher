import 'dart:io';

import 'package:classreportsheet/providers/student_provider.dart';
import 'package:classreportsheet/util/constant.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../db/hive_db.dart';

class SettingPage extends StatefulWidget {
  static final String route = "settingPage";

  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  TextEditingController generalController = TextEditingController();
  File? _logoImage;
  bool change = false;

  @override
  void initState() {
    initializeSubjects();
    _logoImage = File(getSchoolLogoPath());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("Setting page"),
      ),
      body: ListView(
        children: [
          _buildSchoolPropertiesTile(),
          _buildSettingAllSubjectTile(),
          _buildSettingClassAndSubjectTile(),
          _buildSettingDepartmentsSubjectTile(),
        ],
      ),
    );
  }

  Widget _buildSchoolPropertiesTile() {
    return ListTile(
      leading: Icon(Icons.school),
      title: Text("School Properties"),
      subtitle: Text("Click to enter school name, address,and telephone"),
      onTap: () {
        String name = getSchoolPropertyValue(schoolName);
        String address = getSchoolPropertyValue(schoolAddress);
        String telephone = getSchoolPropertyValue(schoolTel);
        TextEditingController nameContrl = TextEditingController(text: name);
        TextEditingController addressContrl = TextEditingController(
          text: address,
        );
        TextEditingController telephoneContrl = TextEditingController(
          text: telephone,
        );
        showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: Text("School Properties"),
              content: SizedBox(
                width: double.maxFinite,
                height: 250.0,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(height: 10),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                change = true;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "School Name",
                              hint: Text("Enter School name"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            controller: nameContrl,
                          ),
                          SizedBox(height: 10),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                change = true;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "School Address",
                              hint: Text("Enter School address"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            controller: addressContrl,
                          ),
                          SizedBox(height: 10),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                change = true;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "School Phone No.",
                              hint: Text("Enter School telephone number"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            controller: telephoneContrl,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Click box below Upload your School logo",
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          GestureDetector(
                            onTap: () async {
                              final picker = ImagePicker();
                              final pickedImage = await picker.pickImage(
                                source: ImageSource.gallery,
                              );

                              if (pickedImage != null) {
                                setState(() {
                                  change = true;
                                  _logoImage = File(pickedImage.path);
                                });
                              }
                            }, //_pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                (_logoImage == null || _logoImage!.path == "")
                                    ? "chose a file"
                                    : _logoImage!.path.split("/").last,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: change
                          ? () {
                              addSchoolProperty(schoolName, nameContrl.text);
                              addSchoolProperty(
                                schoolAddress,
                                addressContrl.text,
                              );
                              addSchoolProperty(
                                schoolTel,
                                telephoneContrl.text,
                              );
                              saveSchoolLogo(_logoImage!);
                              Navigator.pop(context);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        elevation: 5.0,
                      ),
                      child: Text("Save"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedImage = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedImage != null) {
  //     setState(() {
  //       change = true;
  //       _logoImage = File(pickedImage.path);
  //     });
  //     saveSchoolLogo(_logoImage!);
  //   }
  // }

  Widget _buildSettingClassAndSubjectTile() {
    return ListTile(
      leading: Icon(Icons.class_),
      title: Text("Class Management"),
      subtitle: Text("Click to create class and add its subjects"),
      onTap: () {
        List<String> myClasses = getAllClasses();
        myClasses.sort();
        showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, buildSetState) => AlertDialog(
              title: Text("School classes"),
              content: (myClasses.isEmpty)
                  ? SizedBox(
                      width: double.maxFinite,
                      height: 250,
                      child: Center(
                        child: Text("No class  for the school; Add one below"),
                      ),
                    )
                  : SizedBox(
                      width: double.maxFinite,
                      height: 250,
                      child: ListView.builder(
                        itemCount: myClasses.length,
                        itemBuilder: (context, index) {
                          String currentClass = myClasses[index];
                          return Dismissible(
                            background: Container(
                              alignment: FractionalOffset.centerRight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                shape: BoxShape.rectangle,
                                color: Colors.red,
                              ),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            direction: DismissDirection.endToStart,
                            key: Key(currentClass),
                            confirmDismiss: (direction) {
                              return showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Caution"),
                                  content: Text(
                                    "Deleting $currentClass class, all its subjects will also be deleted",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        removeClass(currentClass);
                                        buildSetState(() {
                                          myClasses = getAllClasses();
                                          myClasses.sort();
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text("Yes"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("No"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: ListTile(
                              title: Text(currentClass),
                              subtitle: Text(
                                "Swipe to delete class or click to pick subject $currentClass",
                              ),
                              onTap: () {
                                // get all class subjects
                                List<String> myClassSubjects =
                                    getAllClassesSubjects(currentClass);
                                myClassSubjects.sort();
                                List<String> allSubject = getAllSubjects();
                                // inside not registered subjects
                                List<String> notRegisteredSubject = [];
                                for (var subject in allSubject) {
                                  if (!myClassSubjects.contains(subject)) {
                                    notRegisteredSubject.add(subject);
                                  }
                                }
                                notRegisteredSubject.sort();
                                String? selectedSubject;
                                // show list of subjects for the class
                                showDialog(
                                  context: context,
                                  builder: (context) => StatefulBuilder(
                                    builder: (context, setState) => AlertDialog(
                                      title: Text("$currentClass subjects"),
                                      content: myClassSubjects.isEmpty
                                          ? SizedBox(
                                              width: double.maxFinite,
                                              height: 250,
                                              child: Center(
                                                child: Text(
                                                  "No subject: Add one below ",
                                                ),
                                              ),
                                            )
                                          : SizedBox(
                                              width: double.maxFinite,
                                              height: 250,
                                              child: ListView.builder(
                                                itemCount:
                                                    myClassSubjects.length,
                                                itemBuilder: (context, index) {
                                                  // get each subject and show it in list tile
                                                  String subject =
                                                      myClassSubjects[index];
                                                  return Dismissible(
                                                    direction: DismissDirection
                                                        .endToStart,
                                                    key: Key(subject),
                                                    background: Container(
                                                      alignment:
                                                          FractionalOffset
                                                              .centerRight,
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              18,
                                                            ),
                                                      ),
                                                      child: Icon(
                                                        Icons.delete,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    confirmDismiss: (direction) {
                                                      return showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          title: Text(
                                                            "Caution",
                                                          ),
                                                          content: Text(
                                                            "About to delete $subject",
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                // remove the class subject
                                                                removeClassSubject(
                                                                  currentClass,
                                                                  subject,
                                                                );
                                                                setState(() {
                                                                  // get net subjects
                                                                  myClassSubjects =
                                                                      getAllClassesSubjects(
                                                                        currentClass,
                                                                      );
                                                                  myClassSubjects
                                                                      .sort();
                                                                  // add remove subject to not registered subjects
                                                                  notRegisteredSubject
                                                                      .add(
                                                                        subject,
                                                                      );
                                                                  notRegisteredSubject
                                                                      .sort();
                                                                });
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                              },
                                                              child: Text(
                                                                "Yes",
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                              },
                                                              child: Text("No"),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    child: ListTile(
                                                      title: Text(subject),
                                                      subtitle: Text(
                                                        "Swipe left to remove subject",
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                      actions: [
                                        DropdownButton(
                                          value: selectedSubject,
                                          hint: Text("Add other subject"),
                                          items: notRegisteredSubject
                                              .map(
                                                (e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            addClassSubject(
                                              currentClass,
                                              value!,
                                            );
                                            setState(() {
                                              myClassSubjects =
                                                  getAllClassesSubjects(
                                                    currentClass,
                                                  );
                                              myClassSubjects.sort();
                                              notRegisteredSubject.remove(
                                                value,
                                              );
                                              notRegisteredSubject.sort();
                                              selectedSubject = null;
                                            });
                                          },
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Go Back"),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
              actions: [
                TextField(
                  controller: generalController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Add a new class",
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (generalController.text.isNotEmpty) {
                          buildSetState(() {
                            addClass(generalController.text);
                            generalController.clear();
                            myClasses = getAllClasses();
                            myClasses.sort();
                          });

                          Provider.of<StudentProvider>(
                            context,
                            listen: false,
                          ).getAllStudent();
                        }
                      },
                      child: Text("Add"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Go Back"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingAllSubjectTile() {
    return ListTile(
      leading: Icon(Icons.border_color_outlined),
      title: Text("Subject Management"),
      subtitle: Text("Click to view subject and to add more subject"),
      onTap: () {
        // get all subjects
        List<String> allSchoolSubject = getAllSubjects();
        allSchoolSubject.sort();

        // show a dialog box to view and add subject
        showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: Text("All subjects"),
              content: SizedBox(
                width: double.maxFinite,
                height: 250,
                child: ListView.builder(
                  itemCount: allSchoolSubject.length,
                  itemBuilder: (context, index) {
                    final subject = allSchoolSubject[index];
                    return ListTile(title: Text(subject));
                  },
                ),
              ),
              actions: [
                TextField(
                  controller: generalController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Add a new Subject",
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (generalController.text.isNotEmpty) {
                          addSubject(generalController.text);
                          generalController.clear();
                          setState(() {
                            allSchoolSubject = getAllSubjects();
                            allSchoolSubject.sort();
                          });
                        }
                      },
                      child: Text("Add"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Go Back"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingDepartmentsSubjectTile() {
    return ListTile(
      leading: Icon(Icons.api),
      title: Text("Department Management"),
      subtitle: Text("Click to create department and add its subjects"),
      onTap: () {
        // show all departments
        List<String> myDepartments = getAllDepartments();
        myDepartments.sort();
        showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: Text("Class Departments"),
              content: myDepartments.isEmpty
                  ? SizedBox(
                      width: double.maxFinite,
                      height: 250,
                      child: Center(
                        child: Text("No department: add one below"),
                      ),
                    )
                  : SizedBox(
                      width: double.maxFinite,
                      height: 250,
                      child: ListView.builder(
                        itemCount: myDepartments.length,
                        itemBuilder: (context, index) {
                          // list out the departments
                          String currentDepartment = myDepartments[index];
                          return Dismissible(
                            confirmDismiss: (direction) {
                              return showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Caution"),
                                  content: Text(
                                    "Deleting $currentDepartment department, will delete all its subjects and students",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        removeDepartment(currentDepartment);
                                        setState(() {
                                          myDepartments = getAllDepartments();
                                          myDepartments.sort();
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Text("Yes"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("No"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            key: Key(currentDepartment),
                            background: Container(
                              alignment: FractionalOffset.centerRight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: Colors.red,
                              ),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            child: ListTile(
                              title: Text(currentDepartment),
                              subtitle: Text(
                                "Swipe to delete department or click to add its subjects",
                              ),
                              onTap: () {
                                List<String> mySubjects = getDepartmentSubjects(
                                  currentDepartment,
                                );
                                mySubjects.sort();
                                String? selectedSubject;
                                List<String> notRegisteredSubject = [];
                                List<String> allSubjects = getAllSubjects();
                                for (var subject in allSubjects) {
                                  if (!mySubjects.contains(subject)) {
                                    notRegisteredSubject.add(subject);
                                  }
                                }
                                notRegisteredSubject.sort();
                                showDialog(
                                  context: context,
                                  builder: (context) => StatefulBuilder(
                                    builder: (context, setState) => AlertDialog(
                                      title: Text(
                                        "$currentDepartment subjects",
                                      ),
                                      content: mySubjects.isEmpty
                                          ? SizedBox(
                                              width: double.maxFinite,
                                              height: 250,
                                              child: Center(
                                                child: Text(
                                                  "No subjects: Add one below",
                                                ),
                                              ),
                                            )
                                          : SizedBox(
                                              width: double.maxFinite,
                                              height: 250,
                                              child: ListView.builder(
                                                itemCount: mySubjects.length,
                                                itemBuilder: (context, index) {
                                                  String subject =
                                                      mySubjects[index];
                                                  return Dismissible(
                                                    direction: DismissDirection
                                                        .endToStart,
                                                    key: Key(subject),
                                                    background: Container(
                                                      alignment:
                                                          FractionalOffset
                                                              .centerRight,
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              18,
                                                            ),
                                                      ),
                                                      child: Icon(
                                                        Icons.delete,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    confirmDismiss: (direction) {
                                                      return showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          title: Text(
                                                            "Caution",
                                                          ),
                                                          content: Text(
                                                            "About to delete $subject",
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                removerDepartmentSubject(
                                                                  currentDepartment,
                                                                  subject,
                                                                );
                                                                setState(() {
                                                                  mySubjects =
                                                                      getDepartmentSubjects(
                                                                        currentDepartment,
                                                                      );
                                                                  mySubjects
                                                                      .sort();
                                                                });
                                                                notRegisteredSubject
                                                                    .add(
                                                                      subject,
                                                                    );
                                                                notRegisteredSubject
                                                                    .sort();
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                              },
                                                              child: Text(
                                                                "Yes",
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                              },
                                                              child: Text("No"),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    child: ListTile(
                                                      title: Text(subject),
                                                      subtitle: Text(
                                                        "Swipe left to delete subject",
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                      actions: [
                                        DropdownButton(
                                          value: selectedSubject,
                                          hint: Text("Add other subjects"),
                                          items: notRegisteredSubject
                                              .map(
                                                (e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            addDepartmentSubject(
                                              currentDepartment,
                                              value!,
                                            );
                                            setState(() {
                                              mySubjects =
                                                  getDepartmentSubjects(
                                                    currentDepartment,
                                                  );
                                              mySubjects.sort();
                                            });
                                            notRegisteredSubject.remove(value);
                                            notRegisteredSubject.sort();
                                            selectedSubject = null;
                                          },
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Go Back"),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
              actions: [
                TextField(
                  controller: generalController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Add new department",
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (generalController.text.isNotEmpty) {
                          addDepartment(generalController.text);
                          generalController.clear();
                          setState(() {
                            myDepartments = getAllDepartments();
                          });
                        }
                      },
                      child: Text("Add"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Go Back"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
