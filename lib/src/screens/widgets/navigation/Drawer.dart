
import 'package:carpool_21_app/main.dart';
import 'package:carpool_21_app/src/domain/models/role.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomDialog.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomDialogTrip.dart';
import 'package:carpool_21_app/src/screens/widgets/navigation/bloc/navigationBloc.dart';
import 'package:carpool_21_app/src/screens/widgets/navigation/bloc/navigationEvent.dart';
import 'package:carpool_21_app/src/screens/widgets/navigation/bloc/navigationState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carpool_21_app/src/screens/utils/globals.dart' as globals;
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatelessWidget {

  final List<Role> roles;
  final User currentUser;

  CustomDrawer({required this.roles, required this.currentUser, super.key});

  @override
  Widget build(BuildContext context) {
    // final String currentRole = currentUser.roles!.isNotEmpty ? currentUser.roles!.first.idRole : 'unknown';
    print('Roles: ${roles.toList()}');

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Drawer(
          width: MediaQuery.of(context).size.width * 0.9, // 80% of screen width,
          child: Column(
            children: [
              Container(
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 30,
                    bottom: 16, 
                    right: 16, 
                    left: 30,
                  ), 
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30.0,
                        backgroundImage: AssetImage('lib/assets/img/profile-icon.png'),
                      ),
                      const SizedBox(width: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${currentUser.name} ${currentUser.lastName}' ?? 'Juan Mantese Test',
                            style: const TextStyle(
                              color: Color(0xFF006D59),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<NavigationBloc>().add(ChangeUserRol('PASSENGER'));
                          // Navigator.pushNamedAndRemoveUntil(context, '/passenger/home', (route) => false);
                          context.go('/passenger/0');
                          globals.currentRole = 'passenger';
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: globals.currentRole == 'passenger' ? const Color(0xFF00A98F) : null,
                          side: const BorderSide(color: Color(0xFF00A98F)),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                            ),
                          ),
                        ),
                        child: Text(
                          'Pasajero',
                          style: TextStyle(
                            color: globals.currentRole == 'passenger' ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (roles.length == 1) {
                            // Verificamos que el usuario tenga al menos 1 vehiculo registrado
                            CustomDialog(
                              context: context,
                              title: '¡Acceso Denegado!',
                              content: 'No puedes acceder al rol conductor hasta no tener 1 vehículo registrado.\n¿Deseas registrar tu vehículo?',
                              icon: Icons.warning_rounded,
                              onPressedSend: () {
                                // Navigator.pushNamed(context, '/car/register', arguments: '/passenger/home');
                                context.push('/car/list/register', extra: {
                                  'originPage': '/passenger/0',
                                });
                              },
                              textSendBtn: 'Registrar',
                              textCancelBtn: 'Cancelar',
                            );
                          } else {
                            context.read<NavigationBloc>().add(ChangeUserRol('DRIVER'));
                            // Navigator.pushNamedAndRemoveUntil(context, '/driver/home', (route) => false);
                            context.go('/driver/0');
                            globals.currentRole = 'driver';
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: globals.currentRole == 'driver'? const Color(0xFF00A98F) : null,
                          side: const BorderSide(color: Color(0xFF00A98F)),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                        ),
                        child: Text(
                          'Conductor',
                          style: TextStyle(
                            color: globals.currentRole == 'driver' ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: globals.currentRole == 'passenger' ? _itemsPassenger(context) : _itemsDriver(context)
              ),

              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      const Color(0xFF00A48B).withOpacity(0.5),
                      Colors.white.withOpacity(0.2),
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 20,
                    top: 16, 
                    right: 25, 
                    left: 25,
                  ), 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'lib/assets/img/footer-logo-carpool21.png',
                        height: 50,
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Términos y Condiciones',
                            style: TextStyle(color: Color(0xFF006D59)),
                          ),
                          Text(
                            'Versión: 1.0.0',
                            style: TextStyle(color: Color(0xFF6D6E71)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Items Drawer Passenger
  Widget _itemsPassenger(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.account_circle_outlined, color: Color(0xFF006D59)),
          title: const Text('Perfil'),
          onTap: () {
            // Navigator.pop(context);
            // Navigator.pushNamed(context, '/profile');
            context.pop();
            context.push('/profile');
          },
        ),
        ListTile(
          leading: const Icon(Icons.payments_rounded, color: Color(0xFF006D59)),
          title: const Text('Métodos de pago'),
          onTap: () {
            context.pop();
            // context.push('/metodos-pago');
          },
        ),
        ListTile(
          leading: const Icon(Icons.directions_car_rounded, color: Color(0xFF006D59)),
          title: const Text('Registrar Vehículo'),
          onTap: () {
            // Navigator.pop(context);
            // Navigator.pushNamed(context, '/car/register');
            context.pop();
            context.push('/car/list/register', extra: {
              'originPage': '/passenger/0',
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.perm_phone_msg, color: Color(0xFF006D59)),
          title: const Text('Contacto'),
          onTap: () {
            // Navigator.pop(context);
            // Navigator.pushNamed(context, '/contact');
            context.pop();
            context.push('/contact');
          },
        ),
        ListTile(
          leading: const Icon(Icons.article, color: Color(0xFF006D59)),
          title: const Text('Tips'),
          onTap: () {
            // Navigator.pop(context);
            // Navigator.pushNamed(context, '/tips');
            context.pop();
            context.push('/tips');
          },
        ),
        // ListTile(
        //   title: const Text('Maps'),
        //   onTap: () {
        //     Navigator.pop(context);
        //     Navigator.pushNamed(context, '/driver/finder');
        //   },
        // ),
        // ListTile(
        //   title: const Text('Modal Trip'),
        //   onTap: () {
        //     CustomDialogTrip(
        //       context: context,
        //     );
        //   },
        // ),
        // ListTile(
        //   title: const Text('Trip Detail'),
        //   onTap: () {
        //     Navigator.pop(context);
        //     Navigator.pushNamed(context, '/driver/trip/detail');
        //   },
        // ),
        ListTile(
          leading: const Icon(Icons.power_settings_new, color: Color(0xFF006D59)),
          title: const Text('Cerrar Sesion'),
          onTap: () {
            context.read<NavigationBloc>().add(Logout());
            context.go('/login');

            // Navigator.pushAndRemoveUntil(
            //   context, 
            //   MaterialPageRoute(builder: ((context) => const CarPool21())), 
            //   (route) => false
            // );

            // REVISAR
            // navigatorKey.currentState!.pushNamedAndRemoveUntil('/login', (route) => false);
          },
        ),
      ],
    );
  }

  // Items Drawer Driver
  Widget _itemsDriver(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.account_circle_outlined, color: Color(0xFF006D59)),
          title: const Text('Perfil'),
          onTap: () {
            // Navigator.pop(context);
            // Navigator.pushNamed(context, '/profile');
            context.pop();
            context.push('/profile');
          },
        ),
        ListTile(
          leading: const Icon(Icons.directions_car_rounded, color: Color(0xFF006D59)),
          title: const Text('Vehículos'),
          onTap: () {
            // Navigator.pop(context);
            // Navigator.pushNamed(context, '/car/list');
            context.pop();
            context.push('/car/list');
          },
        ),
        ListTile(
          leading: const Icon(Icons.perm_phone_msg, color: Color(0xFF006D59)),
          title: const Text('Contacto'),
          onTap: () {
            // Navigator.pop(context);
            // Navigator.pushNamed(context, '/contact');
            context.pop();
            // context.push('/contact');
          },
        ),
        ListTile(
          leading: const Icon(Icons.article, color: Color(0xFF006D59)),
          title: const Text('Tips'),
          onTap: () {
            // Navigator.pop(context);
            // Navigator.pushNamed(context, '/tips');
            context.pop();
            context.push('/tips');
          },
        ),
        // ListTile(
        //   title: const Text('Maps'),
        //   onTap: () {
        //     Navigator.pop(context);
        //     Navigator.pushNamed(context, '/driver/finder');
        //   },
        // ),
        // ListTile(
        //   title: const Text('MapLocation'),
        //   onTap: () {
        //     Navigator.pop(context);
        //     Navigator.pushNamed(context, '/driver/location');
        //   },
        // ),
        // ListTile(
        //   title: const Text('Modal'),
        //   onTap: () {
        //     CustomDialog(
        //       context: context,
        //       title: '¡No puedes crear un viaje!',
        //       content: 'Debes tener al menos 1 vehículo registrado para poder ofrecer viajes.\n¿Deseas registrar tu vehículo?',
        //       icon: Icons.warning_rounded,
        //       onPressedSend: () {
        //         Navigator.of(context).pop();
        //       },
        //       textSendBtn: 'Registrar',
        //       textCancelBtn: 'Cancelar',
        //     );
        //   },
        // ),
        // ListTile(
        //   title: const Text('Modal Trip'),
        //   onTap: () {
        //     CustomDialogTrip(
        //       context: context,
        //     );
        //   },
        // ),
        ListTile(
          leading: const Icon(Icons.power_settings_new, color: Color(0xFF006D59)),
          title: const Text('Cerrar Sesion'),
          onTap: () {
            context.read<NavigationBloc>().add(Logout());
            context.go('/login');

            // Navigator.pushAndRemoveUntil(
            //   context, 
            //   MaterialPageRoute(builder: ((context) => const CarPool21())), 
            //   (route) => false
            // );

            // REVISAR
            // navigatorKey.currentState!.pushNamedAndRemoveUntil('/login', (route) => false);
          },
        ),
      ],
    );
  }

}
