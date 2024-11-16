import 'package:carpool_21_app/src/domain/models/user.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomButtonAction.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomIconBack.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class ProfileInfoContent extends StatelessWidget {

  User? user;

  ProfileInfoContent(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    print('User - $user');
    return Stack(
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
              _cardEmergencyData(context),

              const Spacer(),
              CustomButtonAction(text: 'EDITAR PERFIL', icon: Icons.edit, 
                onTapFunction: () {
                  // Navigator.pushNamed(context, '/profile/update', arguments: user);
                  context.push('/profile/update', extra: user);
                }
              ),
              CustomButtonAction(text: 'CAMBIAR CONTRASEÑA', icon: Icons.lock_rounded, 
                onTapFunction: () {
                  // Navigator.pushNamed(context, '/profile/update', arguments: user);
                }
              ),
              CustomButtonAction(text: 'ELIMINAR CUENTA', icon: Icons.delete_outline_rounded, 
                onTapFunction: () {},
                colorTop: const Color(0xFF6D0000),
                colorBottom: const Color(0xFFD20000),
              )
            ],
          ),
        ),
      ],
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
        'PERFIL DE USUARIO',
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
            Container(
              width: 115,
              margin: const EdgeInsets.only(top: 25, bottom: 15),
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipOval(
                  child: 
                    (user?.name == 'Juan' && user?.lastName == 'Mantese') ?
                      FadeInImage.assetNetwork(
                        placeholder: 'lib/assets/img/profile-icon.png', 
                        image: 'https://lh3.googleusercontent.com/fife/ALs6j_GUNUZAmJJ2p-J9avylOcBQ9VLhtxmDLQur4B-x5qi49xRFetc8yO2eDnAoLktheYMrMYC0tDECkO37Ljrk2UfNG8d5FhjicsdWXEptuuHgv6SGLIj0SIpzyMFila5hzDXJGmOAMQBL_RsV2XInu-TYYPnnvvTIWhIaRgL4A6RCEOgnsZgy2cX9tW_x0ebkL3G_C7F9192Up-apqb7Rq_AB15-cWC1KzrCtIu8S3MFp3UUMJ_ZoH0ddRmPJuRJ9VAR8jkfkLM59bCvJfdu1EymY-HJC8VnlXFo0DrDZafSDedqO5u7NVLxcSwtxdJRcq92z-qpnMK9Cx0Jig2w224YZUwi3p3UJMlr-3JWwdYansYuPC42RA4F8CJRivN6OdDRCwXgFj3sjMXoW3dhKsrMOj7RlLMbN3NqvM4qbN-WPaG5gK_LXBDfwd2J7uTzk54J9C4RMHw-d-wA6zsm_OpfsgT2ELIgM7djGhTKLYTd2HB5BSD2HjJoysHPekGe7xJoIHYHWwppxNoGDuP4K3IZQgRBAwjpQeiUteeKLEUhY2RVrzHcL0LmBfU-1dFIe_2WfgkZYRQyXfpcsiNnrinV9hYoliE0W3qt1eLBxOv3niTc9kpfa5pXbC2VxsqGUIu19BtcOSych1VzZy1K3HsjOm0ji5ZqBB2n0vHPkqF1RIuneGsLVtN7xAm5Q_1c0x5w28xWgvzwkVqB8qvCUXldUKd7HAj41QMlLYFT0OW7spmhQ6I1lRMrXMFxTf9lQRBETAbrG7wepfpEwe08qK7NyeXsT0_2rs5E8HYYV6tUqLkRSAs5nQ78FME2W6yECv2fPfMgHeanJld_U9U55_ZOF7KCRcqin5St4hJRFP5ieH7HAyyJcWJc_Mbol0bJXdkTXvHiCc9TAtgXbJ7WhQadjZRzAYkdhPF231xSRFnrPYlfbDODjMykZt5M7ZutpPT5GeoHZ624oznwRnBzLhUB2Lvpt7WSUm4sxULLJu92lrv0cqD9qZyaY8D5w1DplR4gV7VgbbAXfWh48doZsAIiVpNpYtAvvFFuRGZ8xT3A8jdkGUq6OkrbM0HDRPQ5F0h1vGmbhchdCkYyBjpBrSFxan3TIzovOU7rtPI2ir5flYyfmYqUoOptd4jcj4EYdyYafRqo5MFerVOYxsEJzA5jt5Iz100Fequ1FBbX5OWnrxlcKkxr7dEHED9-asxqNlW0T8Waw6Gjy0VidwPqC85dUszkdYvKVI887ixvqRhg3TthD7tHzD-Y1Rhw63Alc9TavlBUGsInkjDTCOwLYS1Us-iFbd9SF0YGunVaYQUPWen0_rJw5vwzzaThNmKwyD-gzsf2IEZ9G0h_s4fRBlX9usiaUGcQ9Fm8GNEYNC1BCCQYSwaDBiZyecePFnRaAHO0XypiGfMnlqip6aBMca-HO6NWsSuNfrfxuU_7RCp4SN7QXz7cEUUL1vwoEYeEXOazSvhMfiLOokm1IR2ycluXYuglj9a_7V-ceEnqbTyElbq1HkBxaym72XCNE-ouiyzPdMGcjmv3ZRjXq_FyaNeqsARygVklKv1j8DdeivkKjTrQ1hXu_ImHeW6aZn4-W10Whlw88X7x9TQP6=w3440-h1780',
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(seconds: 1),
                      )
                      :
                      Image.asset(
                        'lib/assets/img/profile-icon.png',
                        height: 100,
                      ), 
                  ),
                ),
                // child: ClipOval(   DESCOMENTAR - Cuando tengamos el back
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
              // ),
            ),
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
              user?.phone.toString() ?? '3510000000',
              style: TextStyle(
                color: Colors.grey[700]
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardEmergencyData(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 35, right: 35, top: 10),
      width: MediaQuery.of(context).size.width,
      child: IntrinsicHeight(
        child: Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          color: Colors.white,
          surfaceTintColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.emergency_rounded,
                      color: Colors.red,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Contacto de Emergencia',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Nombre: ${user?.contactName}' ?? 'Contacto de Emergencia',
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Apellido: ${user?.contactLastName}' ?? 'Contacto de Emergencia',
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Teléfono: ${user?.contactPhone.toString()}' ?? 'Teléfono Contacto Emergencia',
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}