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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Icon(Icons.account_circle_rounded, size: 200, color: Colors.grey),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [
                        Text(
                          profil?.firstname ?? '',
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          profil?.lastname ?? '',
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                    
                    Text(
                      profil?.email ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
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
