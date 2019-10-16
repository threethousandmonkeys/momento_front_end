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
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';

/** Business logical：
 *     For edit and update profile page.
 **/

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

  Future<void> _getPhotos() async {
    final numPhotos = int.parse(await _secureStorage.read(key: "numPhotos"));
    List<String> photos = [];
    for (int i = 0; i < numPhotos; i++) {
      photos.add(await _secureStorage.read(key: "photo$i"));
    }
    _setPhotos(photos);
  }

  Future<void> _updatePhotos() async {
    _setPhotos(family.photos);
    await _secureStorage.write(key: "numPhotos", value: family.photos.length.toString());
    for (int i = 0; i < family.photos.length; i++) {
      await _secureStorage.write(key: "photo$i", value: family.photos[i]);
    }
  }

  /// Update photo
  Future<Null> uploadPhoto(File photo) async {
    // upload photo to cloud and get url
    final id = "profile_photo_" + DateTime.now().millisecondsSinceEpoch.toString();
    final url = await _cloudStorageService.uploadPhotoAt("${family.id}/", id, photo);
    // update locally
    final photos = List<String>.from(_photosController.value);
    photos.add(url);
    _setPhotos(photos);
    family.photos.add(url);
    await _secureStorage.write(key: "numPhotos", value: family.photos.length.toString());
    await _secureStorage.write(key: "photo${family.photos.length - 1}", value: url);
    // update the database entry
    _familyRepository.updatePhotos(family);
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

  Future<Null> _getMembers() async {
    final futureMembers =
    family.members.map((id) => _memberRepository.getMemberById(family.id, id));
    final members = await Future.wait(futureMembers);
    _setMembers(members);
  }

  // gets an individual member of a family based on its user id
  Member getMemberByUserId(String userId) {
    for(Member member in _membersController.value) {
      if (member.id == userId) {
        return member;
      }
    }
    return null;
  }

  /// Update member's information
  void updateMember(Member updatedMember) {
    // update locally
    final newMembers = List<Member>.from(_membersController.value);
    final index = newMembers.indexWhere((member) {
      return member.id == updatedMember.id;
    });
    newMembers.removeAt(index);
    newMembers.insert(index, updatedMember);
    _setMembers(newMembers);
  }

  final _artefactsController = BehaviorSubject<List<Artefact>>();
  Function(List<Artefact>) get _setArtefacts => _artefactsController.add;
  Stream<List<Artefact>> get getArtefacts => _artefactsController.stream;

  Future<Null> _getArtefacts() async {
    final futureArtefacts =
    family.artefacts.map((id) => _artefactRepository.getArtefactById(family.id, id)).toList();
    List<Artefact> artefacts = await Future.wait(futureArtefacts);
    _setArtefacts(artefacts);
  }

  /// Deal with artifacts -
  /// add
  void addArtefact(Artefact artefact) {
    // update locally
    family.artefacts.add(artefact.id);
    List<Artefact> newArtefacts = List<Artefact>.from(_artefactsController.value);
    newArtefacts.add(artefact);
    // push to the stream
    _setArtefacts(newArtefacts);
  }

  /// Deal with artifacts -
  /// update
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

  final _eventsController = BehaviorSubject<List<Event>>();
  Function(List<Event>) get _setEvents => _eventsController.add;
  Stream<List<Event>> get getEvents => _eventsController.stream;

  /// Deal with events -
  /// add
  void addEvent(Event newEvent) {
    // update locally
    family.events.add(newEvent.id);
    List<Event> newEvents = List<Event>.from(_eventsController.value);
    newEvents.add(newEvent);
    _setEvents(newEvents);
  }

  Future<Null> _getEvents() async {
    List<Future<Event>> futureEvents =
    family.events.map((id) => _eventRepository.getEventById(family.id, id)).toList();
    List<Event> events = await Future.wait(futureEvents);
    _setEvents(events);
  }

  /// Deal with events -
  /// update
  void updateEvent(Event updatedEvent) {
    // update locally
    final newEvents = List<Event>.from(_eventsController.value);
    final index = newEvents.indexWhere((event) {
      return event.id == updatedEvent.id;
    });
    newEvents.removeAt(index);
    newEvents.insert(index, updatedEvent);
    _setEvents(newEvents);
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
    await _getPhotos();
    _getFamily().then((_) {
      _setDescription(family.description);
      if (_photosController.value.length == 0) {
        _updatePhotos();
      }
      _getArtefacts();
      _getMembers();
      _getEvents();
    });
  }

  Future<void> _authenticate(BuildContext context) async {
    uid = await _secureStorage.read(key: "uid");
    if (uid == null) {
      uid = await Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.downToUp,
          child: SignInPage(),
        ),
      );
    }
  }

  Future<Null> signOut() async {
    await _auth.signOut();
    await _secureStorage.deleteAll();
  }
}
