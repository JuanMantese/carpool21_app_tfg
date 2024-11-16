import 'package:carpool_21_app/src/screens/pages/profile/info/bloc/profileInfoBloc.dart';
import 'package:carpool_21_app/src/screens/pages/profile/info/bloc/profileInfoEvent.dart';
import 'package:carpool_21_app/src/screens/pages/profile/info/bloc/profileInfoState.dart';
import 'package:carpool_21_app/src/screens/pages/profile/info/profileInfoContent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileInfoPage extends StatefulWidget {
  const ProfileInfoPage({super.key});

  @override
  State<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  @override
  void initState() {
    super.initState();
    // Dispara el evento para obtener la información del usuario
    context.read<ProfileInfoBloc>().add(GetUserInfo());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<ProfileInfoBloc, ProfileInfoState>(
          builder: (context, state) {
            return ProfileInfoContent(state.user);
          },
        ),
      ),
    );
  }
}
