
import 'package:carpool_21_app/src/screens/pages/errors/bloc/error_bloc.dart';
import 'package:carpool_21_app/src/screens/pages/errors/error_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

getMessageFromStatusCode(int? statusCode) {
  if (statusCode == null) {
    return "Algo salió mal.";
  }
  return statusCodeMessage[statusCode] ?? "Algo salió mal.";
}


class ErrorScreen extends StatelessWidget {
  final String message;
  final String? subtitle;
  final AssetImage? errorImage;
  final void Function()? retryOverride;
  final bool? compact;
  final String? button;

  const ErrorScreen({
    Key? key,
    required this.message,
    this.subtitle,
    this.errorImage,
    this.retryOverride,
    this.compact,
    this.button
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ErrorBloc, ErrorState>(
      builder: (context, state) {
        final bloc = context.read<ErrorBloc>();

        if (compact == true) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 18, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                // color: AppColors.baseColor[80]
                                color: Colors.amber
                              ),
                            ),
                            Text(
                              subtitle ?? "Por favor volvé a intentarlo más tarde.",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                // color: AppColors.baseColor[80]
                                color: Colors.amber
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Image(
                      height: 70,
                      image: errorImage ??
                          const AssetImage('lib/assets/img/error-internal-server.png'),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(image: errorImage ?? const AssetImage('lib/assets/img/error-internal-server.png')),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                          child: Text(
                            message,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              // color: AppColors.baseColor[80]
                              color: Colors.amber
                            ),
                          ),
                        ),

                        Text(subtitle ?? 'Por favor volvé a intentarlo más tarde.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium),
                        
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: ElevatedButton(
                            onPressed: retryOverride ??
                                () {
                                  bloc.add(RetryEvent());
                                },
                            child: Text(button ?? 'Reintentar'),
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(300.0, 50.0),
                                // backgroundColor: AppColors.primary[100],
                                backgroundColor: Colors.amber,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
