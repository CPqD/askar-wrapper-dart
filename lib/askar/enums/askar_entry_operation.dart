enum EntryOperation {
  insert(0),
  replace(1),
  remove(2);

  final int value;
  const EntryOperation(this.value);
}
