import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/screens/screens.dart';
import 'package:higea_app/services/services.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:higea_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class GuestsScreen extends StatelessWidget {
const GuestsScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){

    final guestProvider = Provider.of<GuestProvider>(context);
    final User user = User.fromRawJson(UserPreferences.user);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invitados'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=> const GuestFormScreen()));
              guestProvider.guestData = Guest();
            }, 
            icon: const Icon(Icons.add)
          )
        ],
      ),


      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
          child: FutureBuilder(
            future: guestProvider.showGuestByPaTient(user.cedula),
            builder:(context, AsyncSnapshot<List<Guest>> snapshot){

              if(!snapshot.hasData) return const CircularProgressIndicator();

              final List<Guest> guests = snapshot.data!;
              
              if(guests.isEmpty) return const _EmptyGuest();

              return _GuestList(guests: guests);
            },
          )
        ),
      ),

    );
  }
}

class _GuestList extends StatelessWidget {
  const _GuestList({
    required this.guests,
  });

  final List<Guest> guests;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: guests.length,
      itemBuilder:(context, index) {
        final Guest guest = guests[index];
        final int duration = index == 0 ? 100 : (((index + 1)/11) * 1000).round();

        return Column(
          children: [
            Animate(
              effects: [FadeEffect(delay: Duration(milliseconds: duration))],
              child: ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> const GuestFormScreen(isEditable: true)));
                  Provider.of<GuestProvider>(context, listen: false).guestData = guest;
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                trailing: const Icon(Icons.keyboard_arrow_right_outlined),
            
                leading: IconButton(
                  onPressed: () async{
                    final Response? res = await showDialog(context: context, builder: (_) => DeleteGuestWidget(guest: guest));
            
                    if(res == null) return;
            
                    SnackBarWidget.showSnackBar(res.msg, res.ok);
                  }, 
                  icon: const Icon(Icons.delete), 
                  iconSize: 20,
                  color:  const Color(AppTheme.secondaryColor).withOpacity(0.6),
                ),
            
                title: Text(
                  '${guest.nombreInvitado} ${guest.apellidoInvitado}',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.normal)
                ),
              ),
            ),
            const Divider(height: 0, indent: 0,thickness: 1,)
          ],
        );
      },
    );
  }
}

class _EmptyGuest extends StatelessWidget {
  const _EmptyGuest();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Animate(
          effects: const [FadeEffect(), ScaleEffect()],
          child: SvgPicture.asset(
            'assets/family.svg',
            width: MediaQuery.of(context).size.width * 0.65,
          )
        ),

        const SizedBox(height: 20),


        const Text(
          'Añade familiares menores de edad y/o familiares que necesiten ser representados dentro de la fundación. ¡No dejes que nadie se quede sin su cita médica!',
        ),

        const SizedBox(height: 20),


        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=> const GuestFormScreen()));
            }, 
            child: const Text('Añadir invitados', style: TextStyle(fontWeight: FontWeight.bold),)
          ),
        )
      ],
    );
  }
}