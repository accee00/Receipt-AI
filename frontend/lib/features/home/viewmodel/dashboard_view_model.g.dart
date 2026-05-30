// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DashboardViewModel)
final dashboardViewModelProvider = DashboardViewModelFamily._();

final class DashboardViewModelProvider
    extends $AsyncNotifierProvider<DashboardViewModel, DashboardModel> {
  DashboardViewModelProvider._({
    required DashboardViewModelFamily super.from,
    required ({int? month, int? year}) super.argument,
  }) : super(
         retry: null,
         name: r'dashboardViewModelProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dashboardViewModelHash();

  @override
  String toString() {
    return r'dashboardViewModelProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  DashboardViewModel create() => DashboardViewModel();

  @override
  bool operator ==(Object other) {
    return other is DashboardViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dashboardViewModelHash() =>
    r'df0595b3cede2de8587961e0bcb724936d61e9f0';

final class DashboardViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          DashboardViewModel,
          AsyncValue<DashboardModel>,
          DashboardModel,
          FutureOr<DashboardModel>,
          ({int? month, int? year})
        > {
  DashboardViewModelFamily._()
    : super(
        retry: null,
        name: r'dashboardViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  DashboardViewModelProvider call({int? month, int? year}) =>
      DashboardViewModelProvider._(
        argument: (month: month, year: year),
        from: this,
      );

  @override
  String toString() => r'dashboardViewModelProvider';
}

abstract class _$DashboardViewModel extends $AsyncNotifier<DashboardModel> {
  late final _$args = ref.$arg as ({int? month, int? year});
  int? get month => _$args.month;
  int? get year => _$args.year;

  FutureOr<DashboardModel> build({int? month, int? year});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DashboardModel>, DashboardModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DashboardModel>, DashboardModel>,
              AsyncValue<DashboardModel>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(month: _$args.month, year: _$args.year),
    );
  }
}
