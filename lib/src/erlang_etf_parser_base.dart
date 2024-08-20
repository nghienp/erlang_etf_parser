import 'dart:convert';
import 'dart:typed_data';

/// A Dart parser for Erlang External Term Format (ETF) binary data.
///
/// This parser allows you to decode ETF binary data into Dart's native
/// data structures such as integers, strings, lists, and maps.
class ErlangETFParser {
  /// The underlying binary data to be parsed.
  final ByteData _data;

  /// The current offset position within the binary data.
  int _offset = 0;

  /// Creates an [ErlangETFParser] with the provided binary data.
  ///
  /// The binary data should be provided as a [Uint8List], and the parser
  /// will wrap it in a [ByteData] for easier access to primitive data types.
  ErlangETFParser(Uint8List binaryData) : _data = ByteData.sublistView(binaryData);

  /// Parses the ETF binary data and returns a Dart object representing
  /// the decoded data.
  ///
  /// Throws an [Exception] if the ETF version is unsupported.
  dynamic parse() {
    int version = _readUint8();
    if (version != 131) {
      throw Exception('Unsupported ETF version');
    }
    return _parseTerm();
  }

  /// Parses a single term from the binary data based on its type tag.
  dynamic _parseTerm() {
    int tag = _readUint8();

    switch (tag) {
      case 97: // SMALL_INTEGER_EXT
        return _readUint8();
      case 98: // INTEGER_EXT
        return _readUint32();
      case 100: // ATOM_EXT
        return _readAtom();
      case 107: // STRING_EXT
        return _readString();
      case 108: // LIST_EXT
        return _readList();
      case 109: // BINARY_EXT
        return _parseBinaryToString();
      case 106: // NIL_EXT
        return {};
      case 70: // NEW_FLOAT_EXT
        return _readDouble();
      case 116: // MAP_EXT
        return _readMap();
      case 104: // SMALL_TUPLE_EXT
        return _readSmallTuple();
      case 105: // LARGE_TUPLE_EXT
        return _readLargeTuple();
      default:
        throw Exception('Unsupported term type $tag');
    }
  }

  /// Reads a map from the binary data.
  ///
  /// The map is represented as a collection of key-value pairs.
  /// Each key-value pair is parsed recursively by [_parseTerm].
  Map<dynamic, dynamic> _readMap() {
    int length = _readUint32(); // Number of key-value pairs
    Map<dynamic, dynamic> map = {};
    for (int i = 0; i < length; i++) {
      var key = _parseTerm();
      var value = _parseTerm();
      map[key] = value;
    }
    return map;
  }

  /// Reads an atom from the binary data.
  ///
  /// Returns the atom as a UTF-8 encoded string.
  String _readAtom() {
    int len = _readUint16();
    List<int> charCodes = _readBytes(len);
    return utf8.decode(charCodes);
  }

  /// Reads a small tuple from the binary data.
  ///
  /// A small tuple can contain up to 255 elements. Each element is
  /// parsed recursively by [_parseTerm].
  List<dynamic> _readSmallTuple() {
    int arity = _readUint8();
    List<dynamic> elements = [];
    for (int i = 0; i < arity; i++) {
      elements.add(_parseTerm());
    }
    return elements;
  }

  /// Reads a large tuple from the binary data.
  ///
  /// A large tuple contains more than 255 elements. Each element is
  /// parsed recursively by [_parseTerm].
  List<dynamic> _readLargeTuple() {
    int arity = _readUint32();
    List<dynamic> elements = [];
    for (int i = 0; i < arity; i++) {
      elements.add(_parseTerm());
    }
    return elements;
  }

  /// Reads a string from the binary data.
  ///
  /// The string is returned as a UTF-8 decoded [String].
  String _readString() {
    int len = _readUint16();
    return utf8.decode(_readBytes(len));
  }

  /// Reads a double-precision floating-point number from the binary data.
  double _readDouble() {
    double value = _data.getFloat64(_offset, Endian.big);
    _offset += 8;
    return value;
  }

  /// Reads a list from the binary data.
  ///
  /// The list may contain a variety of data types, all of which are
  /// parsed according to their respective type tags. The list ends
  /// with a NIL_EXT, which is discarded.
  List<dynamic> _readList() {
    int length = _readUint32();
    List<dynamic> elements = [];
    for (int i = 0; i < length; i++) {
      elements.add(_parseTerm());
    }
    _readUint8(); // Discard the tail 'NIL_EXT'
    return elements;
  }

  /// Parses a binary field from the binary data into a string.
  ///
  /// This method reads the binary data as UTF-8 encoded characters.
  String _parseBinaryToString() {
    int len = _readUint32();
    List<int> charCodes = _readBytes(len);
    return utf8.decode(charCodes);
  }

  /// Reads an 8-bit unsigned integer from the binary data.
  int _readUint8() {
    return _data.getUint8(_offset++);
  }

  /// Reads a 16-bit unsigned integer from the binary data.
  int _readUint16() {
    int value = _data.getUint16(_offset, Endian.big);
    _offset += 2;
    return value;
  }

  /// Reads a 32-bit unsigned integer from the binary data.
  int _readUint32() {
    int value = _data.getUint32(_offset, Endian.big);
    _offset += 4;
    return value;
  }

  /// Reads a sequence of bytes from the binary data.
  List<int> _readBytes(int length) {
    List<int> bytes = _data.buffer.asUint8List(_offset, length);
    _offset += length;
    return bytes;
  }
}
