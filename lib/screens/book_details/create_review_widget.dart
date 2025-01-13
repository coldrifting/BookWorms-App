import 'package:bookworms_app/services/book_reviews_service.dart';
import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CreateReviewWidget extends StatefulWidget {
  final String bookId;

  const CreateReviewWidget({
    super.key,
    required this.bookId,
  });

  @override
  State<CreateReviewWidget> createState() => _CreateReviewWidgetState();
}

class _CreateReviewWidgetState extends State<CreateReviewWidget> {
  final _formKey = GlobalKey<FormState>();
  String _content = '';
  double _rating = 0.0;

  void _saveReview() {
    if (_formKey.currentState?.validate() ?? false) {
      BookReviewsService bookReviewsService = BookReviewsService();
      bookReviewsService.sendReview(widget.bookId, _content, _rating);
      _rating = 0.0;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: _saveReview,
            child: const Text("Save"))
        ],
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
            ],
          ),
        ),
      ),
    );
  }

  /// The user can select the number of stars they rate the book.
  Widget _reviewStarRating() {
    return Center(
      child: RatingBar.builder(
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
    );
  }

  Widget _reviewContent() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Leave a review...',
        border: OutlineInputBorder(),
      ),
      maxLines: 16,
      onChanged: (value) {
        setState(() {
          _content = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Review cannot be empty';
        }
        return null;
      },
    );
  }
}
