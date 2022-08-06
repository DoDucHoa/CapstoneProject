class Review {
  final String? customerName;
  final String? description;
  final String? customerAva;
  final int? rating;
  final int? bookingId;
  final int? customerId;
  Review(
      {this.customerName,
      this.customerAva,
      this.description,
      required this.rating,
      required this.bookingId,
      this.customerId});
}
