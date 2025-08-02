import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget{

  final TextEditingController? controller;

  const CustomSearchBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only( left: 25 , right: 40 , bottom: 15 , top: 10),
      child: SearchBar(
          controller: controller,
          hintText: 'Search',
          leading: const Icon(Icons.search),
          trailing: <Widget>[] ,

          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(
              horizontal: 20
            )
          ),
          
      ),
    );
  }

}