import 'package:carpool_21_app/src/data/dataSource/remote/services/usersService.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/home/bloc/passengerHomeBloc.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/home/bloc/passengerHomeEvent.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/home/bloc/passengerHomeState.dart';
import 'package:carpool_21_app/src/screens/widgets/navigation/Drawer.dart';
import 'package:carpool_21_app/src/screens/widgets/navigation/Navigation.dart';
import 'package:carpool_21_app/src/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class PassengerHomePage extends StatefulWidget {
  
  final int pageIndex;
  
  const PassengerHomePage({
    super.key,
    required this.pageIndex
  });

  @override
  State<PassengerHomePage> createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHomePage> with AutomaticKeepAliveClientMixin {
  
  late PageController pageController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Defining the screens that I will be able to access
  final viewRoutes = const <Widget>[
    PassengerHomeView(),
    ReservesView()
  ];
  
  @override
  void initState() {
    super.initState();

    // Controlar la visualización de pantalla
    pageController = PageController(
      keepPage: true,
      initialPage: widget.pageIndex,
    );

    // Obtén la instancia de UsersService
    UsersService userService = GetIt.instance<UsersService>();

    // Dispara el evento para obtener la información del pasajero
    context.read<PassengerHomeBloc>().add(GetUserInfo(userService));

    // Dispara el evento para obtener la reserva del pasajero
    context.read<PassengerHomeBloc>().add(GetCurrentReserve());
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Le dice al view como fue construido originalmente el widget para preservarlo

    if ( pageController.hasClients ) {
      pageController.animateToPage(
        widget.pageIndex, 
        curve: Curves.easeInOut, 
        duration: const Duration( milliseconds: 250),
      );
    }

    return BlocBuilder<PassengerHomeBloc, PassengerHomeState>(
      builder: (context, state) {
        if (state.currentUser != null) {
          return Scaffold(
            key: _scaffoldKey,
            endDrawer: CustomDrawer(
              roles: state.roles ?? [],
              currentUser: state.currentUser!,
            ),
            // body: IndexedStack(
            //   index: widget.pageIndex,
            //   children: viewRoutes,
            // ),
            body: PageView(
              //* Esto evitará que rebote 
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: viewRoutes,
            ),
            bottomNavigationBar: CustomNavigation(
              scaffoldKey: _scaffoldKey,
              roles: state.roles ?? [], 
              currentUser: state.currentUser!, 
              currentIndex: widget.pageIndex
            ),
          );
        }
        return Center(child: Text('Salio'));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
