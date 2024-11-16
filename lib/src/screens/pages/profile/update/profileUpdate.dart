import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/profile/info/bloc/profileInfoBloc.dart';
import 'package:carpool_21_app/src/screens/pages/profile/info/bloc/profileInfoEvent.dart';
import 'package:carpool_21_app/src/screens/pages/profile/update/bloc/profileUpdateBloc.dart';
import 'package:carpool_21_app/src/screens/pages/profile/update/bloc/profileUpdateEvent.dart';
import 'package:carpool_21_app/src/screens/pages/profile/update/bloc/profileUpdateState.dart';
import 'package:carpool_21_app/src/screens/pages/profile/update/profileUpdateContent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class ProfileUpdatePage extends StatefulWidget {
  final User? user;

  const ProfileUpdatePage({
    super.key,
    this.user
  });

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  User? user;

  // Initial execution - First event to fire when the screen first appears - Runs only once
  @override
  void initState() {
    super.initState();

    // Asigna el valor de car desde el widget
    user = widget.user;

    // Wait until all elements of the Widget build are loaded to execute the Event
    // This is done to prevent the user from coming in as null, as it is instantiated in the Widget build
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProfileUpdateBloc>().add(ProfileUpdateInitEvent(user: user));
    });
  }

  // Secondary execution: Triggered every time we make a state change in a widget on that screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ProfileUpdateBloc, ProfileUpdateState>(
        listener: (context, state) {
          final response = state.response; 
          if (response is ErrorData) {
            Fluttertoast.showToast(msg: response.message, toastLength: Toast.LENGTH_LONG); 
            print('Error Data: ${response.message}');
          } else if (response is Success) {
            Fluttertoast.showToast(msg: 'Actualizacion exitosa', toastLength: Toast.LENGTH_LONG); 
            print('Success Data: ${response.data}');

            User user = response.data as User;

            // Updating the data of the user in session
            context.read<ProfileUpdateBloc>().add(UpdateUserSession(user: user));

            // Updating user data on screen - I wait 1s for the in-session update to finish
            Future.delayed(const Duration(seconds: 1), () {
              context.read<ProfileInfoBloc>().add(GetUserInfo());
            });

            context.pop();
          }
        },
        child: BlocBuilder<ProfileUpdateBloc, ProfileUpdateState>(
          builder: (context, state) {
            final response = state.response; 
            if (response is Loading) {
              // We display the content and the Loading
              return Stack(
                children: [
                  ProfileUpdateContent(user, state),
                  const Center(child: CircularProgressIndicator())
                ],
              );
            } 

            return ProfileUpdateContent(user, state);
          },
        ),
      ),
    );
  }
}
