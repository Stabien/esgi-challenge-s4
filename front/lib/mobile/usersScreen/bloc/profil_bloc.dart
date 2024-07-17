import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:mobile/mobile/models/profil.dart';
import 'package:mobile/mobile/services/user_services.dart';
import 'package:mobile/mobile/core/api_exception.dart';
import 'package:mobile/mobile/utils/secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profil_event.dart';
part 'profil_state.dart';

class ProfilBloc extends Bloc<ProfilEvent, ProfilState> {
  String _userId = "";
  String _role = "";

  ProfilBloc() : super(ProfilInitial()) {
    on<ProfilEvent>((event, emit) async {
      emit(ProfilLoading());
      try {
        await initUser();
        Profil? profil;
        if (_role == "organizer") {
          profil = await UserServices().profilOrga(_userId);
        } else {
          profil = await UserServices().profilCustomer(_userId);
        }
        emit(ProfilDataLoadingSuccess(profil: profil));
      } on ApiException catch (error) {
        emit(ProfilDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(ProfilDataLoadingError(errorMessage: "Unhandled errorr"));
      }
    });
  }
  Future<void> initUser() async {
    await SecureStorage.getStorageItem('userId').then((value) {
      _userId = value!;
    });
    await SecureStorage.getStorageItem('userRole').then((value) {
      _role = value!;
    });
  }
}
