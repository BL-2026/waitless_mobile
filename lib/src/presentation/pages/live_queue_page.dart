import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waitless_mobile/src/config/app_localizations.dart';
import 'package:waitless_mobile/src/data/repositories_impl/mock_request_repository_impl.dart';
import 'package:waitless_mobile/src/domain/entities/request_status.dart';
import 'package:waitless_mobile/src/domain/usecases/request_usecases.dart';
import 'package:waitless_mobile/src/presentation/cubits/auth/logout/logout_cubit.dart';
import 'package:waitless_mobile/src/presentation/cubits/requests/requests_cubit.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/drawers/main_drawer.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/empty_queue_view.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/request_card.dart';
import 'package:waitless_mobile/src/services/injection_container.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';
import 'package:waitless_mobile/src/utils/theme/app_theme.dart';

class LiveQueuePage extends StatelessWidget {
  const LiveQueuePage({super.key});

  @override
  Widget build(BuildContext context) {
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

class _LiveQueueView extends StatefulWidget {
  const _LiveQueueView();

  @override
  State<_LiveQueueView> createState() => _LiveQueueViewState();
}

class _LiveQueueViewState extends State<_LiveQueueView> {
  String? _zone;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.canvas,
      drawer: const MainDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: const Icon(Icons.menu_rounded),
                      tooltip: l10n.openMenu,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.venueName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          l10n.floorLive,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.sage,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<RequestsCubit, RequestsState>(
              builder: (context, state) {
                final waiting = state.requests
                    .where((r) => r.status == RequestStatus.open)
                    .length;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          l10n.activeRequests,
                          style: AppTheme.display(30),
                        ),
                      ),
                      Text(
                        l10n.waitingCount(waiting),
                        style: const TextStyle(
                          color: AppColors.clay,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            BlocBuilder<RequestsCubit, RequestsState>(
              builder: (context, state) {
                final zones = state.requests.map((r) => r.zone).toSet().toList();
                return SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _ZoneChip(
                        label: l10n.allZones,
                        selected: _zone == null,
                        onTap: () => setState(() => _zone = null),
                      ),
                      ...zones.map(
                        (zone) => _ZoneChip(
                          label: l10n.zoneName(zone),
                          selected: _zone == zone,
                          onTap: () => setState(() => _zone = zone),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<RequestsCubit, RequestsState>(
                builder: (context, state) {
                  if (state.loading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.espresso),
                    );
                  }

                  final requests = _zone == null
                      ? state.requests
                      : state.requests.where((r) => r.zone == _zone).toList();

                  if (requests.isEmpty) {
                    return const EmptyQueueView();
                  }

                  final cubit = context.read<RequestsCubit>();
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request = requests[index];
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
    );
  }
}

class _ZoneChip extends StatelessWidget {
  const _ZoneChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        selectedColor: AppColors.espresso,
        backgroundColor: AppColors.surface,
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppColors.espresso,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        side: BorderSide(color: selected ? AppColors.espresso : AppColors.line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
