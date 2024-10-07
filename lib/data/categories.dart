import 'package:flutter/material.dart';
import 'package:shoping_list_app/models/categories.dart';

const categories = {
  Categories.vegetables: CategoryDetails(
    'Vegetables',
    Color.fromARGB(255, 0, 255, 128),
  ),
  Categories.fruit: CategoryDetails(
    'Fruit',
    Color.fromARGB(255, 145, 255, 0),
  ),
  Categories.meat: CategoryDetails(
    'Meat',
    Color.fromARGB(255, 255, 102, 0),
  ),
  Categories.dairy: CategoryDetails(
    'Dairy',
    Color.fromARGB(255, 0, 208, 255),
  ),
  Categories.carbs: CategoryDetails(
    'Carbs',
    Color.fromARGB(255, 0, 60, 255),
  ),
  Categories.sweets: CategoryDetails(
    'Sweets',
    Color.fromARGB(255, 255, 149, 0),
  ),
  Categories.spices: CategoryDetails(
    'Spices',
    Color.fromARGB(255, 255, 187, 0),
  ),
  Categories.convenience: CategoryDetails(
    'Convenience',
    Color.fromARGB(255, 191, 0, 255),
  ),
  Categories.hygiene: CategoryDetails(
    'Hygiene',
    Color.fromARGB(255, 149, 0, 255),
  ),
  Categories.other: CategoryDetails(
    'Other',
    Color.fromARGB(255, 0, 225, 255),
  ),
};