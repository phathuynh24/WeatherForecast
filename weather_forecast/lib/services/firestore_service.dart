import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveSearchHistory(
      String city, Map<String, dynamic> weatherData) async {
    final user = _auth.currentUser;
    if (user != null) {
      final uid = user.uid;
      final date = DateTime.now().toIso8601String().split('T').first;

      try {
        final searchTime = DateTime.now().toIso8601String();

        weatherData['searchTime'] = searchTime;

        final userDoc =
            _db.collection('Users').doc(uid).collection('History').doc(date);
        final docSnapshot = await userDoc.get();

        if (docSnapshot.exists) {
          await userDoc.update({
            'searchHistory.$city': weatherData,
          });
        } else {
          await userDoc.set({
            'searchHistory': {
              city: weatherData,
            },
          });
        }

        debugPrint('Search history saved successfully.');
      } catch (e) {
        debugPrint('Error saving search history: $e');
      }
    }
  }

  Future<List<Map<String, dynamic>>> getSearchHistory() async {
    final user = _auth.currentUser;
    if (user != null) {
      final uid = user.uid;
      final date = DateTime.now().toIso8601String().split('T').first;

      try {
        final snapshot = await _db
            .collection('Users')
            .doc(uid)
            .collection('History')
            .doc(date)
            .get();

        if (snapshot.exists) {
          Map<String, dynamic> historyData = snapshot.data()!['searchHistory'];
          return historyData.entries
              .map((entry) => {entry.key: entry.value})
              .toList();
        } else {
          return [];
        }
      } catch (e) {
        debugPrint('Error fetching search history: $e');
        return [];
      }
    }
    return [];
  }
}
