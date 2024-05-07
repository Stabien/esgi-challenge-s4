import 'package:flutter/material.dart';
import 'package:mobile/events/blocs/event_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ScreenEvent extends StatelessWidget {
  const ScreenEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventBloc()..add(EventDataLoaded()),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocBuilder<EventBloc, EventState>(
            
            builder: (context, state) {
              if (state is EventLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is EventDataLoadingError) {
                return Center(
                  child: Text(
                    state.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (state is EventDataLoadingSuccess) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final event = state.events[index];
                    return ListTile(

                      title: Text(event.title),
                      subtitle: Text(event.description),
                    );
                  },
                  itemCount: state.events.length,
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
