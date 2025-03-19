// ignore_for_file: avoid_print
import 'package:carpool_21_app/blocSocketIO/socket_io_bloc.dart';
import 'package:carpool_21_app/blocSocketIO/socket_io_event.dart';
import 'package:carpool_21_app/src/domain/models/car_info.dart';
import 'package:carpool_21_app/src/domain/models/payment_method.dart';
import 'package:carpool_21_app/src/domain/models/reserve_detail.dart';
import 'package:carpool_21_app/src/domain/models/role.dart';
import 'package:carpool_21_app/src/domain/models/trip_detail.dart';
import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/screens/pages/contact/contact.dart';
import 'package:carpool_21_app/src/screens/pages/onboarding/onboarding.dart';
import 'package:carpool_21_app/src/screens/pages/payments/payment_method.dart';
import 'package:carpool_21_app/src/screens/widgets/custom_dialog.dart';
import 'package:carpool_21_app/src/screens/widgets/navigation/bloc/navigationBloc.dart';
import 'package:carpool_21_app/src/screens/widgets/navigation/bloc/navigationEvent.dart';
import 'package:carpool_21_app/src/screens/widgets/navigation/bloc/navigationState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carpool_21_app/src/screens/utils/globals.dart' as globals;
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {

  final List<Role> roles;
  final User currentUser;

  const CustomDrawer({
    required this.roles, 
    required this.currentUser, 
    super.key
  });


  // DATOS DE TESTING PARA PROBAR FUNCIONALIDADES - A ELIMINAR
    static TripDetail tripExample = TripDetail(
        idTrip: 1,
        idDriver: 1001,
        driver: Driver(
          name: "Juan",
          lastName: "Perez",
          phone: "1234567890",
          photo: "url_to_photo",
        ),
        pickupNeighborhood: "Centro",
        pickupText: "Calle Falsa 123",
        pickupLat: -31.4201,
        pickupLng: -64.1888,
        destinationNeighborhood: "Nueva Córdoba",
        destinationText: "Avenida Juan B. Justo 456",
        destinationLat: -31.4133,
        destinationLng: -64.1818,
        availableSeats: 3,
        departureTime: "2025-01-25T10:00:00",
        distance: 10.5,
        timeDifference: 15,
        compensation: 50.0,
        observations: "Sin observaciones",
        state: 1,
        vehicle: CarInfo(
          color: 'red',
          brand: "Toyota",
          model: "Corolla",
          year: 2020,
          patent: "ABC123",
        ),
        reservations: [
          Reservations(
            idReservation: 1,
            isPaid: true,
            passenger: Passenger(
              idUser: 101,
              name: "Carlos",
              lastName: "Gomez",
              phone: "0987654321",
              photo: "url_to_photo",
            ),
          ),
          Reservations(
            idReservation: 2,
            isPaid: false,
            passenger: Passenger(
              idUser: 102,
              name: "Ana",
              lastName: "Lopez",
              phone: "1122334455",
              photo: "url_to_photo",
            ),
          ),
        ],
      );

      static ReserveDetail reserveExample = ReserveDetail(
        idReservation: 1,
        isPaid: true,
        tripRequest: TripDetail(
          idTrip: 1,
          idDriver: 1001,
          driver: Driver(
            name: "Juan",
            lastName: "Perez",
            phone: "1234567890",
            photo: "url_to_photo",
          ),
          pickupNeighborhood: "Centro",
          pickupText: "Calle Falsa 123",
          pickupLat: -31.4201,
          pickupLng: -64.1888,
          destinationNeighborhood: "Nueva Córdoba",
          destinationText: "Avenida Juan B. Justo 456",
          destinationLat: -31.4133,
          destinationLng: -64.1818,
          availableSeats: 3,
          departureTime: "2025-01-25T10:00:00",
          distance: 10.5,
          timeDifference: 15,
          compensation: 50.0,
          observations: "Sin observaciones",
          state: 1,
          vehicle: CarInfo(
            color: 'red',
            brand: "Toyota",
            model: "Corolla",
            year: 2020,
            patent: "ABC123",
          ),
          reservations: [
            Reservations(
              idReservation: 1,
              isPaid: true,
              passenger: Passenger(
                idUser: 101,
                name: "Carlos",
                lastName: "Gomez",
                phone: "0987654321",
                photo: "url_to_photo",
              ),
            ),
            Reservations(
              idReservation: 2,
              isPaid: false,
              passenger: Passenger(
                idUser: 102,
                name: "Ana",
                lastName: "Lopez",
                phone: "1122334455",
                photo: "url_to_photo",
              ),
            ),
          ],
        ),
        driver: Driver(
          name: "Juan",
          lastName: "Perez",
          phone: "1234567890",
          photo: "url_to_photo",
        ),
      );



  @override
  Widget build(BuildContext context) {
    // final String currentRole = currentUser.roles!.isNotEmpty ? currentUser.roles!.first.idRole : 'unknown';
    print('Roles: ${roles.toList()}');

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Drawer(
          elevation: 0,
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
                            '${currentUser.name} ${currentUser.lastName}',
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
                          
                          // Redirigiendo a la Home del Passenger
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

                            // Redirigiendo a la Home del Driver
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
            context.pop();
            context.push('/profile');
          },
        ),
        ListTile(
          leading: const Icon(Icons.payments_rounded, color: Color(0xFF006D59)),
          title: const Text('Métodos de pago'),
          onTap: () {
            context.pop();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => PaymentMethod(
                selectedMethod: PaymentMethodModel.defaultMethod(), // Pasamos el método actual
                inDrawer: true,
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.directions_car_rounded, color: Color(0xFF006D59)),
          title: const Text('Registrar Vehículo'),
          onTap: () {
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
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => const ContactPage(),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.article, color: Color(0xFF006D59)),
          title: const Text('Tips'),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => const Onboarding(),
            );
          },
        ),

        // Opciones de TESTING a eliminar ----------------------------------
        // ListTile(
        //   leading: const Icon(Icons.article, color: Color(0xFF006D59)),
        //   title: const Text('CardRegister Modal'),
        //   onTap: () {
        //     RegisterCardDialog(
        //       context: context,
        //     );
        //   },
        // ),
        // ListTile(
        //   leading: const Icon(Icons.article, color: Color(0xFF006D59)),
        //   title: const Text('DriverRaiting'),
        //   onTap: () {
        //     DialogDriverRatingTrip(
        //       context: context,
        //       tripDetail: tripExample,
        //     );
        //   },
        // ),
        // ListTile(
        //   leading: const Icon(Icons.article, color: Color(0xFF006D59)),
        //   title: const Text('PassengerRating'),
        //   onTap: () {
        //     DialogPassengerRatingTrip(
        //       context: context,
        //       tripReservationDetail: reserveExample,
        //     );
        //   },
        // ),
        // ListTile(
        //   leading: const Icon(Icons.article, color: Color(0xFF006D59)),
        //   title: const Text('MapTrip Passenger'),
        //   onTap: () {
        //     // Testeando la nueva pantalla de viaje en vivo
        //     context.push('/passenger/0/reserve/mapTripPassenger', extra: {
        //       'idReserve': 111
        //     });
        //   },
        // ),
        // ListTile(
        //   leading: const Icon(Icons.article, color: Color(0xFF006D59)),
        //   title: const Text('MapTrip Driver'),
        //   onTap: () {
        //     // Testeando la nueva pantalla de viaje en vivo
        //     context.push('/driver/0/mapTripDriver', extra: {
        //       'idTrip': 134
        //     });
        //   },
        // ),

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
  
        ListTile(
          leading: const Icon(Icons.power_settings_new, color: Color(0xFF006D59)),
          title: const Text('Cerrar Sesion'),
          onTap: () {
            // Desconectando el Socket IO
            context.read<SocketIOBloc>().add(DisconnectSocketIO());
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
            context.pop();
            context.push('/profile');
          },
        ),
        ListTile(
          leading: const Icon(Icons.directions_car_rounded, color: Color(0xFF006D59)),
          title: const Text('Vehículos'),
          onTap: () {
            context.pop();
            context.push('/car/list');
          },
        ),
        ListTile(
          leading: const Icon(Icons.perm_phone_msg, color: Color(0xFF006D59)),
          title: const Text('Contacto'),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => const ContactPage(),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.article, color: Color(0xFF006D59)),
          title: const Text('Tips'),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => const Onboarding(),
            );
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
        //     context.pop();
        //     context.push('/driver/0/location');
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
            // Desconectando el Socket IO
            context.read<SocketIOBloc>().add(DisconnectSocketIO());
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
