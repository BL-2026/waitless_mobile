import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waitless_mobile/src/data/repositories_impl/mock_request_repository_impl.dart';
import 'package:waitless_mobile/src/domain/usecases/request_usecases.dart';
import 'package:waitless_mobile/src/presentation/cubits/auth/logout/logout_cubit.dart';
import 'package:waitless_mobile/src/presentation/cubits/requests/requests_cubit.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/drawers/main_drawer.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/empty_queue_view.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/request_card.dart';
import 'package:waitless_mobile/src/services/injection_container.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';

class LiveQueuePage extends StatelessWidget {
  const LiveQueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: once your injection_container.dart is set up, get these
    // from it instead of constructing them here — this inline wiring
    // is just so the page runs standalone for now.
    final repository = MockRequestRepositoryImpl();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => RequestsCubit(
            watchActiveRequests: WatchActiveRequestsUseCase(repository),
            acknowledgeRequest: AcknowledgeRequestUseCase(repository),
            resolveRequest: ResolveRequestUseCase(repository),
          ),
        ),
        BlocProvider(create: (_) => sl<LogoutCubit>()),
      ],
      child: const _LiveQueueView(),
    );
  }
}

class _LiveQueueView extends StatelessWidget {
  const _LiveQueueView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.charcoal,
      drawer: const MainDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: const Icon(Icons.menu, color: AppColors.paper),
                      tooltip: 'Open menu',
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  const Text(
                    'cafe meridian',
                    style: TextStyle(color: Color(0xFF6B6858), fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              BlocBuilder<RequestsCubit, RequestsState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Active requests',
                        style: TextStyle(
                          color: AppColors.paper,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                        decoration: BoxDecoration(
                          color: state.requests.isEmpty
                              ? const Color(0xFF2A2B27)
                              : AppColors.rust,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${state.requests.length}',
                          style: TextStyle(
                            color: state.requests.isEmpty
                                ? const Color(0xFF6B6858)
                                : Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 14),

              Expanded(
                child: BlocBuilder<RequestsCubit, RequestsState>(
                  builder: (context, state) {
                    if (state.loading) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.teal),
                      );
                    }

                    if (state.requests.isEmpty) {
                      return const EmptyQueueView();
                    }

                    final cubit = context.read<RequestsCubit>();

                    return ListView.builder(
                      itemCount: state.requests.length,
                      itemBuilder: (context, index) {
                        final request = state.requests[index];
                        return RequestCard(
                          request: request,
                          onAcknowledge: () => cubit.acknowledge(request.id),
                          onResolve: () => cubit.resolve(request.id),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
