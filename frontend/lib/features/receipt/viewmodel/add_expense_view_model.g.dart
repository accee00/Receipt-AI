// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_expense_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddExpense)
final addExpenseProvider = AddExpenseProvider._();

final class AddExpenseProvider
    extends $AsyncNotifierProvider<AddExpense, void> {
  AddExpenseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addExpenseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addExpenseHash();

  @$internal
  @override
  AddExpense create() => AddExpense();
}

String _$addExpenseHash() => r'4c3e28cc886513a1a9f5153a92a97874664f6a6c';

abstract class _$AddExpense extends $AsyncNotifier<void> {
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
