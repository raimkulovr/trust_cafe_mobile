import 'package:html/dom.dart';

extension ElementIsImage on Element{
  bool get isImage => localName?.startsWith('img') ?? false;
}

Document wrapNeighboringImages(Document document) {
  document.body?.querySelectorAll('*').forEach((pElement) {
    List<Node> newChildren = [];
    List<Node> imageGroup = [];

    for (var node in List<Node>.from(pElement.nodes)) {
      if (node is Element) {
        if (node.isImage) {
          imageGroup.add(node);
          continue;
        } else if (node.nodes.any((child) => child is Element && child.isImage)) {
          final images = node.nodes.where((child) => child is Element && child.isImage);
          if(images.length == node.nodes.length){
            imageGroup.addAll(images);
            continue;
          }
        }
      }

      // Finalize image group if needed and add other nodes
      if (imageGroup.isNotEmpty) {
        if (imageGroup.length > 1) {
          newChildren.add(createWrapper(imageGroup));
        } else {
          newChildren.add(imageGroup.first);
        }
        imageGroup = [];
      }
      newChildren.add(node);
    }

    // Finalize the last group if any images are left
    if (imageGroup.isNotEmpty) {
      if (imageGroup.length > 1) {
        newChildren.add(createWrapper(imageGroup));
      } else {
        newChildren.add(imageGroup.first);
      }
    }

    // Replace the original children with the modified ones
    pElement.nodes
      ..clear()
      ..addAll(newChildren);
  });

  return document;
}

// Helper function to create a wrapper for a list of nodes
Element createWrapper(List<Node> nodes) {
  var wrapper = Element.tag('images');
  wrapper.nodes.addAll(nodes);
  return wrapper;
}