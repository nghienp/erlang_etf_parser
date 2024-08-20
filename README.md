# Erlang ETF Parser for Dart

[Erlang ETF Parser](https://pub.dev/packages/erlang_etf_parser) is a Dart package designed to parse Erlang External Term Format (ETF) binary data directly in Dart. It enables Dart and Flutter applications to seamlessly decode and work with data serialized in Erlang's native ETF format.

## Features

- **Comprehensive ETF Support**: Parse various Erlang data types including integers, floats, atoms, binaries, lists, tuples, and maps.
- **Easy Integration**: Quickly integrate with Dart and Flutter applications to decode ETF data.
- **Open Source**: Contributions are welcome! Fork the repository, submit pull requests, and help improve the package.

## Installation

To get started, add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  erlang_etf_parser: ^0.0.2
```

Then, run:

```sh
flutter pub get
```

## Usage

Here's a quick example to demonstrate how you can use the `erlang_etf_parser` package to parse Erlang ETF data:

### Example

```dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:erlang_etf_parser/erlang_etf_parser.dart';

void main() {
  // Example binary data encoded in Erlang ETF format (Base64 string)
  String base64String = 'g3QAAAACZAAKbWVzc2FnZV9pZGElZAAGc3RvY2tzbAAAAAN0AAAABWQACWF2Z19wcmljZUZAJFwo9cKPXGQABGNvZGVtAAAAA0ZQVGQAAmlkYQlkAAZzZWxsXzFGQCTR64UeuFJkAARzdGVwRj/cKPXCj1wpdAAAAAVkAAlhdmdfcHJpY2VGQEBQo9cKPXFkAARjb2RlbQAAAANBQ0JkAAJpZGEAZAAGc2VsbF8xRkBJpmZmZmZmZAAEc3RlcEZAMZcKPXCj13QAAAAFZAAJYXZnX3ByaWNlRkA0euFHrhR7ZAAEY29kZW0AAAADUExYZAACaWRhBGQABnNlbGxfMUZAPOj1wo9cKWQABHN0ZXBGQCNwo9cKPXFq';
  
  // Decode the Base64 string to binary data
  Uint8List binaryData = base64.decode(base64String);
  
  // Instantiate the Erlang ETF parser
  ErlangETFParser parser = ErlangETFParser(binaryData);
  
  // Parse the binary data into Dart objects
  var parsedData = parser.parse();
  
  // Convert the parsed data to a JSON string
  String jsonString = jsonEncode(parsedData);
  
  // Print the JSON string
  print(jsonString);
}
```

### Output

This code will parse the provided ETF binary data and convert it into a Dart object, which is then serialized to a JSON string.

```json
{
  "message_id": "some_id",
  "stocks": {
    "avg_price": "some_value",
    "code": "some_code",
    "id": "some_id",
    "sell_1": "some_sell_value",
    "step": "some_step_value",
  }
}
```

### Supported Data Types

- **Small Integer** (`SMALL_INTEGER_EXT`): 8-bit unsigned integer.
- **Integer** (`INTEGER_EXT`): 32-bit signed integer.
- **Float** (`NEW_FLOAT_EXT`): IEEE 754 double-precision floating-point number.
- **Atom** (`ATOM_EXT`, `SMALL_ATOM_EXT`): Represents an atom, a unique identifier in Erlang.
- **String** (`STRING_EXT`): List of characters (as a byte list).
- **List** (`LIST_EXT`, `NIL_EXT`): Represents a proper list or an empty list.
- **Tuple** (`SMALL_TUPLE_EXT`, `LARGE_TUPLE_EXT`): Fixed-size collections of elements.
- **Map** (`MAP_EXT`): Key-value pairs.
- **Binary** (`BINARY_EXT`): Raw binary data.

## Contributing

We welcome contributions! To contribute:

1. Fork the repository on [GitHub](https://github.com/nghienp/erlang_etf_parser).
2. Create a new branch with your feature or bug fix (`git checkout -b feature-branch`).
3. Make sure your branch is up to date with the latest changes from `main`:
   ```sh
   git fetch origin
   git checkout main
   git pull origin main
   git checkout -b feature-branch
   ```
4. Commit your changes (`git commit -am 'Add new feature'`).
5. Push your branch (`git push origin feature-branch`).
6. Open a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

Thanks to the open-source community for providing tools and inspiration that made this project possible.

---

This version of the `README.md` includes direct links to your package on Pub.dev and your GitHub repository, making it easier for users to find and contribute to your project.