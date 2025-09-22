import 'package:test/test.dart';
import 'package:html/dom.dart';
import 'package:component_library/src/html_widget/image_processing.dart';

final parse = Document.html;

void main() {
  group('wrapNeighboringImages tests', () {
    test('doesn\'t wrap images without a parent', () {
      final html = '<img src="image1.jpg"><img src="image2.jpg">';
      Document document = parse(html);

      final result = wrapNeighboringImages(document);

      expect(result.body!.innerHtml, '<img src="image1.jpg"><img src="image2.jpg">');
    });

    test('groups consecutive images into <images> wrapper', () {
      final html = '<p><img src="image1.jpg"><img src="image2.jpg"></p>';
      Document document = parse(html);

      final result = wrapNeighboringImages(document);

      expect(result.body!.innerHtml, '<p><images><img src="image1.jpg"><img src="image2.jpg"></images></p>');
    });

    test('handles mixed text and images', () {
      final html = '<p>Text before <img src="image1.jpg"> and <img src="image2.jpg"> Text after.</p>';
      Document document = parse(html);

      final result = wrapNeighboringImages(document);

      expect(
        result.body!.innerHtml,
        '<p>Text before <img src="image1.jpg"> and <img src="image2.jpg"> Text after.</p>',
      );
    });

    test('preserves standalone images without grouping', () {
      final html = '<p>Text <img src="image1.jpg"> More text</p>';
      Document document = parse(html);

      final result = wrapNeighboringImages(document);

      expect(result.body!.innerHtml, '<p>Text <img src="image1.jpg"> More text</p>');
    });

    test('groups nested <a> elements containing images', () {
      final html = '<p><a href="#"><img src="image1.jpg"></a><a href="#"><img src="image2.jpg"></a></p>';
      Document document = parse(html);

      final result = wrapNeighboringImages(document);

      expect(result.body!.innerHtml, '<p><images><img src="image1.jpg"><img src="image2.jpg"></images></p>');
    });

    test('groups complex nested <a> elements containing images', () {
      final html = '<p><a href="#"><img src="image1.jpg"> <img src="image2.jpg"><img src="image3.jpg"></a><a href="#"><img src="image4.jpg"></a> <a href="#"><img src="image5.jpg"></a></p>';
      Document document = parse(html);

      final result = wrapNeighboringImages(document);

      expect(result.body!.innerHtml, '<p><a href="#"><img src="image1.jpg"> <images><img src="image2.jpg"><img src="image3.jpg"></images></a><img src="image4.jpg"> <img src="image5.jpg"></p>');
    });

    test('preserves text and spaces around groups', () {
      final html = '<p> Start <img src="image1.jpg"><img src="image2.jpg"> End </p>';
      Document document = parse(html);

      final result = wrapNeighboringImages(document);

      expect(result.body!.innerHtml, '<p> Start <images><img src="image1.jpg"><img src="image2.jpg"></images> End </p>');
    });

    test('handles multiple groups of images', () {
      final html = '<p><img src="image1.jpg"><img src="image2.jpg"> Text <img src="image3.jpg"><img src="image4.jpg"></p>';
      Document document = parse(html);

      final result = wrapNeighboringImages(document);

      expect(
        result.body!.innerHtml,
        '<p><images><img src="image1.jpg"><img src="image2.jpg"></images> Text <images><img src="image3.jpg"><img src="image4.jpg"></images></p>',
      );
    });

    test('does not alter plain text nodes', () {
      final html = '<p>Just some plain text without images.</p>';
      Document document = parse(html);

      final result = wrapNeighboringImages(document);

      expect(result.body!.innerHtml, '<p>Just some plain text without images.</p>');
    });

    test('handles empty elements gracefully', () {
      final html = '<p></p>';
      Document document = parse(html);

      final result = wrapNeighboringImages(document);

      expect(result.body!.innerHtml, '<p></p>');
    });

    test('handles trailing spaces correctly', () {
      final html = '<p><img src="image1.jpg"> <img src="image2.jpg"> </p>';
      Document document = parse(html);

      final result = wrapNeighboringImages(document);

      expect(result.body!.innerHtml, '<p><img src="image1.jpg"> <img src="image2.jpg"> </p>');
    });

    test('retains line breaks and formatting', () {
      final html = '<p><img src="image1.jpg"><br><img src="image2.jpg"></p>';
      Document document = parse(html);

      final result = wrapNeighboringImages(document);

      expect(result.body!.innerHtml, '<p><img src="image1.jpg"><br><img src="image2.jpg"></p>');
    });
  });
}


