import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile/events/blocs/event_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/services/formatDate.dart';


class ScreenEvent extends StatelessWidget {
  const ScreenEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventBloc()..add(EventDataLoaded()),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
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
                          onTap: () => Navigator.of(context).pushNamed(
                          '/event/detail',
                           arguments: event.id,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                          leading: Image.network(
                            event.image,
                            width: 100,
                            height: 100,
                          ),
                          title: Text(
                            event.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Row(
                          children: [
                            Text(
                              transformerDate(event.date),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded( // Utilisation du widget Expanded pour le Text du lieu
                              child: Text(
                                event.place,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),  
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
