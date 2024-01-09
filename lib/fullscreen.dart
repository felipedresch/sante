import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sante/models/picture_model.dart';


class Fullscreen extends StatelessWidget {
  final List<Picture> listaFotosFiltradas;
  final int index;

  const Fullscreen({
    Key? key,
    required this.listaFotosFiltradas,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: PhotoViewGallery.builder(
        itemCount: listaFotosFiltradas.length,
        builder: (context, index) => PhotoViewGalleryPageOptions.customChild(
          //onTapUp: (context, details, controllerValue) => Navigator.pop(context),
          child: Image(
            image: FileImage(File(listaFotosFiltradas[index].path)),
          ), 
          minScale: PhotoViewComputedScale.covered,
          heroAttributes: PhotoViewHeroAttributes(tag: listaFotosFiltradas[index]),
        ),
        pageController: PageController(initialPage: index),
        enableRotation: true,
      ),
    );
  }
}