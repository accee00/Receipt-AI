// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chatRepo)
final chatRepoProvider = ChatRepoProvider._();

final class ChatRepoProvider
    extends $FunctionalProvider<ChatRepo, ChatRepo, ChatRepo>
    with $Provider<ChatRepo> {
  ChatRepoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRepoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRepoHash();

  @$internal
  @override
  $ProviderElement<ChatRepo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatRepo create(Ref ref) {
    return chatRepo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRepo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRepo>(value),
    );
  }
}

String _$chatRepoHash() => r'f9572e4202633b622b688d01764a254f071b0d63';
