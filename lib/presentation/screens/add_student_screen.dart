import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teacher_app/blocs/student/student_bloc.dart';
import 'package:teacher_app/core/utils/show_snackbar.dart';
import 'package:teacher_app/models/student.dart';
import 'package:teacher_app/navigation_provider.dart';
import 'package:teacher_app/presentation/widgets/custom_button.dart';
import 'package:teacher_app/presentation/widgets/custom_field.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;
  bool _isLoading = false;

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submit() {
    if (_selectedDate == null) {
      showSnackBar(context, 'Select Date of Birth');
      return;
    }
    if (_formKey.currentState!.validate()) {
      final student = Student(
        name: _nameController.text,
        gender: _selectedGender!,
        dateOfBirth: _selectedDate!,
      );
      context.read<StudentBloc>().add(StudentAdd(student: student));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
      ),
      body: BlocListener<StudentBloc, StudentState>(
        listener: (context, state) {
          if (state is StudentLoading) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is StudentOperationSuccess) {
            setState(() {
              _isLoading = false;
            });
            Provider.of<NavigationProvider>(context, listen: false).setIndex(0);
          } else if (state is StudentFailure) {
            setState(() {
              _isLoading = false;
            });
            showSnackBar(context, 'Failed to add student: ${state.error}');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomField(
                  controller: _nameController,
                  hintText: 'Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'Select Date of Birth'
                          : 'Date of Birth: ${DateFormat('dd-MM-yyyy').format(_selectedDate!)}',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: _pickDate,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                  value: _selectedGender,
                  hint: const Text('Select Gender'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue!;
                    });
                  },
                  items: ['Male', 'Female', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a gender';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        onPressed: _submit,
                        buttonText: 'Add Student',
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
