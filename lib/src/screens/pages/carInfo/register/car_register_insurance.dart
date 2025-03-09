import 'package:carpool_21_app/src/screens/pages/carInfo/register/bloc/car_register_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/register/bloc/car_register_event.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/register/bloc/car_register_state.dart';
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';
import 'package:carpool_21_app/src/screens/widgets/custom_button.dart';
import 'package:carpool_21_app/src/screens/widgets/custom_date_field.dart';
import 'package:carpool_21_app/src/screens/widgets/custom_icon_back.dart';
import 'package:carpool_21_app/src/screens/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarRegisterInsurance extends StatelessWidget {
  final CarRegisterState state;

  const CarRegisterInsurance(
    this.state,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: state.formKeyInsurance, // Nuevo formKey para el seguro
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
                      context.read<CarRegisterBloc>().add(PreviousStep());
                    },
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 26,
                    ),
                    child: Column(
                      children: [
                        _cardCarInfo(context),
                        _formInsurance(context, state),

                        const Spacer(),
                        CustomButton(
                          onPressed: () {
                            if (state.formKeyInsurance!.currentState!.validate()) {
                              context.read<CarRegisterBloc>().add(FormSubmit());
                            } else {
                              print('Uno o más formularios no son válidos');
                            }
                          },
                          margin: const EdgeInsets.only(left: 60, right: 60, top: 15),
                          text: 'Registrar Vehículo',
                          color: const Color(0xFF00A98F),
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

  Widget _formInsurance(BuildContext context, CarRegisterState state) {
    return Container(
      margin: const EdgeInsets.only(left: 35, right: 35, top: 10),
      width: MediaQuery.of(context).size.width,
      child: IntrinsicHeight(
        child: Column(
          children: [
            ...[
              CustomTextField(
                initialValue: state.insuranceCompany.value,
                onChanged: (value) { 
                  context.read<CarRegisterBloc>().add(InsuranceCompanyChanged(insuranceCompanyInput: BlocFormItem(value: value)));
                },
                validator: (value) {
                  return state.insuranceCompany.error;
                },
                text: 'Nombre de la compañia de seguro', 
                inputType: TextInputType.text
              ),
              CustomTextField(
                initialValue: state.insuranceType.value,
                onChanged: (value) { 
                  context.read<CarRegisterBloc>().add(InsuranceTypeChanged(insuranceTypeInput: BlocFormItem(value: value)));
                },
                validator: (value) {
                  return state.insuranceType.error;
                },
                text: 'Tipo de seguro', 
                inputType: TextInputType.text
              ),
              CustomDateField(
                initialValue: state.insuranceExpiration.value, // Si hay una fecha previa
                onChanged: (value) { 
                  context.read<CarRegisterBloc>().add(InsuranceExpirationChanged(insuranceExpirationInput: BlocFormItem(value: value)));
                },
                validator: (value) {
                  return state.insuranceExpiration.error;
                },
                text: 'Fecha de vencimiento del seguro', 
              ),
              CustomTextField(
                initialValue: state.policyNumber.value,
                onChanged: (value) { 
                  context.read<CarRegisterBloc>().add(PolicyNumberChanged(policyNumberInput: BlocFormItem(value: value)));
                },
                validator: (value) {
                  return state.policyNumber.error;
                },
                text: 'Número de Póliza', 
                inputType: TextInputType.text
              ),
              CustomTextField(
                initialValue: state.cuilCuit.value,
                onChanged: (value) { 
                  context.read<CarRegisterBloc>().add(CuilCuitChanged(cuilCuitInput: BlocFormItem(value: value)));
                },
                validator: (value) {
                  return state.cuilCuit.error;
                },
                text: 'CUIL/CUIT', 
                inputType: TextInputType.text
              ),
            ].expand((widget) => [widget, const SizedBox(height: 10,)]),
          ],
        ),
      ),
    );
  }
}
