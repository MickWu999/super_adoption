import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_adoption/core/router/app_router.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({
    super.key,
    this.initialKind,
    this.initialAge,
  });

  final String? initialKind;
  final String? initialAge;

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(title: const Text('毛孩列表')),
      body: ListView.builder(
        key: const PageStorageKey('animal-list-scroll-position'),
        itemCount: 50,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.pets_rounded),
            title: Text('毛孩 $index'),
            subtitle: Text(
              'kind: ${widget.initialKind ?? '全部'} / age: ${widget.initialAge ?? '全部'}',
            ),
            onTap: () => context.push(AppRoutes.animalDetail('$index')),
          );
        },
      ),
    );
  }
}
