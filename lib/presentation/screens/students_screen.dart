import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/blocs/auth/auth_bloc.dart';
import 'package:teacher_app/blocs/student/student_bloc.dart';
import 'package:teacher_app/presentation/screens/login_screen.dart';
import 'package:teacher_app/presentation/widgets/student_item.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  @override
  void initState() {
    BlocProvider.of<StudentBloc>(context).add(
      StudentFetchAllStudents(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<StudentBloc>().add(StudentFetchAllStudents());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogout());
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, state) {
          return state is AuthInitial;
        },
        listener: (context, state) {
          Navigator.pushReplacement(context, LoginScreen.route());
        },
        child: BlocBuilder<StudentBloc, StudentState>(
          builder: (context, state) {
            if (state is StudentLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is StudentLoaded) {
              return state.students.isEmpty
                  ? const Center(
                      child: Text(
                        'No students in database',
                        style: TextStyle(fontSize: 24),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(10),
                      itemCount: state.students.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemBuilder: (context, index) {
                        final student = state.students[index];
                        return Dismissible(
                          key: Key(student.id),
                          onDismissed: (direction) {
                            context
                                .read<StudentBloc>()
                                .add(StudentDelete(id: student.id));
                          },
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(11),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(right: 30),
                              child: Text(
                                'Remove',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          child: StudentItem(student: student),
                        );
                      },
                    );
            } else if (state is StudentFailure) {
              return Center(
                child: Text(state.error),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
