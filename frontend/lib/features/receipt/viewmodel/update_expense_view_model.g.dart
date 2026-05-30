// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_expense_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UpdateExpense)
final updateExpenseProvider = UpdateExpenseProvider._();

final class UpdateExpenseProvider
    extends $AsyncNotifierProvider<UpdateExpense, ExpenseModel?> {
  UpdateExpenseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateExpenseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateExpenseHash();

  @$internal
  @override
  UpdateExpense create() => UpdateExpense();
}

String _$updateExpenseHash() => r'99a55e35577360131ba6fb4e00052f22ade069f4';

abstract class _$UpdateExpense extends $AsyncNotifier<ExpenseModel?> {
  FutureOr<ExpenseModel?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ExpenseModel?>, ExpenseModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ExpenseModel?>, ExpenseModel?>,
              AsyncValue<ExpenseModel?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
