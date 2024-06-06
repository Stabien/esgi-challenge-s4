import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/usersScreen/bloc/profil_bloc.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfilBloc()..add(ProfilDataLoaded()),
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<ProfilBloc, ProfilState>(
            builder: (context, state) {
              if (state is ProfilLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ProfilDataLoadingError) {
                return Center(
                  child: Text(
                    state.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (state is ProfilDataLoadingSuccess) {
                final profil = state.profil;
                return Column(
                  children: [
                    Text(profil?.firstname ?? ''),
                    // Ajoutez d'autres éléments pour afficher d'autres informations du profil
                  ],
                );
              } else {
                return const Center(
                  child: Text('Unknown state'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
