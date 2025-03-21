import 'package:carpool_21_app/src/screens/pages/onboarding/bloc/onboarding_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/onboarding/bloc/onboarding_event.dart';
import 'package:carpool_21_app/src/screens/pages/onboarding/bloc/onboarding_state.dart';
import 'package:carpool_21_app/src/screens/pages/onboarding/onboarding_content.dart';
import 'package:carpool_21_app/src/screens/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(),
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 40.0,
                horizontal: 8.0,
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Flexible(
                        child: FractionallySizedBox(
                          widthFactor: 0.8,
                          heightFactor: 0.9,
                          child: _Page(),
                        ),
                      ),
                      Center(
                        child: BlocBuilder<OnboardingBloc, OnboardingState>(
                          builder: (context, state) {
                            return CustomButton(
                              text: state.currentPage < 3 ? 'Siguiente' : 'Comenzar',
                              onPressed: () {
                                if (state.currentPage < 3) {
                                  context.read<OnboardingBloc>().add(NextPageEvent());
                                } else {
                                  context.pop('/home');
                                }
                              },
                              margin: const EdgeInsets.only(
                                right: 40,
                                left: 40,
                                bottom: 20
                              ),
                            );                          
                          },
                        ),
                      ),
                      const _Dots(),
                    ],
                  ),
                  BlocBuilder<OnboardingBloc, OnboardingState>(
                    builder: (context, state) {
                      return Stack(
                        children: [
                          if (state.currentPage < 3)
                            Positioned(
                              top: 30,
                              right: 20,
                              child: TextButton(
                                onPressed: () {
                                  context.read<OnboardingBloc>().add(SkipToLastPageEvent());
                                },
                                child: const Text(
                                  'SALTAR',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF00A98F)
                                  ),
                                ),
                              ),
                            ),
              
                          if (state.currentPage > 0)
                            Positioned(
                              top: 30,
                              left: 20,
                              child: IconButton(
                                onPressed: () {
                                  context.read<OnboardingBloc>().add(PreviousPageEvent());
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 25,
                                  color: Colors.green,
                                ),
                              ),
                            )
                        ],
                      );
                    },
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

class _Page extends StatelessWidget {
  const _Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onboardingData = [
      {
        "title": "Bienvenido a CarPool 21",
        "text": "Cuando comiences a utilizar la aplicación, podrás buscar tu próximo viaje. \nSi lo deseas, puedes registrar tu vehículo para ofrecer viajes y ayudar a la Comunidad 21.",
        "image": "lib/assets/img/logo-carpool21.png",
      },
      {
        "title": "Como pasajero podes...",
        "text":
            "Buscar tu próximo viaje hacia o desde una de las sedes de la Universidad Siglo 21. \nReservar con anticipación y confirmar tu viaje de manera segura.",
        "image": "lib/assets/img/logo-carpool21.png"
      },
      {
        "title": "¿Cómo ser conductor?",
        "text":
            "Primero deberás registras tú vehículo en el sistema. \nSeleccionas el cual es tu lugar de Origen y Destino. Configura tu viaje y comenzá la aventura.",
        "image": "lib/assets/img/logo-carpool21.png"
      },
      {
        "title": "Términos y Condiciones",
        "text": "Aquí podes acceder a nuestros términos y condiciones.",
        "image": "lib/assets/img/logo-carpool21.png"
      },
    ];

    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        final bloc = context.read<OnboardingBloc>();

        return PageView.builder(
          controller: bloc.pageController,
          onPageChanged: (index) {
            bloc.add(UpdatePageEvent(index));
          },
          itemCount: onboardingData.length,
          itemBuilder: (context, index) => OnboardingContent(
            title: onboardingData[index]["title"]!,
            image: onboardingData[index]["image"]!,
            text: onboardingData[index]["text"]!,
          ),
        );
      },
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: state.currentPage == index ? 15 : 10,
              height: state.currentPage == index ? 15 : 10,
              decoration: BoxDecoration(
                color: state.currentPage == index ? const Color(0xFF00A98F) : Colors.grey,
                borderRadius: BorderRadius.circular(50),
              ),
            );
          }),
        );
      },
    );
  }
}
