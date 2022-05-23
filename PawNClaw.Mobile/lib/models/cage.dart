class Cage {
  final int id;
  final String name;
  final double price;
  double? discount;
  final String imageUrl;
  final String description;
  final int cagetype;

  Cage(
      {required this.id,
      required this.name,
      required this.price,
      this.discount,
      required this.imageUrl,
      required this.description,
      required this.cagetype});
}
