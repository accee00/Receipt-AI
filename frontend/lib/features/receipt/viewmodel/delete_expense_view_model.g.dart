// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_expense_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeleteExpense)
final deleteExpenseProvider = DeleteExpenseProvider._();

final class DeleteExpenseProvider
    extends $AsyncNotifierProvider<DeleteExpense, void> {
  DeleteExpenseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteExpenseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteExpenseHash();

  @$internal
  @override
  DeleteExpense create() => DeleteExpense();
}

String _$deleteExpenseHash() => r'e239bad3dfc2273cc773310f291e273ad9439751';

abstract class _$DeleteExpense extends $AsyncNotifier<void> {
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
