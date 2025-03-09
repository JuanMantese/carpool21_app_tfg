import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ImageUser extends StatelessWidget {

  String? urlImg;
  double? width;
  EdgeInsetsGeometry margin;

  ImageUser({
    super.key,
    this.urlImg,
    this.width = 60,
    this.margin = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
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
        //   child: urlImg != null 
        //     ? FadeInImage.assetNetwork(
        //       placeholder: 'carpool_21_app/assets/img/profile-icon.png',  
        //       image: user!.image!,
        //       fit: BoxFit.cover,
        //       fadeInDuration: Duration(seconds: 1),
        //     )
        //     : Image.asset(
        //       'carpool_21_app/assets/img/profile-icon.png',
        //     )
        // ),
      // )
    );
  }
}