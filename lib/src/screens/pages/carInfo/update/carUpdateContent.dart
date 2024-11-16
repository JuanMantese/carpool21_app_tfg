import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/update/bloc/carUpdateBloc.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/update/bloc/carUpdateEvent.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/update/bloc/carUpdateState.dart';
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomButton.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomIconBack.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CarUpdateContent extends StatelessWidget {

  CarInfo? car;
  CarUpdateState state;

  CarUpdateContent(this.car, this.state, {super.key});

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
                  _headerCar(context),
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
                        _formUpdateCar(context),

                        const Spacer(),
                        CustomButton(
                          margin: const EdgeInsets.only(left: 60, right: 60, top: 15),
                          text: 'Guardar cambios', 
                          onPressed: () {
                            
                          }
                        )
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

  Widget _headerCar(BuildContext context) {
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
        'EDICIÓN DEL VEHICULO',
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
      height: 250,
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: Column(
          children: [
            _imageCar(context),
            Text(
              '${car?.brand} ${car?.model}' ?? 'Nombre de Usuario',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
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

  Widget _formUpdateCar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 35, right: 35, top: 10),
      width: MediaQuery.of(context).size.width,
      child: IntrinsicHeight(
        child: Column(
          children: [
            ...[
              CustomTextField(
                onChanged: (text) {
                  context.read<CarUpdateBloc>().add(BrandChanged(brandInput: BlocFormItem(value: text)));
                },
                validator: (value) {
                  return state.brand.error;
                },
                text: 'Marca', 
                initialValue: car?.brand,
                inputType: TextInputType.text
              ),
              CustomTextField(
                onChanged: (text) {
                  context.read<CarUpdateBloc>().add(ModelChanged(modelInput: BlocFormItem(value: text)));
                },
                validator: (value) {
                  return state.model.error;
                },
                text: 'Modelo', 
                initialValue: car?.model,
                inputType: TextInputType.text
              ),
              CustomTextField(
                onChanged: (text) {
                  context.read<CarUpdateBloc>().add(PatentChanged(patentInput: BlocFormItem(value: text)));
                },
                validator: (value) {
                  return state.patent.error;
                },
                text: 'Patente', 
                initialValue: car?.patent,
                inputType: TextInputType.text
              ),
              CustomTextField(
                onChanged: (text) {
                  context.read<CarUpdateBloc>().add(ColorChanged(colorInput: BlocFormItem(value: text)));
                },
                validator: (value) {
                  return state.color.error;
                },
                text: 'Color', 
                initialValue: car?.color,
                inputType: TextInputType.text
              ),
              CustomTextField(
                onChanged: (text) {
                  context.read<CarUpdateBloc>().add(NroGreenCardChanged(nroGreenCardInput: BlocFormItem(value: text)));
                },
                validator: (value) {
                  return state.nroGreenCard.error;
                },
                text: 'Cedula Verde', 
                initialValue: car?.nroGreenCard.toString(),
                inputType: TextInputType.number
              ),
              CustomTextField(
                onChanged: (text) {
                  context.read<CarUpdateBloc>().add(YearChanged(yearInput: BlocFormItem(value: text)));
                },
                validator: (value) {
                  return state.year.error;
                },
                text: 'Año', 
                initialValue: car?.year.toString(),
                inputType: TextInputType.text
              ),
            ].expand((widget) => [widget, const SizedBox(height: 10,)]),
          ],
        ),
      ),
    );
  }
}