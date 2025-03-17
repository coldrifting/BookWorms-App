import 'dart:convert';
import 'package:bookworms_app/models/book/book_summary.dart';
import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:bookworms_app/models/classroom/classroom.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';
import 'package:http/http.dart' as http;

class ClassroomService {
  final http.Client client;

  ClassroomService({http.Client? client}) : client = client ?? http.Client();

  Future<Classroom?> getClassroomDetails() async {
    final response = await client.sendRequest(
      uri: classroomDetailsUri(),
      method: "GET");

    if (response.ok) {
      final data = jsonDecode(response.body);
      return Classroom.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('An error occurred when getting the classroom details.');
    }
  }

  Future<Classroom> createClassroomDetails(String newClassroomName) async {
    final response = await client.sendRequest(
      uri: createClassroomUri(newClassroomName),
      method: "POST");

    if (response.ok) {
      final data = jsonDecode(response.body);
      return Classroom.fromJson(data);
    } else {
      throw Exception('An error occurred when creating the classroom.');
    }
  }

  Future<bool> changeClassroomIcon(int newIcon) async {
    final response = await client.sendRequest(
      uri: changeClassroomIconUri(newIcon),
      method: "PUT");

    if (response.ok) {
      return true;
    } else {
      throw Exception('An error occurred when deleting the classroom.');
    }
  }

  Future<bool> changeClassroomName(String newName) async {
    final response = await client.sendRequest(
      uri: renameClassroomUri(newName),
      method: "PUT");

    if (response.ok) {
      return true;
    } else {
      throw Exception('An error occurred when renaming the classroom.');
    }
  }

  Future<bool> deleteClassroom() async {
    final response = await client.sendRequest(
      uri: deleteClassroomUri(),
      method: "DELETE");

    if (response.ok) {
      return true;
    } else {
      throw Exception('An error occurred when deleting the classroom.');
    }
  }

  Future<bool> createClassroomBookshelf(Bookshelf bookshelf) async {
    final response = await client.sendRequest(
      uri: createClassroomBookshelfUri(bookshelf.name),
      method: "POST");

    if (response.ok) {
      return true;
    } else {
      throw Exception('An error occurred when creating a new bookshelf.');
    }
  }

  Future<bool> deleteClassroomBookshelf(Bookshelf bookshelf) async {
    final response = await client.sendRequest(
      uri: deleteClassroomBookshelfUri(bookshelf.name),
      method: "DELETE");

    if (response.ok) {
      return true;
    } else {
      throw Exception('An error occurred when deleting the classroom bookshelf.');
    }
  }

  Future<bool> renameClassroomBookshelf(String oldName, String newName) async {
    final response = await client.sendRequest(
      uri: renameClassroomBookshelfUri(oldName, newName),
      method: "POST");

    if (response.ok) {
      return true;
    } else {
      throw Exception('An error occurred when renaming the classroom bookshelf.');
    }
  }

  Future<bool> insertBookIntoClassroomBookshelf(Bookshelf bookshelf, BookSummary book) async {
    final response = await client.sendRequest(
      uri: insertIntoClassroomBookshelfUri(bookshelf.name, book.id),
      method: "PUT");

    if (response.ok) {
      return true;
    } else {
      throw Exception('An error occurred when adding the book to the bookshelf.');
    }
  }

  Future<bool> removeBookFromClassroomBookshelf(Bookshelf bookshelf, BookSummary book) async {
    final response = await client.sendRequest(
      uri: removeBookFromClassroomBookshelfUri(bookshelf.name, book.id),
      method: "DELETE");

    if (response.ok) {
      return true;
    } else {
      throw Exception('An error occurred when remove the book from the bookshelf.');
    }
  }
}