import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:momento/models/artefact.dart';
import 'package:momento/models/event.dart';
import 'package:momento/models/family.dart';
import 'package:momento/models/member.dart';
import 'package:momento/repositories/artefact_repository.dart';
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
  final _artefactRepository = ArtefactRepository();
  final _cloudStorageService = CloudStorageService();
  final _secureStorage = FlutterSecureStorage();
  final _eventRepository = EventRepository();

  String uid;
  String name;

  Family family;

  Future<Null> _getFamily() async {
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
    // upload photo to cloud and get url
    final id = "profile_photo_" + DateTime.now().millisecondsSinceEpoch.toString();
    final url = await _cloudStorageService.uploadPhotoAt("${family.id}/", id, photo);
    // update locally
    final photos = List.from(_photosController.value)..add(url);
    _setPhotos(photos);
    family.photos.add(id);
    // update the database entry
    _familyRepository.addPhoto(family, url);
  }

  final _membersController = BehaviorSubject<List<Member>>();
  Function(List<Member>) get _setMembers => _membersController.add;
  Stream<List<Member>> get getMembers => _membersController.stream;
  List<Member> get getLatestMembers => _membersController.value;

  void addMember(Member member) {
    family.members.add(member.id);
    List<Member> members = List.from(_membersController.value);
    members.add(member);
    _setMembers(members);
  }

  Future<Null> _updateMembers() async {
    final members = await _memberRepository.getFamilyMembers(family);
    _setMembers(members);
  }

  final _artefactsController = BehaviorSubject<List<Artefact>>();
  Function(List<Artefact>) get _setArtefacts => _artefactsController.add;
  Stream<List<Artefact>> get getArtefacts => _artefactsController.stream;

  Future<Null> _getArtefacts() async {
    List<Future<Artefact>> futureArtefacts =
        family.artefacts.map((id) => _artefactRepository.getArtefactById(id)).toList();
    List<Artefact> artefacts = await Future.wait(futureArtefacts);
    _setArtefacts(artefacts);
  }

  void updateArtefact(Artefact updatedArtefact) {
    // update locally
    final newArtefacts = List<Artefact>.from(_artefactsController.value);
    final index = newArtefacts.indexWhere((artefact) {
      return artefact.id == updatedArtefact.id;
    });
    newArtefacts.removeAt(index);
    newArtefacts.insert(index, updatedArtefact);
    _setArtefacts(newArtefacts);
  }

  void addArtefact(Artefact artefact) {
    // update locally
    family.artefacts.add(artefact.id);
    List<Artefact> newArtefacts = List<Artefact>.from(_artefactsController.value);
    newArtefacts.add(artefact);
    // push to the stream
    _setArtefacts(newArtefacts);
  }

  final _eventsController = BehaviorSubject<List<Event>>();
  Function(List<Event>) get _setEvents => _eventsController.add;
  Stream<List<Event>> get getEvents => _eventsController.stream;

  void addEvent(Event newEvent) {
    // update locally
    family.events.add(newEvent.id);
    List<Event> newEvents = List<Event>.from(_eventsController.value);
    newEvents.add(newEvent);
    _setEvents(newEvents);
  }

  Future<Null> _updateEvents() async {
    List<Future<Event>> futureEvents =
        family.events.map((id) => _eventRepository.getEventById(id)).toList();
    List<Event> events = await Future.wait(futureEvents);
    _setEvents(events);
  }

  // close sinks
  void close() {
    _photosController.close();
    _artefactsController.close();
    _descriptionController.close();
    _membersController.close();
    _eventsController.close();
  }

  /// check if user logged in before, if not, push login page
  /// then read user's family name and description
  Future<Null> init(BuildContext context) async {
    await _authenticate(context);
    name = await _secureStorage.read(key: "familyName");
    _getFamily().then((_) {
      _setDescription(family.description);
      _setPhotos(family.photos);
      _getArtefacts();
      _updateMembers();
      _updateEvents();
    });
  }

  Future<Null> _authenticate(BuildContext context) async {
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
  }

  Future<Null> signOut() async {
    await _auth.signOut();
    await _secureStorage.delete(key: "uid");
    await _secureStorage.delete(key: "familyName");
  }
}
