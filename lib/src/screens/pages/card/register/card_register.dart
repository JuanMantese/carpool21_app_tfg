import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:carpool_21_app/src/screens/pages/card/register/bloc/card_register_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/card/register/bloc/card_register_event.dart';
import 'package:carpool_21_app/src/screens/pages/card/register/bloc/card_register_state.dart';
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';
import 'package:carpool_21_app/src/screens/widgets/custom_month_year_field.dart';
import 'package:carpool_21_app/src/screens/widgets/custom_text_field.dart';
import 'package:carpool_21_app/src/screens/widgets/floating_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class RegisterCardDialog extends StatefulWidget {
  final BuildContext context;
  final bool onReserveSeat;
  final void Function(String cardNumber, String cardHolder, String expiryDate, String cvv)? onPressedAfterSuccess;

  RegisterCardDialog({
    super.key,
    required this.context,
    this.onReserveSeat = false,
    this.onPressedAfterSuccess,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return this;
      },
    );
  }

  @override
  _RegisterCardDialogState createState() => _RegisterCardDialogState();
}

class _RegisterCardDialogState extends State<RegisterCardDialog> {
  bool _isCardFrontView = true;
  bool _saveCard = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardRegisterBloc, CardRegisterState>(
      builder: (context, state) {
        // Comprobamos si la respuesta es 'Success' y cerramos el modal
        if (state.createdCardRes is Success) {
          // Cerramos el modal cuando el estado sea 'Success'
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop();  // Cerrar el modal
          });
        } else if (state.createdCardRes is ErrorData) {
          // Si hay un error, mostramos el mensaje de error
          ErrorData error = state.createdCardRes as ErrorData; // Casteamos a ErrorData
          print("Error al registrar la tarjeta: ${error.message}");

          WidgetsBinding.instance.addPostFrameCallback((_) {
            showOverlayMessage(context, error.message);
          });
        }

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          elevation: 0,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 180, 
                  left: 20, 
                  right: 20, 
                  bottom: 20
                ),
                width: 400,
                child: Form(
                  key: state.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // CreditCardWidget(
                      //   cardNumber: _cardNumberController.text,
                      //   expiryDate: _expiryDate,
                      //   cardHolderName: _cardHolderController.text,
                      //   cvvCode: _cvvController.text,
                      //   showBackView: !_isCardFrontView, // Determina si mostramos el frente o el reverso de la tarjeta
                      //   isHolderNameVisible: true, // Mostramos el nombre del titular de la tarjeta
                      //   obscureCardCvv: true, // Ocultar el CVV si lo deseas
                      //   obscureCardNumber: true, // Ocultar el número de la tarjeta si lo deseas
                      //   onCreditCardWidgetChange: (CreditCardBrand) {
                      //     // Aquí puedes manejar cambios relacionados con la marca de la tarjeta
                      //   },
                      // ),
                  
                      CustomTextField(
                        onChanged: (text) {
                          String formattedText = formatCardNumber(text);

                          context.read<CardRegisterBloc>().add(CardNumberChanged(cardNumberInput: BlocFormItem(value: text)));
                  
                          print(text);
                          print(formattedText);
                        },
                        validator: (value) {
                          return state.cardNumber.error;
                        },
                        text: 'Número de Tarjeta',
                        initialValue: state.cardNumber.value,
                        inputType: TextInputType.number,
                        maxLength: 16,
                        isNumber: true, // Esto activará la validación de solo números
                      ),
                  
                      const SizedBox(height: 12),
                  
                      CustomTextField(
                        onChanged: (text) {
                          context.read<CardRegisterBloc>().add(CardHolderChanged(cardHolderInput: BlocFormItem(value: text)));
                        },
                        text: 'Nombre del Titular',
                        initialValue: state.cardHolder.value,
                        inputType: TextInputType.text,
                        isAlphabetic: true, // Esto activará la validación de solo letras
                      ),
                  
                      const SizedBox(height: 12),
                  
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // El campo de fecha de expiración
                          Expanded(
                            child: CustomMonthYearInput(
                              onChanged: (value) {
                                context.read<CardRegisterBloc>().add(ExpiryDateChanged(expiryDateInput: BlocFormItem(value: value)));
                              },
                              text: 'Fecha de Expiración (MM/AA)',
                              initialValue: state.expiryDate.value,
                            ),
                          ),
                  
                          const SizedBox(width: 20),
                  
                          // El campo de CVV
                          Expanded(
                            child: CustomTextField(
                              onChanged: (text) {
                                context.read<CardRegisterBloc>().add(CvvChanged(cvvInput: BlocFormItem(value: text)));
                              },
                              validator: (value) {
                                return state.cvv.error;
                              },
                              text: 'CVV',
                              initialValue: state.cvv.value,
                              inputType: TextInputType.text,
                              isNumber: true, // Esto activará la validación de solo números
                            )
                          ),
                        ],
                      ),
                  
                      const SizedBox(height: 6),
                  
                      // Checkbox para guardar tarjeta
                      if (widget.onReserveSeat)
                        CheckboxListTile(
                          title: const Text("Guardar Tarjeta"),
                          value: _saveCard,
                          onChanged: (bool? value) {
                            setState(() {
                              _saveCard = value ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          activeColor: const Color(0xFF00A98F),
                        ),
                  
                      const SizedBox(height: 20),
                  
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (widget.onReserveSeat) {
                                if (state.formKey != null && state.formKey!.currentState!.validate()) {
                                  print("Pagando y Reservando...");
                                  widget.onPressedAfterSuccess!(state.cardNumber.value, state.cardHolder.value, state.expiryDate.value, state.cvv.value);
                                }
                              } else if (state.formKey != null && state.formKey!.currentState!.validate()) {
                                print("Registrando tarjeta...");
                                context.read<CardRegisterBloc>().add(FormSubmit());
                              } 
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFF00A98F),
                              side: const BorderSide(color: Color(0xFF00A98F)),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            child: const Text(
                              'Pagar y Reservar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Utilizamos el CreditCardWidget de flutter_credit_card para mostrar la tarjeta - Tarjeta Flotante
              Positioned(
                left: 0,
                right: 0,
                top: -60, // Ajusta este valor para sobresalir más o menos
                child: CreditCardWidget(
                  cardNumber: state.cardNumber.value,
                  expiryDate: state.expiryDate.value,
                  cardHolderName: state.cardHolder.value,
                  cvvCode: state.cvv.value,
                  showBackView: !_isCardFrontView, // Determina si mostramos el frente o el reverso de la tarjeta
                  isHolderNameVisible: true, // Mostramos el nombre del titular de la tarjeta
                  obscureCardCvv: true, // Ocultar el CVV si lo deseas
                  obscureCardNumber: true, // Ocultar el número de la tarjeta si lo deseas
                  onCreditCardWidgetChange: (CreditCardBrand) {
                    // Aquí puedes manejar cambios relacionados con la marca de la tarjeta
                  },
                ),
              ),

              // Loading Circle que aparecerá encima del modal
              if (state.createdCardRes is Loading) 
                const Positioned(
                  left: 0,
                  right: 0,
                  top: 100, // Ajusta esta posición si es necesario
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              
            ],
          ),
        );
      },
    );
  }

  // Función que formatea el número de tarjeta agregando espacios cada 4 caracteres
  String formatCardNumber(String cardNumber) {
    // Eliminar cualquier espacio previo
    String cleaned = cardNumber.replaceAll(RegExp(r'\s+'), '');

    // Insertar espacios cada 4 caracteres
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < cleaned.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' '); // Agregar espacio cada 4 caracteres
      }
      buffer.write(cleaned[i]);
    }

    return buffer.toString();
  }
}
