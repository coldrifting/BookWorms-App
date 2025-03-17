import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:bookworms_app/services/book/book_reviews_service.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';

/// A widget that allows students to provide structured feedback on a book.
class CreateReviewWidget extends StatefulWidget {
  final String bookId;
  final Future<void> Function() updateReviews;

  const CreateReviewWidget({
    super.key,
    required this.bookId,
    required this.updateReviews
  });

  @override
  State<CreateReviewWidget> createState() => _CreateReviewWidgetState();
}

class _CreateReviewWidgetState extends State<CreateReviewWidget> {
  final _formKey = GlobalKey<FormState>();
  String _content = '';
  double _rating = 0.0;

  /// Saves the review after validation and updates the review list.
  Future<void> _saveReview() async {
    if (_formKey.currentState?.validate() ?? false) {
      BookReviewsService bookReviewsService = BookReviewsService();
      await bookReviewsService.sendReview(widget.bookId, _content, _rating);
      await widget.updateReviews();
      if (mounted) {
        Navigator.of(context).pop();
      } 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submit Your Book Review"),
        systemOverlayStyle: defaultOverlay(),
        foregroundColor: colorWhite,
        backgroundColor: colorGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _reviewStarRating(),
              addVerticalSpace(16),
              _reviewContent(),
              addVerticalSpace(16),
              FilledButton(
                onPressed: _saveReview, 
                child: const Text("Submit Review")
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Allows students to rate the book from 0.5 to 5 stars.
  Widget _reviewStarRating() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorGreen!.withAlpha(10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorGreen!, width: 2),
      ),
      child: Column(
        children: [
          Text(
            "Rate the book:", 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: colorGreenDark)
          ),
          addVerticalSpace(8),
          RatingBar.builder(
            glow: false,
            direction: Axis.horizontal,
            allowHalfRating: true,
            minRating: 0.5,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 3.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: colorYellow,
            ),
            onRatingUpdate: (rating) {  
              setState(() {
                _rating = rating;
              });
            },
          ),
        ],
      ),
    );
  }

  /// Provides a text field for students to write their book review.
  Widget _reviewContent() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Write your review here',
        hintText: 'Describe what you liked or learned from the book!',
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colorGreen!, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorGreen!, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorGreen!, width: 2.0),
        ),
      ),
      maxLines: 10,
      onChanged: (value) {
        setState(() {
          _content = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please provide a review before submitting.';
        }
        return null;
      },
    );
  }
}
