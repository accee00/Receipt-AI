// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(expenseRepo)
final expenseRepoProvider = ExpenseRepoProvider._();

final class ExpenseRepoProvider
    extends $FunctionalProvider<ExpenseRepo, ExpenseRepo, ExpenseRepo>
    with $Provider<ExpenseRepo> {
  ExpenseRepoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseRepoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseRepoHash();

  @$internal
  @override
  $ProviderElement<ExpenseRepo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ExpenseRepo create(Ref ref) {
    return expenseRepo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpenseRepo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpenseRepo>(value),
    );
  }
}

String _$expenseRepoHash() => r'9dbcd9508cb8b7716acdc4e9c24bf075010bb692';
