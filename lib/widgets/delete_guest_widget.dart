import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/guest_provider.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:provider/provider.dart';

class DeleteGuestWidget extends StatelessWidget {
const DeleteGuestWidget({ Key? key, required this.guest }) : super(key: key);


  final Guest guest;

  @override
  Widget build(BuildContext context){

    final guestProvider = Provider.of<GuestProvider>(context, listen: false);

    return AlertDialog(
      scrollable: false,
      title: Text('¿Desea de eliminar a ${guest.nombreInvitado}?'),
      insetPadding: const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Color(AppTheme.secondaryColor), fontSize: 16),),
        ),

        TextButton(
          onPressed: () async{
            final navigator = Navigator.of(context);
            final Response res = await guestProvider.deleteGuest(guest.cedula!);
            navigator.pop(res);
          }, 
          child: const Text('Aceptar', style: TextStyle(fontSize: 16),),
        )
      ],

      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Text('Si el invitado posee una cita pendiente no podrá ser eliminado hasta cumplir con la cita. Si desea eliminarlo ahora debe realizar la cancelación de la cita médica'),
      ),
    );
  }
}