// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_view_model.dart';

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

String _$addExpenseHash() => r'9ae78234f563ee280a6a289fb7b648ed9c116c81';

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
