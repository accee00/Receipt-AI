// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatViewModel)
final chatViewModelProvider = ChatViewModelProvider._();

final class ChatViewModelProvider
    extends $NotifierProvider<ChatViewModel, ChatState> {
  ChatViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatViewModelHash();

  @$internal
  @override
  ChatViewModel create() => ChatViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatState>(value),
    );
  }
}

String _$chatViewModelHash() => r'8f3341cdbd8ad9138cc726fc8b5b01993d09044e';

abstract class _$ChatViewModel extends $Notifier<ChatState> {
  ChatState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ChatState, ChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatState, ChatState>,
              ChatState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
