import 'package:carpool_21_app/src/screens/widgets/custom_icon_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Bloc
class ContactBloc extends Cubit<void> {
  ContactBloc() : super(null);
}

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContactBloc(),
      child: Scaffold(
          body: SafeArea(
            child: SizedBox(
              width: double.infinity,
            height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                vertical: 80.0,
                horizontal: 16.0,
              ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomIconBack(
                          margin: const EdgeInsets.only(left: 10),
                          color: Colors.black,
                          onPressed: () {
                            context.pop();
                          },
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Soporte de CarPool 21',
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const ListTile(
                      leading: Icon(Icons.phone, color: Color(0xFF00A98F)),
                      title: Text('+54 351 123 4567'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.email, color: Color(0xFF00A98F)),
                      title: Text('soporte@carpool21.com'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      
    );
  }
}
