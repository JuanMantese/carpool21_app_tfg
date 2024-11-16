
import 'package:carpool_21_app/src/screens/pages/carInfo/register/bloc/carRegisterBloc.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/register/bloc/carRegisterEvent.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/register/bloc/carRegisterState.dart';
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomButton.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomIconBack.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CarRegisterContent extends StatelessWidget {

  CarRegisterState state;

  CarRegisterContent(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: state.formKey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Stack(
                children: [
                  _headerCarInfo(context),
                  CustomIconBack(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, left: 30),
                    onPressed: () {
                      // Navigator.pop(context);
                      context.pop();
                    },
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 26
                    ),
                    child: Column(
                      children: [
                        _cardCarInfo(context),
                        _formRegisterCar(context),

                        const Spacer(),
                        CustomButton(
                          onPressed: () {
                            if (state.formKey!.currentState!.validate()) {                      
                              context.read<CarRegisterBloc>().add(FormSubmit());
                            } else {
                              print('El formulario no es valido');
                            }
                          },
                          margin: const EdgeInsets.only(left: 60, right: 60, top: 15),
                          text: 'Registrar Vehículo',
                          color: const Color(0xFF00A98F)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerCarInfo(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 30),
      height: MediaQuery.of(context).size.height * 0.33,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 0, 64, 52), // Top color
            Color(0xFF00A48B), // Bottom color
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: const Text(
        'REGISTRAR VEHÍCULO',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 19
        ),
      ),
    );
  }

  Widget _cardCarInfo(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 35, right: 35, top: 150),
      width: MediaQuery.of(context).size.width,
      height: 216,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: Column(
          children: [
            _imageCar(context),
            // Text(
            //   '${user?.name} ${user?.lastName}' ?? 'Nombre de Usuario',
            //   style: const TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 16
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _imageCar(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.only(top: 30, bottom: 15),
      child: Image.asset(
        'lib/assets/img/car_logo.jpg',
        fit: BoxFit.cover,
      ) 
    );
  }

  Widget _formRegisterCar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 35, right: 35, top: 10),
      width: MediaQuery.of(context).size.width,
      child: IntrinsicHeight(
        child: Column(
          children: [
            Column(
              children: [
                ...[
                  CustomTextField(
                    onChanged: (text) {
                      context.read<CarRegisterBloc>().add(BrandChanged(brandInput: BlocFormItem(value: text)));
                    },
                    validator: (value) {
                      return state.brand.error;
                    },
                    text: 'Marca', 
                    inputType: TextInputType.text
                  ),
                  CustomTextField(
                    onChanged: (text) {
                      context.read<CarRegisterBloc>().add(ModelChanged(modelInput: BlocFormItem(value: text)));
                    },
                    validator: (value) {
                      return state.model.error;
                    },
                    text: 'Modelo', 
                    inputType: TextInputType.text
                  ),
                  CustomTextField(
                    onChanged: (text) {
                      context.read<CarRegisterBloc>().add(PatentChanged(patentInput: BlocFormItem(value: text)));
                    },
                    validator: (value) {
                      return state.patent.error;
                    },
                    text: 'Patente', 
                    inputType: TextInputType.text
                  ),
                  CustomTextField(
                    onChanged: (text) {
                      context.read<CarRegisterBloc>().add(YearChanged(yearInput: BlocFormItem(value: text)));
                    },
                    validator: (value) {
                      return state.year.error;
                    },
                    text: 'Año del Vehiculo', 
                    inputType: TextInputType.text
                  ),
                  CustomTextField(
                    onChanged: (text) {
                      context.read<CarRegisterBloc>().add(ColorChanged(colorInput: BlocFormItem(value: text)));
                    },
                    validator: (value) {
                      return state.color.error;
                    },
                    text: 'Color', 
                    inputType: TextInputType.text
                  ),
                  CustomTextField(
                    onChanged: (text) {
                      context.read<CarRegisterBloc>().add(NroGreenCardChanged(nroGreenCardInput: BlocFormItem(value: text)));
                    },
                    validator: (value) {
                      return state.nroGreenCard.error;
                    },
                    text: 'Nro. Cedula Verde', 
                    inputType: TextInputType.text
                  ),
                ].expand((widget) => [widget, const SizedBox(height: 10,)]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}