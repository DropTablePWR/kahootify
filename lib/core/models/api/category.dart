class Category {
  final int id;
  final String name;

  Category(this.id, this.name);

  Category.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.name = json['name'];
}
