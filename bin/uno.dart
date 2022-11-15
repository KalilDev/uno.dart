import 'dart:math';

typedef AlgebraicTuple = List<Object?>;
typedef Columns = List<Symbol>;

typedef Matrix = List<List<Object?>>;

bool _defaultEquals(Object? a, Object? b) => a == b;

bool _listEquals<T>(List<T> a, List<T> b,
    [bool Function(T, T) eEquals = _defaultEquals]) {
  if (a.length != b.length) {
    return false;
  }
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}

typedef Tuples= Set<AlgebraicTuple>;
bool _columnsEquals(Columns a, Columns b) => _listEquals(a, b);
bool _tuplesEquals(Tuples a, Tuples b) => _listEquals(a, b, _listEquals);

Matrix cloneMatrix(Matrix m) => m.map((row) => row.toList()).toList();

class TupleBag {
  TupleBag(this.columns, this.values) {
    assert(values.every((row) => row.length == columns.length));
  }
  final Columns columns;
  final Set<AlgebraicTuple> values;

  bool operator ==(other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! TupleBag) {
      return false;
    }
    return _columnsEquals(columns, other.columns) &&
        _tuplesEquals(values, other.values);
  }

  TupleBag where(bool Function(Columns, AlgebraicTuple) predicate) => TupleBag(
      columns, values.where((row) => predicate(columns, row)).toList());

  TupleBag _projectWhere(bool Function(Symbol) column) {
    final resultColumns = columns.toList();
    final resultValues = cloneMatrix(values);
    for (var i = 0; i < columns.length; i++) {
      if (column(columns[i])) {
        continue;
      }
      resultColumns.removeAt(i);
      resultValues.forEach((row) => row.removeAt(i));
      i--;
    }
    return TupleBag(resultColumns, resultValues);
  }

  TupleBag rename(Symbol from, Symbol to) {
    return TupleBag(columns.map((c) => c == from ? to : c).toList(), values);
  }

  TupleBag

  String toString() {
    var r = '| ';
    final colLengths = List.generate(columns.length, (_) => 0);
    for (var i = 0; i < columns.length; i++) {
      var colLength = columns[i].toPrettyString().length;
      final valsLength =
          values.map((row) => row[i].toString().length).reduce(max);
      colLength = colLengths[i] = max(colLength, valsLength);
      r += columns[i].toPrettyString().padRight(colLength);
      r += ' |';
    }
    if (columns.isEmpty) {
      r += ' |';
    }
    r += '\n';
    r += values.map((row) {
      var l = '| ';
      for (var i = 0; i < columns.length; i++) {
        final colLength = colLengths[i];
        l += row[i].toString().padRight(colLength);
        l += ' |';
      }
      if (columns.isEmpty) {
        l += ' |';
      }
      return l;
    }).join('\n');
    return r;
  }
}

typedef TupleFn = TupleBag Function(TupleBag);

enum Sexo { m, f }

void main() {
  {
    final alunos = TupleBag([
      #matricula,
      #nome,
      #sexo,
      #cr
    ], [
      [1, "A", "F", "cc"],
    ]);
    final matriculas = TupleBag([
      #matr,
      #disc,
      #t,
      #sem
    ], [
      [1, "DCC001", "Z", "20162"],
      [1, "DCC001", "T", "20162"],
    ]);
    print(cartesian()(alunos)(matriculas));
  }
}

extension on Symbol {
  String toPrettyString() => toString().split('"')[1];
}

// σ
TupleFn select(bool Function(Columns, AlgebraicTuple) predicate) =>
    (bag) => bag.where(predicate);

// Π
TupleFn project(Set<Symbol> columns) => _projectWhere(columns.contains);

TupleFn _projectWhere(bool Function(Symbol) column) =>
    (bag) => bag._projectWhere(column);

// ρ
TupleFn rename(Symbol from, Symbol to) => (bag) => bag.rename(from, to);

// ∪
TupleFn Function(TupleBag) union(TupleFn a, TupleFn b) =>
    (abag) => (bbag) => abag.union(bbag);

// ∩
TupleFn Function(TupleBag) intersection(TupleFn a, TupleFn b) =>
    (abag) => (bbag) => abag.intersection(bbag);

// -
TupleFn Function(TupleBag) difference(TupleFn a, TupleFn b) =>
    (abag) => (bbag) => abag.difference(bbag);

// ×
TupleFn Function(TupleBag) cartesian() => (abag) => (bbag) => abag
    .expand(
      (a) => bbag.map((b) => {...a, ...b}),
    )
    .toSet();

// ⋈
TupleFn Function(TupleBag) natural() => thetajoin(
      (a, b) => b.entries.any((e) => a[e.key] == e.value),
    );

bool setEquals(Set<Object?> a, Set<Object?> b) {
  if (a.length != b.length) {
    return false;
  }
  return a.intersection(b).length == a.length;
}

bool tupleEquals(AlgebraicTuple a, AlgebraicTuple b) {
  if (!setEquals(a.keys.toSet(), b.keys.toSet())) {
    return false;
  }
  for (final key in a.keys) {
    if (a[key] != b[key]) {
      return false;
    }
  }
  return true;
}

final equijoin = thetajoin(tupleEquals);

// θ-join
TupleFn Function(TupleBag) thetajoin(
  bool Function(
    AlgebraicTuple,
    AlgebraicTuple,
  )
      predicate,
) =>
    (abag) => (bbag) => abag.expand(
          (a) {
            try {
              final b = bbag.singleWhere(
                (b) => predicate(a, b),
              );
              final aAndB = {...a, ...b};
              return {aAndB};
            } on StateError {
              return <Map<Symbol, Object>>{};
            }
          },
        ).toSet();

// ÷
TupleFn Function(TupleBag) division() =>
    (abag) => (bbag) => _projectWhere((c) => abag.isEmpty
        ? false
        : bbag.isEmpty
            ? false
            : !abag.first.keys
                .toSet()
                .intersection(bbag.first.keys.toSet())
                .contains(c))(natural()(abag)(bbag));
