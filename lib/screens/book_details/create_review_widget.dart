import 'package:bookworms_app/services/book_reviews_service.dart';
import 'package:flutter/material.dart';

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
              const SizedBox(height: 16.0),
              _reviewContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reviewStarRating() {
    return Column(
      children: [
        Text('Rating: ${_rating.toStringAsFixed(1)} / 5.0'),
        Slider(
          value: _rating,
          min: 0.0,
          max: 5.0,
          divisions: 10,
          onChanged: (value) {
            setState(() {
              _rating = value;
            });
          },
        ),
      ]
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
