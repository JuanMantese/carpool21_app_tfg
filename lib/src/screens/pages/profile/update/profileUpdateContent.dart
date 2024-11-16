import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/screens/pages/profile/update/bloc/profileUpdateBloc.dart';
import 'package:carpool_21_app/src/screens/pages/profile/update/bloc/profileUpdateEvent.dart';
import 'package:carpool_21_app/src/screens/pages/profile/update/bloc/profileUpdateState.dart';
import 'package:carpool_21_app/src/screens/utils/blocFormItem.dart';
import 'package:carpool_21_app/src/screens/utils/galleryOrPhoto.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomButton.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomIconBack.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileUpdateContent extends StatelessWidget {

  User? user;
  ProfileUpdateState state;

  ProfileUpdateContent(this.user, this.state, {super.key});

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
                  _headerProfile(context),
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
                        _cardUserInfo(context),
                        _formUpdateProfile(context),

                        const Spacer(),
                        CustomButton(
                          onPressed: () {
                            // if (state.formKey!.currentState!.validate()) {                      
                            //   context.read<CarRegisterBloc>().add(FormSubmit());
                            // } else {
                            //   print('El formulario no es valido');
                            // }
                          },
                          margin: const EdgeInsets.only(left: 60, right: 60, top: 15),
                          text: 'Actualizar Información',
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

  Widget _headerProfile(BuildContext context) {
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
        'EDICIÓN DE PERFIL',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 19
        ),
      ),
    );
  }

  Widget _cardUserInfo(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 35, right: 35, top: 150),
      width: MediaQuery.of(context).size.width,
      height: 250,
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: Column(
          children: [
            _imageUser(context),
            Text(
              '${user?.name} ${user?.lastName}' ?? 'Nombre de Usuario',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
            Text(
              user?.email ?? 'correo@correo.com',
              style: TextStyle(
                color: Colors.grey[700]
              ),
            ),
            Text(
              user?.phone?.toString() ?? '3511111111',
              style: TextStyle(
                color: Colors.grey[700]
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formUpdateProfile(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 35, 
        right: 35, 
        top: 20,
      ),
      width: MediaQuery.of(context).size.width,
      child: IntrinsicHeight(
        child: Column(
          children: [
            ...[
              CustomTextField(
                onChanged: (text) {
                  context.read<ProfileUpdateBloc>().add(NameChanged(nameInput: BlocFormItem(value: text)));
                },
                validator: (value) {
                  return state.name.error;
                },
                text: 'Nombre', 
                initialValue: user?.name,
                inputType: TextInputType.text
              ),
              CustomTextField(
                onChanged: (text) {
                  context.read<ProfileUpdateBloc>().add(LastNameChanged(lastNameInput: BlocFormItem(value: text)));
                },
                validator: (value) {
                  return state.lastName.error;
                },
                text: 'Apellido', 
                initialValue: user?.lastName,
                inputType: TextInputType.text
              ),
              CustomTextField(
                onChanged: (text) {
                  context.read<ProfileUpdateBloc>().add(PhoneChanged(phoneInput: BlocFormItem(value: text)));
                },
                validator: (value) {
                  return state.phone.error;
                },
                text: 'Teléfono', 
                initialValue: user?.phone?.toString(),
                inputType: TextInputType.number
              ),
              CustomTextField(
                onChanged: (text) {
                  context.read<ProfileUpdateBloc>().add(AddressChanged(addressInput: BlocFormItem(value: text)));
                },
                validator: (value) {
                  return state.address.error;
                },
                text: 'Domicilio', 
                initialValue: user?.address,
                inputType: TextInputType.text
              ),
            ].expand((widget) => [widget, const SizedBox(height: 10,)]),
          ],
        ),
      ),
    );
  }

  Widget _actionProfile(BuildContext context, String option, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (state.formKey!.currentState != null) {
          if (state.formKey!.currentState!.validate()) {
            context.read<ProfileUpdateBloc>().add(FormSubmit());
          }
        } else {
          context.read<ProfileUpdateBloc>().add(FormSubmit());
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
        child: ListTile(
          title: Text(
            option,
            style: const TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 64, 52), // Top color
                  Color(0xFF00A48B), // Bottom color
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.all(Radius.circular(50))
            ),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageUser(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GalleryOrPhotoDialog(
          context, 
          () => { context.read<ProfileUpdateBloc>().add(PickImage()) }, 
          () => { context.read<ProfileUpdateBloc>().add(TakePhoto()) }
        );
      },
      child: Container(
        width: 115,
        margin: EdgeInsets.only(top: 30, bottom: 15),
        child: AspectRatio(
          aspectRatio: 1,
          child: ClipOval(  // ELIMINAR cuando tengamos el back
            child: 
              FadeInImage.assetNetwork(
                placeholder: 'lib/assets/img/profile-icon.png', 
                image: 'https://lh3.googleusercontent.com/fife/ALs6j_GUNUZAmJJ2p-J9avylOcBQ9VLhtxmDLQur4B-x5qi49xRFetc8yO2eDnAoLktheYMrMYC0tDECkO37Ljrk2UfNG8d5FhjicsdWXEptuuHgv6SGLIj0SIpzyMFila5hzDXJGmOAMQBL_RsV2XInu-TYYPnnvvTIWhIaRgL4A6RCEOgnsZgy2cX9tW_x0ebkL3G_C7F9192Up-apqb7Rq_AB15-cWC1KzrCtIu8S3MFp3UUMJ_ZoH0ddRmPJuRJ9VAR8jkfkLM59bCvJfdu1EymY-HJC8VnlXFo0DrDZafSDedqO5u7NVLxcSwtxdJRcq92z-qpnMK9Cx0Jig2w224YZUwi3p3UJMlr-3JWwdYansYuPC42RA4F8CJRivN6OdDRCwXgFj3sjMXoW3dhKsrMOj7RlLMbN3NqvM4qbN-WPaG5gK_LXBDfwd2J7uTzk54J9C4RMHw-d-wA6zsm_OpfsgT2ELIgM7djGhTKLYTd2HB5BSD2HjJoysHPekGe7xJoIHYHWwppxNoGDuP4K3IZQgRBAwjpQeiUteeKLEUhY2RVrzHcL0LmBfU-1dFIe_2WfgkZYRQyXfpcsiNnrinV9hYoliE0W3qt1eLBxOv3niTc9kpfa5pXbC2VxsqGUIu19BtcOSych1VzZy1K3HsjOm0ji5ZqBB2n0vHPkqF1RIuneGsLVtN7xAm5Q_1c0x5w28xWgvzwkVqB8qvCUXldUKd7HAj41QMlLYFT0OW7spmhQ6I1lRMrXMFxTf9lQRBETAbrG7wepfpEwe08qK7NyeXsT0_2rs5E8HYYV6tUqLkRSAs5nQ78FME2W6yECv2fPfMgHeanJld_U9U55_ZOF7KCRcqin5St4hJRFP5ieH7HAyyJcWJc_Mbol0bJXdkTXvHiCc9TAtgXbJ7WhQadjZRzAYkdhPF231xSRFnrPYlfbDODjMykZt5M7ZutpPT5GeoHZ624oznwRnBzLhUB2Lvpt7WSUm4sxULLJu92lrv0cqD9qZyaY8D5w1DplR4gV7VgbbAXfWh48doZsAIiVpNpYtAvvFFuRGZ8xT3A8jdkGUq6OkrbM0HDRPQ5F0h1vGmbhchdCkYyBjpBrSFxan3TIzovOU7rtPI2ir5flYyfmYqUoOptd4jcj4EYdyYafRqo5MFerVOYxsEJzA5jt5Iz100Fequ1FBbX5OWnrxlcKkxr7dEHED9-asxqNlW0T8Waw6Gjy0VidwPqC85dUszkdYvKVI887ixvqRhg3TthD7tHzD-Y1Rhw63Alc9TavlBUGsInkjDTCOwLYS1Us-iFbd9SF0YGunVaYQUPWen0_rJw5vwzzaThNmKwyD-gzsf2IEZ9G0h_s4fRBlX9usiaUGcQ9Fm8GNEYNC1BCCQYSwaDBiZyecePFnRaAHO0XypiGfMnlqip6aBMca-HO6NWsSuNfrfxuU_7RCp4SN7QXz7cEUUL1vwoEYeEXOazSvhMfiLOokm1IR2ycluXYuglj9a_7V-ceEnqbTyElbq1HkBxaym72XCNE-ouiyzPdMGcjmv3ZRjXq_FyaNeqsARygVklKv1j8DdeivkKjTrQ1hXu_ImHeW6aZn4-W10Whlw88X7x9TQP6=w3440-h1780',
                fit: BoxFit.cover,
                fadeInDuration: const Duration(seconds: 1),
              )
            ),
          ),
          // child: ClipOval(   DESCOMENTAR cuando tengamos el back
          //   child: user != null 
          //   ? user!.image != null 
          //     ? FadeInImage.assetNetwork(
          //       placeholder: 'carpool_21_app/assets/img/profile-icon.png',  
          //       image: user!.image!,
          //       fit: BoxFit.cover,
          //       fadeInDuration: Duration(seconds: 1),
          //     )
          //     : Image.asset(
          //       'carpool_21_app/assets/img/profile-icon.png',
          //     )
          //   : Image.asset(
          //     'carpool_21_app/assets/img/profile-icon.png',
          //   ),
          // ),
        // )
      ),
    );
  }
}