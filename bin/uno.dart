typedef AlgebraicTuple = Map<Symbol, Object>;
typedef TupleBag = Set<AlgebraicTuple>;

typedef TupleFn = TupleBag Function(TupleBag);

enum Sexo { m, f }

void main() {
  {
    final alunos = {
      {#matricula: 1, #nome: "A", #sexo: "F", #cr: "cc"},
      {#matricula: 2, #nome: "B", #sexo: "F", #cr: "cc"},
      {#matricula: 3, #nome: "C", #sexo: "M", #cr: "cc"},
      {#matricula: 4, #nome: "D", #sexo: "F", #cr: "mc"},
      {#matricula: 1, #nome: "A", #sexo: "F", #cr: "cc"},
    };
    final matriculas = {
      {#matr: 1, #disc: "DCC001", #t: "Z", #sem: "20162"},
      {#matr: 1, #disc: "DCC001", #t: "T", #sem: "20162"},
    };
    print(cartesian()(alunos)(matriculas).toPrettyString());
  }
}

extension on TupleBag {
  String toPrettyString() {
    if (isEmpty || first.isEmpty) {
      return '||';
    }
    final cols = first.keys.toList();
    var r =
        "| " + cols.map((e) => e.toString().split('"')[1]).join(' | ') + ' |';
    r += "\n";
    r += map((e) => "| " + e.values.join(" | ") + " |").join('\n');
    return r;
  }
}

TupleFn id(TupleBag bag) => (_) => bag;

TupleFn select(Set<Symbol> columns) => (bag) => bag
    .map((tuple) => {
          for (final key in tuple.keys) ...{
            if (columns.contains(key)) key: tuple[key]!
          }
        })
    .toSet();

TupleFn rename(Symbol from, Symbol to) => (bag) => bag
    .map((tuple) => {
          for (final key in tuple.keys) ...{
            if (key == from) to: tuple[key]! else key: tuple[key]!
          }
        })
    .toSet();

TupleFn Function(TupleBag) union(TupleFn a, TupleFn b) =>
    (abag) => (bbag) => abag.union(bbag);

TupleFn Function(TupleBag) intersection(TupleFn a, TupleFn b) =>
    (abag) => (bbag) => abag.intersection(bbag);

TupleFn Function(TupleBag) difference(TupleFn a, TupleFn b) =>
    (abag) => (bbag) => abag.difference(bbag);

TupleFn Function(TupleBag) cartesian() => (abag) => (bbag) => abag
    .expand(
      (a) => bbag.map((b) => {...a, ...b}),
    )
    .toSet();

TupleFn Function(TupleBag) natural(TupleFn a, TupleFn b) =>
    (abag) => (bbag) => abag.expand(
          (a) {
            try {
              final b = bbag.singleWhere(
                (b) => b.entries.any((e) => a[e] == e.value),
              );
              final aAndB = {...a, ...b};
              return {aAndB};
            } on StateError {
              return <Map<Symbol, Object>>{};
            }
          },
        ).toSet();
