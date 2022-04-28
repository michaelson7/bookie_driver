import 'package:url_launcher/url_launcher.dart';

void launchURL({required url}) async {
  if (!await launch("tel://$url")) throw 'Could not launch $url';
}
