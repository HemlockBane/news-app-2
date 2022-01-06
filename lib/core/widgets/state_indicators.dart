import 'dart:io';

import 'package:flutter/material.dart';

class PageLoadingIndicator extends StatelessWidget {
  const PageLoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.black,
      ),
    );
  }
}

class EmptyListPageBanner extends StatelessWidget {
  const EmptyListPageBanner({
    Key? key,
    required this.onRetry,
  }) : super(key: key);

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => PageBanner(
        title: 'Too much filtering',
        message: 'We couldn\'t find any results matching your applied filters.',
        onRetry: onRetry,
      );
}

class ErrorPageBanner extends StatelessWidget {
  const ErrorPageBanner({Key? key, required this.onRetry, required this.error})
      : super(key: key);

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final banner = error is SocketException
        ? NoConnectionPageBanner(onRetry: onRetry)
        : GenericPageBanner(onRetry: onRetry);

    return banner;
  }
}

class GenericPageBanner extends StatelessWidget {
  const GenericPageBanner({
    Key? key,
    required this.onRetry,
  }) : super(key: key);

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => PageBanner(
        title: 'Something went wrong',
        message: 'The application has encountered an unknown error',
        onRetry: onRetry,
      );
}

class NoConnectionPageBanner extends StatelessWidget {
  const NoConnectionPageBanner({
    Key? key,
    required this.onRetry,
  }) : super(key: key);

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => PageBanner(
        title: 'No connection',
        message: 'Please check internet connection and try again.',
        onRetry: onRetry,
      );
}

class PageBanner extends StatelessWidget {
  const PageBanner(
      {Key? key, required this.onRetry, this.title, required this.message})
      : super(key: key);

  final String? title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: title != null,
          child: Column(
            children: [
              Text(title!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
              const SizedBox(height: 8),
            ],
          ),
        ),
        Text(message, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
        const SizedBox(height: 8),
        TextButton(
          child: const Text("Retry", style: TextStyle(color: Colors.black)),
          onPressed: () {
            onRetry.call();
          },
        )
      ],
    );
  }
}
