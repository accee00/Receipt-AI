// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authRepo)
final authRepoProvider = AuthRepoProvider._();

final class AuthRepoProvider
    extends $FunctionalProvider<AuthRepo, AuthRepo, AuthRepo>
    with $Provider<AuthRepo> {
  AuthRepoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepoHash();

  @$internal
  @override
  $ProviderElement<AuthRepo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepo create(Ref ref) {
    return authRepo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepo>(value),
    );
  }
}

String _$authRepoHash() => r'516e6f1e3e6473fdfdd8e8866a7ef14aa4387d39';
