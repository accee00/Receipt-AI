// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BudgetViewModel)
final budgetViewModelProvider = BudgetViewModelProvider._();

final class BudgetViewModelProvider
    extends $AsyncNotifierProvider<BudgetViewModel, void> {
  BudgetViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetViewModelHash();

  @$internal
  @override
  BudgetViewModel create() => BudgetViewModel();
}

String _$budgetViewModelHash() => r'465816d0d93d4034ad306220555fedc024fe2ae3';

abstract class _$BudgetViewModel extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
