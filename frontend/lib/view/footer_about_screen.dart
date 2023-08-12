import 'package:fitness_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class FooterAboutScreen extends StatelessWidget {
  const FooterAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: MyAppBar(
        title: 'About',
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
              ' Nullam ullamcorper nunc sit amet diam semper sagittis.'
              ' Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
              ' In gravida volutpat nisl nec blandit. Quisque a mattis neque.'
              ' Vivamus id dolor a mauris faucibus ornare.'
              ' Nullam tellus lacus, commodo a fermentum quis, dapibus sed leo.'
              ' Donec hendrerit elementum ante a tempor.'
              ' Proin sodales nibh nec tellus ullamcorper tincidunt.'
              ' Duis id pulvinar elit. Sed a felis magna.'
              ' Curabitur porttitor faucibus turpis, id fermentum mauris ultrices vel.'
              ' Curabitur mattis arcu at iaculis ornare.\n\n'
              'Aliquam tempor gravida eros, vehicula dignissim magna ultrices vitae.'
              ' Ut faucibus mauris lacinia elit dictum, id faucibus tortor feugiat.'
              ' Morbi ante dolor, tempus non ultricies vel, blandit at urna.'
              ' Morbi rutrum ipsum metus, eu tempus erat elementum ac.'
              ' In sit amet odio volutpat, bibendum sapien vitae, molestie diam.'
              ' Donec varius eros tortor, at mollis diam fermentum faucibus.'
              ' Pellentesque ut euismod elit, sed tincidunt ligula.'
              ' Donec ex mauris, accumsan non eros aliquam, maximus volutpat velit.'
              ' Curabitur volutpat ullamcorper urna, in elementum tortor gravida et.'
              ' Aliquam consectetur orci vitae odio porttitor egestas.'
              ' Fusce non pellentesque quam. Fusce fringilla felis et commodo suscipit.'
              ' Vestibulum aliquet id quam vitae dapibus.'
              ' Vivamus aliquam ac metus at suscipit.\n\n'
              'Sed a est ut velit ultrices rutrum.'
              ' Phasellus vestibulum, ex ac tempus pharetra, nulla eros euismod arcu, vitae dignissim elit libero eu dui.'
              ' In ut porttitor quam. Nam eu dignissim massa.'
              ' Aenean vel lectus euismod, pharetra felis sit amet, placerat elit.'
              ' Donec ut scelerisque lacus, eu rutrum ex. Integer scelerisque vel tellus eu vulputate.'
              ' Sed nec sodales sapien. Aliquam sit amet vehicula lacus.'
              'Vestibulum cursus neque velit, ut interdum lorem semper fermentum.'
              ' Fusce gravida, dui eu elementum tempor, quam ex imperdiet nisl, quis ullamcorper dui nibh a magna.'
              ' Donec sodales pretium neque eu vehicula. Suspendisse et dapibus nisl. Donec id vulputate magna.'
              ' Etiam ac viverra eros, scelerisque consequat turpis.'
              ' Nulla justo sem, lacinia id molestie eu, rhoncus egestas tortor.',
            ),
          ),
        ),
      ),
    );
  }
}
