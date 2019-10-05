import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:momento/models/event.dart';
import 'package:momento/models/family.dart';
import 'package:momento/models/member.dart';
import 'package:momento/repositories/event_repository.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/repositories/member_repository.dart';
import 'package:momento/screens/signin_page/sign_in_page.dart';
import 'package:momento/services/cloud_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc {
  final _auth = FirebaseAuth.instance;
  final _familyRepository = FamilyRepository();
  final _memberRepository = MemberRepository();
  final _cloudStorageService = CloudStorageService();
  final _secureStorage = FlutterSecureStorage();
  final _eventRepository = EventRepository();

  String uid;
  String name;

  Family family;

  Future<Null> _getFamily(String uid) async {
    family = await _familyRepository.getFamily(uid);
  }

  final _descriptionController = BehaviorSubject<String>();
  Function(String) get _setDescription => _descriptionController.add;
  Stream<String> get getDescription => _descriptionController.stream;

  Future<Null> updateDescription(String newDescription) async {
    await _familyRepository.updateDescription(family, newDescription);
    family.description = newDescription;
    _setDescription(newDescription);
  }

  final _photosController = BehaviorSubject<List<String>>();
  Function(List<String>) get _setPhotos => _photosController.add;
  Stream<List<String>> get getPhotos => _photosController.stream;

  Future<Null> uploadPhoto(File photo) async {
    String fileName = family.numPhotos.toString();
    await _cloudStorageService.uploadPhotoAt("${family.id}/photos/original/", fileName, photo);
    _familyRepository.addPhoto(family);
    List<String> photos = List.from(_photosController.value);
    photos.add(await _cloudStorageService
        .getPhoto("${family.id}/photos/original/${family.numPhotos}.jpg"));
    _setPhotos(photos);
    family.numPhotos++;
  }

  Future<Null> _updatePhotos() async {
    List<String> photos = [];
    String url;
    for (int i = 0; i < family.numPhotos; i++) {
      url =
          await _cloudStorageService.getPhoto("${family.id}/photos/thumbnails/${i.toString()}.jpg");
      if (url == null) {
        url =
            await _cloudStorageService.getPhoto("${family.id}/photos/original/${i.toString()}.jpg");
      }
      photos.add(url);
    }
    _setPhotos(photos);
  }

  final _membersController = BehaviorSubject<List<Member>>();
  Function(List<Member>) get _setMembers => _membersController.add;
  Stream<List<Member>> get getMembers => _membersController.stream;
  List<Member> get getLatestMembers => _membersController.value;

  Future<Null> addMember(Member member) async {
    List<Member> members = List.from(_membersController.value);
    members.add(member);
    family.members.add(member.id);
    _setMembers(members);
  }

  Future<Null> updateMembers() async {
    final members = await _memberRepository.getFamilyMembers(family);
    _setMembers(members);
  }

  final _thumbnailsController = BehaviorSubject<List<String>>();
  Function(List<String>) get _setThumbnails => _thumbnailsController.add;
  Stream<List<String>> get getThumbnails => _thumbnailsController.stream;

  Future<Null> _updateThumbnails() async {
    List<String> thumbnails = [];
    for (String artefactId in family.artefacts) {
      String url =
          await _cloudStorageService.getPhoto("${family.id}/artefacts/thumbnails/$artefactId");
      if (url == null) {
        url = await _cloudStorageService.getPhoto("${family.id}/artefacts/original/$artefactId");
      }
      thumbnails.add(url);
    }
    print(thumbnails);
    _setThumbnails(thumbnails);
  }

  Future<Null> addArtefact(String artefactId) async {
    family.members.add(artefactId);
    List<String> thumbnails = List<String>.from(_thumbnailsController.value);
    String url =
        await _cloudStorageService.getPhoto("${family.id}/artefacts/thumbnails/$artefactId");
    if (url == null) {
      url = await _cloudStorageService.getPhoto("${family.id}/artefacts/original/$artefactId");
    }
    thumbnails.add(url);
    _setThumbnails(thumbnails);
  }

  final _eventsController = BehaviorSubject<List<Event>>();
  Function(List<Event>) get _setEvents => _eventsController.add;
  Stream<List<Event>> get getEvents => _eventsController.stream;

  Future<Null> updateEvents() async {
    List<Future<Event>> futureEvents =
        family.events.map((id) => _eventRepository.getEventById(id)).toList();
    List<Event> events = await Future.wait(futureEvents);
    _setEvents(events);
  }

  /// check if user logged in before, if not, push login page
  /// then read user's family name and description
  Future<Null> init(BuildContext context) async {
    uid = await _authenticate(context);
    name = await _secureStorage.read(key: "familyName");

    _getFamily(uid)
        .then((_) => _setDescription(family.description))
        .then((_) => _updatePhotos())
        .then((_) => updateMembers())
        .then((_) => _updateThumbnails())
        .then((_) => updateEvents());
  }

  Future<String> _authenticate(BuildContext context) async {
    String uid;
    uid = await _secureStorage.read(key: "uid");
    if (uid == null) {
      uid = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignInPage(),
          fullscreenDialog: true,
        ),
      );
    }
    return uid;
  }

  Future<Null> signOut() async {
    await _auth.signOut();
    await _secureStorage.delete(key: "uid");
    await _secureStorage.delete(key: "familyName");
  }
}
