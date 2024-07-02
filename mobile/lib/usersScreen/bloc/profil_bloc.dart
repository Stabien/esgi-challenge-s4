import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mobile/models/profil.dart';
import 'package:mobile/services/userServices.dart';
import 'package:mobile/core/api_exception.dart';
import 'package:mobile/utils/secureStorage.dart';
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
        print("le profil est dans le bloc");
        print(profil);
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
      print("le user id est dans le profil bloc");
      print(value);
      _userId = value!;
    });
    await SecureStorage.getStorageItem('userRole').then((value) {
      print("le user role est dans le profil bloc");
      print(value);
      _role = value!;
    });
  }
}
