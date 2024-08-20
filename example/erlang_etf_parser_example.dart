import 'dart:convert';
import 'dart:typed_data';

import '../lib/erlang_etf_parser.dart';

void main() {
  String base64String =
      'g3QAAAACZAAKbWVzc2FnZV9pZGElZAAGc3RvY2tzbAAAAAN0AAAABWQACWF2Z19wcmljZUZAJFwo9cKPXGQABGNvZGVtAAAAA0ZQVGQAAmlkYQlkAAZzZWxsXzFGQCTR64UeuFJkAARzdGVwRj/cKPXCj1wpdAAAAAVkAAlhdmdfcHJpY2VGQEBQo9cKPXFkAARjb2RlbQAAAANBQ0JkAAJpZGEAZAAGc2VsbF8xRkBJpmZmZmZmZAAEc3RlcEZAMZcKPXCj13QAAAAFZAAJYXZnX3ByaWNlRkA0euFHrhR7ZAAEY29kZW0AAAADUExYZAACaWRhBGQABnNlbGxfMUZAPOj1wo9cKWQABHN0ZXBGQCNwo9cKPXFq';
  Uint8List binaryData = base64.decode(base64String);
  ErlangETFParser parser = ErlangETFParser(binaryData);
  var parsedData = parser.parse();
  String jsonString = jsonEncode(parsedData);
  print(jsonString);
}
