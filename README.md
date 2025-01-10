# Carpool 21 - App

<p align="center">
  <img alt="carpool_logo" src="./lib/assets/img/logo-carpool21.png" width="150" />
</p>

A new Flutter Application for students at Universidad Empresarial Siglo 21.

Developed by:
  - Juan Mantese
    
    Legajo: SOF01669
    
    DNI: 43272208

## Getting Started

### Requeriments
- Flutter v3.19.5
- Dart v3.3.3
- DevTools v2.31.1
- VS Code v1.88
- XCode (MacOS)
- Cocoapods (MacOS)
- Android SDK (Windows)

### Enviroments (.env.local, .env.develop, .env.production)
- API_URL=https://ip_computer
- DEBUG=true
- API_GOOGLE_MAPS=API_KEY

Es necesario crear los 3 archivos para manejar las variables de entorno, sino el proyecto no levanta

### Pasos para levantar el proyecto
1- Instalacion de dependencias
  Ejecutamos: 
  ```
  flutter packages pub run build_runner build
  ```

2- Ver los simuladores activos
  Ejecutamos: 
  ```
  flutter devices
  ```

3- Correr la aplicación en el simulador
  Ejecutamos: 
  ``` 
  flutter run -d id_dispositivo
  ```

Estructura del Proyecto
```
└── 📁lib
    └── 📁assets
    |   └── 📁img
    |
    └── 📁blocSocketIO  // Manejador de Estados Gloabl
    |   └── socketIOBloc.dart
    |   └── socketIOEvent.dart
    |   └── socketIOState.dart
    |
    └── 📁config  // Configuración general del Proyecto
    |   └── 📁constants
    |   |   └── enviroment.dart
    |   |
    |   └── 📁router
    |       └── app_router.dart
    |
    └── 📁src
        └── 📁data
        |   └── 📁api  // Configuración para la conexión a la API
        |   |   └── apiConfig.dart
        |   |   └── apiKeyGoogle.dart
        |   └── 📁dataSource
        |   |   └── 📁local  // Manejo de información Local
        |   |   |   └── sharedPref.dart
        |   |   |
        |   |   └── 📁remote  // Manejo de información remota
        |   |       └── 📁services
        |   |       |   └── authService.dart
        |   |       |   └── carInfoService.dart
        |   |       |   └── driversPositionService.dart
        |   |       |   └── driverTripRequestsService.dart
        |   |       |   └── passengerRequestService.dart
        |   |       |   └── reserveService.dart
        |   |       |   └── usersService.dart
        |   |       └── service_handler.dart
        |   |
        |   └── 📁repository  // Implementación de funciones del Repo
        |       └── authRepositoryImpl.dart
        |       └── carInfoRepositoryImpl.dart
        |       └── driverPositionRepositoryImpl.dart
        |       └── driverTripRequestsRepositoryImpl.dart
        |       └── geolocationRepositoryImpl.dart
        |       └── passengerRequestRepositoryImpl.dart
        |       └── reserveRepositoryImpl.dart
        |       └── socketRepositoryImpl.dart
        |       └── usersRepositoryImpl.dart
        |       
        └── 📁di  // Manejador de Dependencias
        |   └── appModule.dart
        |
        └── 📁domain
            └── 📁models
                └── authResponse.dart
                └── carInfo.dart
                └── driverPosition.dart
                └── driverTripRequest.dart
                └── placemarkData.dart
                └── reserve.dart
                └── reserveDetail.dart
                └── reserveRequest.dart
                └── reservesAll.dart
                └── role.dart
                └── timeAndDistanceValue.dart
                └── tripDetail.dart
                └── tripsAll.dart
                └── user.dart

            └── 📁repository
                └── authRepository.dart
                └── carInfoRepository.dart
                └── driverPositionRepository.dart
                └── driverTripRequestsRepository.dart
                └── geolocationRepository.dart
                └── passengerRequestRepository.dart
                └── reserveRepository.dart
                └── socketRepository.dart
                └── usersRepository.dart

            └── 📁useCases
                └── 📁auth
                    └── authUseCases.dart
                    └── changeRolUseCase.dart
                    └── getUserSessionUseCases.dart
                    └── getUserTokenUseCase.dart
                    └── loginUseCase.dart
                    └── logoutUseCase.dart
                    └── registerUseCases.dart
                    └── saveUserSessionUseCases.dart
                    └── saveUserTokenUseCase.dart
                    └── updateUserSessionUseCase.dart

                └── 📁car-info
                    └── carInfoUseCases.dart
                    └── createCarInfoUseCase.dart
                    └── getCarInfoUseCase.dart
                    └── getCarListUseCase.dart
                    └── updateCarInfoUseCase.dart

                └── 📁driver-trip-request
                    └── createTripRequestUseCase.dart
                    └── driverTripRequestUseCases.dart
                    └── getAllTripsUseCase.dart
                    └── getDriverTripsUseCase.dart
                    └── getTimeAndDistanceUseCase.dart
                    └── getTripDetailUseCase.dart

                └── 📁drivers-position
                    └── createDriverPositionUseCase.dart
                    └── deleteDriverPositionUseCase.dart
                    └── driversPositionUseCases.dart
                    └── getDriverPositionUseCase.dart

                └── 📁geolocation
                    └── createMarkerUseCase.dart
                    └── findPositionUseCase.dart
                    └── geolocationUseCases.dart
                    └── getLocationDataUseCase.dart
                    └── getMarkerUseCase.dart
                    └── getPlacemarkDataUseCase.dart
                    └── getPolylineUseCase.dart
                    └── getPositionStreamUseCase.dart

                └── 📁passenger-request
                    └── getNerbyTripRequestUseCase.dart
                    └── passengerRequestUseCases.dart

                └── 📁reserves
                    └── createReserveUseCase.dart
                    └── getAllReservesUseCase.dart
                    └── getReserveDetailUseCase.dart
                    └── reserveUseCases.dart

                └── 📁socket
                    └── connectSocketUseCase.dart
                    └── disconnectSocketUseCase.dart
                    └── socketUseCases.dart

                └── 📁users
                    └── getUserDetailUseCase.dart
                    └── updateUserUseCase.dart
                    └── userUseCases.dart

            └── 📁utils
                └── listToString.dart
                └── resource.dart
        └── 📁screens
            └── 📁pages
                └── 📁auth
                    └── 📁login
                        └── 📁bloc
                            └── loginBloc.dart
                            └── loginEvent.dart
                            └── loginState.dart
                        └── login.dart
                        └── loginContent.dart
                    └── 📁register
                        └── 📁bloc
                            └── registerBloc.dart
                            └── registerEvent.dart
                            └── registerState.dart
                        └── register.dart
                        └── registerContent.dart
                └── 📁carInfo
                    └── 📁info
                        └── 📁bloc
                            └── carInfoBloc.dart
                            └── carInfoEvent.dart
                            └── carInfoState.dart
                        └── carInfo.dart
                        └── carInfoContent.dart
                    └── 📁list
                        └── 📁bloc
                            └── carListBloc.dart
                            └── carListEvent.dart
                            └── carListState.dart
                        └── carItem.dart
                        └── carList.dart
                        └── carListContent.dart
                    └── 📁register
                        └── 📁bloc
                            └── carRegisterBloc.dart
                            └── carRegisterEvent.dart
                            └── carRegisterState.dart
                        └── carRegister.dart
                        └── carRegisterContent.dart
                    └── 📁update
                        └── 📁bloc
                            └── carUpdateBloc.dart
                            └── carUpdateEvent.dart
                            └── carUpdateState.dart
                        └── carUpdate.dart
                        └── carUpdateContent.dart
                └── 📁driver
                    └── 📁createTrip
                        └── 📁bloc
                            └── createTripBloc.dart
                            └── createTripEvent.dart
                            └── createTripState.dart
                        └── createTrip.dart
                        └── createTripContent.dart
                    └── 📁home
                        └── 📁bloc
                            └── driverHomeBloc.dart
                            └── driverHomeEvent.dart
                            └── driverHomeState.dart
                        └── driverHome.dart
                    └── 📁mapBookingInfo
                        └── 📁bloc
                            └── driverMapBookingInfoBloc.dart
                            └── driverMapBookingInfoEvent.dart
                            └── driverMapBookingInfoState.dart
                        └── driverMapBookingInfo.dart
                        └── driverMapBookingInfoContent.dart
                    └── 📁mapFinder
                        └── 📁bloc
                            └── driverMapFinderBloc.dart
                            └── driverMapFinderEvent.dart
                            └── driverMapFinderState.dart
                        └── driverMapFinder.dart
                    └── 📁mapLocation
                        └── 📁bloc
                            └── driverMapLocationBloc.dart
                            └── driverMapLocationEvent.dart
                            └── driverMapLocationState.dart
                        └── driverMapLocation.dart
                    └── 📁tripDetail
                        └── 📁bloc
                            └── tripDetailBloc.dart
                            └── tripDetailEvent.dart
                            └── tripDetailState.dart
                        └── tripDetail.dart
                        └── tripDetailContent.dart
                        └── tripDetailReservesItem.dart
                    └── 📁trips
                        └── 📁bloc
                            └── tripsBloc.dart
                            └── tripsEvent.dart
                            └── tripsState.dart
                        └── trips.dart
                        └── tripsContent.dart
                        └── tripsItem.dart
                └── 📁errors
                    └── 📁bloc
                        └── error_bloc.dart
                        └── error_event.dart
                        └── error_state.dart
                    └── error_utils.dart
                    └── errorPage.dart
                └── 📁passenger
                    └── 📁home
                        └── 📁bloc
                            └── passengerHomeBloc.dart
                            └── passengerHomeEvent.dart
                            └── passengerHomeState.dart
                        └── passengerHome.dart
                    └── 📁reserveDetail
                        └── 📁bloc
                            └── reserveDetailBloc.dart
                            └── reserveDetailEvent.dart
                            └── reserveDetailState.dart
                        └── reserveDetail.dart
                        └── reserveDetailContent.dart
                    └── 📁tripAvailableDetail
                        └── 📁bloc
                            └── tripAvailableDetailBloc.dart
                            └── tripAvailableDetailEvent.dart
                            └── tripAvailableDetailState.dart
                        └── tripAvailableDetail.dart
                        └── tripAvailableDetailContent.dart
                    └── 📁tripsAvailable
                        └── 📁bloc
                            └── tripsAvailableBloc.dart
                            └── tripsAvailableEvent.dart
                            └── tripsAvailableState.dart
                        └── tripsAvailable.dart
                        └── tripsAvailableContent.dart
                        └── tripsAvailableItem.dart
                └── 📁profile
                    └── 📁info
                        └── 📁bloc
                            └── profileInfoBloc.dart
                            └── profileInfoEvent.dart
                            └── profileInfoState.dart
                        └── profileInfo.dart
                        └── profileInfoContent.dart
                    └── 📁update
                        └── 📁bloc
                            └── profileUpdateBloc.dart
                            └── profileUpdateEvent.dart
                            └── profileUpdateState.dart
                        └── profileUpdate.dart
                        └── profileUpdateContent.dart
                └── 📁roles
                    └── 📁bloc
                        └── rolesEvent.dart
                        └── rolesState.dart
            └── 📁utils
                └── blocFormItem.dart
                └── errors.dart
                └── galleryOrPhoto.dart
                └── globals.dart
            └── 📁widgets
                └── 📁navigation
                    └── 📁bloc
                        └── navigationBloc.dart
                        └── navigationEvent.dart
                        └── navigationState.dart
                    └── Drawer.dart
                    └── Navigation.dart
                └── CustomButton.dart
                └── CustomButtonAction.dart
                └── CustomDialog.dart
                └── CustomDialogTrip.dart
                └── CustomIconBack.dart
                └── CustomTextField.dart
                └── CustomTimePicker.dart
                └── googlePlacesAutoComplete.dart
                └── SearchAdvanced.dart
                └── SearchBar.dart
        └── 📁views
            └── 📁driver
                └── 📁home
                    └── 📁bloc
                        └── driver_home_view_bloc.dart
                        └── driver_home_view_event.dart
                        └── driver_home_view_state.dart
                    └── driver_home_content.dart
                    └── driver_home_view.dart
            └── 📁passenger
                └── 📁home
                    └── 📁bloc
                        └── passenger_home_view_bloc.dart
                        └── passenger_home_view_event.dart
                        └── passenger_home_view_state.dart
                    └── passenger_home_content.dart
                    └── passenger_home_view.dart
                └── 📁reserves
                    └── 📁bloc
                        └── reservesBloc.dart
                        └── reservesEvent.dart
                        └── reservesState.dart
                    └── reserves_content.dart
                    └── reserves_view.dart
                    └── reservesItem.dart
            └── views.dart
        └── .DS_Store
    └── .DS_Store
    └── blocProviders.dart
    └── injection.config.dart
    └── injection.dart
    └── main.dart
```