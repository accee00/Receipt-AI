// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExpenseViewModel)
final expenseViewModelProvider = ExpenseViewModelProvider._();

final class ExpenseViewModelProvider
    extends $AsyncNotifierProvider<ExpenseViewModel, List<ExpenseModel>> {
  ExpenseViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseViewModelHash();

  @$internal
  @override
  ExpenseViewModel create() => ExpenseViewModel();
}

String _$expenseViewModelHash() => r'11c155eef862496872d3e14cac8dbfa789b0fc77';

abstract class _$ExpenseViewModel extends $AsyncNotifier<List<ExpenseModel>> {
  FutureOr<List<ExpenseModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ExpenseModel>>, List<ExpenseModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ExpenseModel>>, List<ExpenseModel>>,
              AsyncValue<List<ExpenseModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
