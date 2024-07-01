part of 'profil_bloc.dart';

@immutable
sealed class ProfilState {}

final class ProfilInitial extends ProfilState {}

final class ProfilLoading extends ProfilState {}

final class ProfilDataLoadingSuccess extends ProfilState {
  final Profil? profil;

 ProfilDataLoadingSuccess({required this.profil});
}

final class ProfilDataLoadingError extends ProfilState {
  final String errorMessage;

  ProfilDataLoadingError({required this.errorMessage});
}

