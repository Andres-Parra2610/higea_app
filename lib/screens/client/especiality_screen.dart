import 'package:flutter/material.dart';
import 'package:higea_app/styles/app_theme.dart';

class EspecialityScreen extends StatelessWidget {
const EspecialityScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return  Scaffold(
      body: CustomScrollView(
        slivers: [

          const _EspecialistAppBar(),


          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.horizontalPadding),
              child: Text('Doctores de la especialidad', style: Theme.of(context).textTheme.headline6),
            ),
          ),

          const _EspecialistList()
        ],
      ),
    );
  }
}



class _EspecialistAppBar extends StatelessWidget {
  const _EspecialistAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      leading: Container(),
      backgroundColor: const Color(AppTheme.primaryColor),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.all(0),
        title:  Container(
          /* padding: const EdgeInsets.symmetric(vertical: 5, horizontal: AppTheme.horizontalPadding), */
          alignment: Alignment.bottomCenter,
          decoration: AppTheme.BoxGradient(fOpacity: 0.5, sOpacity: 0.2),
          width: double.infinity,
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context), 
                icon: const Icon(Icons.arrow_back, color: Colors.white,)
              ),
              const Text(
                'Otorrinonaringología', 
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
              )
            ],
          ),
        ),
        background: const Image(
          image:  AssetImage('assets/doctor-avatar.jpg'),
          fit: BoxFit.cover,
        )
      ),
    );
  }
}


class _EspecialistList extends StatelessWidget {
  const _EspecialistList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 3,
        (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.horizontalPadding, 
            vertical: 0
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/doctor-avatar.jpg'),
                    radius: 30,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const[
                      Text('Dr. Andrés Parra',style: TextStyle(
                        color: Color(AppTheme.primaryColor),
                        fontWeight: FontWeight.bold
                      )),
                      Text('Pediatra')
                    ],
                  ),
                  trailing: Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Horario'),
                        Text('8:00 am - 12:00 pm')
                      ],
                    ),
                  ),
                ),
              ),
              const Divider()
            ],
          ),
        );
      })
    );
  }
}