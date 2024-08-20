import 'dart:convert';
import 'dart:typed_data';

class ErlangETFParser {
  final ByteData _data;
  int _offset = 0;

  ErlangETFParser(Uint8List binaryData) : _data = ByteData.sublistView(binaryData);

  dynamic parse() {
    int version = _readUint8();
    if (version != 131) {
      throw Exception('Unsupported ETF version');
    }
    return _parseTerm();
  }

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

  String _readAtom() {
    int len = _readUint16();
    List<int> charCodes = _readBytes(len);

    String rs = utf8.decode(charCodes);
    return rs;
  }

  List<dynamic> _readSmallTuple() {
    int arity = _readUint8();
    List<dynamic> elements = [];
    for (int i = 0; i < arity; i++) {
      elements.add(_parseTerm());
    }
    return elements;
  }

  List<dynamic> _readLargeTuple() {
    int arity = _readUint32();
    List<dynamic> elements = [];
    for (int i = 0; i < arity; i++) {
      elements.add(_parseTerm());
    }
    return elements;
  }

  String _readString() {
    int len = _readUint16();
    return utf8.decode(_readBytes(len));
  }

  double _readDouble() {
    double value = _data.getFloat64(_offset, Endian.big);
    _offset += 8;
    return value;
  }

  List<dynamic> _readList() {
    int length = _readUint32();
    List<dynamic> elements = [];
    for (int i = 0; i < length; i++) {
      elements.add(_parseTerm());
    }
    _readUint8(); // Discard the tail 'NIL_EXT'
    return elements;
  }

  String _parseBinaryToString() {
    // int len = _readUint32();
    // return Uint8List.fromList(_readBytes(len));
    int len = _readUint32();
    List<int> charCodes = _readBytes(len);
    String rs = utf8.decode(charCodes);
    return rs;
  }

  int _readUint8() {
    int rs = _data.getUint8(_offset++);
    return rs;
  }

  int _readUint16() {
    int value = _data.getUint16(_offset, Endian.big);
    _offset += 2;
    return value;
  }

  int _readUint32() {
    int value = _data.getUint32(_offset, Endian.big);
    _offset += 4;
    return value;
  }

  List<int> _readBytes(int length) {
    List<int> bytes = _data.buffer.asUint8List(_offset, length);
    _offset += length;
    return bytes;
  }
}
