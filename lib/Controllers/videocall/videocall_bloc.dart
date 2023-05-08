import 'dart:convert';
import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chatbot/Service/chat/chat_service.dart';
import 'package:chatbot/Service/videocall%20service/endpoints.dart';
import 'package:chatbot/views/call_screen/call_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
part 'videocall_event.dart';
part 'videocall_state.dart';

@Injectable()
class VideocallBloc extends Bloc<VideocallEvent, VideocallState> {
  final RtcEngine agoraEngine; // Agora engine instance
  final FirebaseFirestore firestore;
  VideocallBloc({required this.agoraEngine, required this.firestore})
      : super(VideocallInitial()) {
    String role = "publisher";
    String tokenType = "userAccount";
    // final RtcEngine agoraEngine = createAgoraRtcEngine();
    on<VideocallingEvent>((event, emit) async {
      emit(ConnectingState());

      String? token;
      int localUid = FirebaseAuth.instance.currentUser!.uid.codeUnitAt(0);
      bool islocalJoin = false;
      bool isremoteJoin = false;
      int? remoteUid;

      //create cahnnel name
      final createRoom = ChatService();
      final String channelName = await createRoom.onCreateRoomId(event.botId);
      // retrieve or request camera and microphone permissions
      await [Permission.microphone, Permission.camera].request();

      //create an instance of the Agora engine
      //agoraEngine = createAgoraRtcEngine();
      await agoraEngine.initialize(const RtcEngineContext(appId: appId));

      await agoraEngine.enableVideo();

      //await agoraEngine.enableLocalVideo(true);
      /// send requesst to remote user
      ///
      final remoteUser =
          await firestore.collection("users").doc(event.botId).get();

      final localUser = await firestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      String tokenOfRemoteUser = "";

      if (remoteUser.data() != null) {
        tokenOfRemoteUser = remoteUser.data()!["token"];
      }
      if (tokenOfRemoteUser.isNotEmpty && localUser.data() != null) {
//send notification
        await sendNotification(
            userName: localUser.data()!["userName"],
            channelName: channelName,
            tokenOfRemoteUser: tokenOfRemoteUser);

//=======================
        ///update to database
        ///text notification
        log("helloooooooooooooooooooooooooooooooooooooooooo");

//===================end text notification ========================================
        agoraEngine.registerEventHandler(
          RtcEngineEventHandler(
            onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
              islocalJoin = true;

              add(ClientJoinedEvent(
                  localusername: localUser.data()!["userName"],
                  agoraEngine: agoraEngine,
                  channelName: channelName,
                  isJoined: isremoteJoin,
                  isLocalJoined: islocalJoin,
                  remoteUid: remoteUid,
                  localUid: localUid));
            },
            onUserJoined:
                (RtcConnection connection, int remoteUidd, int elapsed) {
              isremoteJoin = true;
              remoteUid = remoteUidd;

              add(ClientJoinedEvent(
                  localusername: localUser.data()!["userName"],
                  agoraEngine: agoraEngine,
                  channelName: channelName,
                  isJoined: isremoteJoin,
                  isLocalJoined: islocalJoin,
                  remoteUid: remoteUidd,
                  localUid: localUid));
            },
            onUserOffline: (RtcConnection connection, int remoteuserId,
                UserOfflineReasonType reason) {
              remoteUid = null;
              add(LeavecallEvent());
            },
          ),
        );
        log("helloooooooooooooooooooooooooooooooooooooooooo 2222222222222");
        //end register event handler==================================
        //create token
        log("$channelName/$role/$tokenType/$localUid/");
        final response = await http.get(
            Uri.parse("$tokenBase$channelName/$role/$tokenType/$localUid/"));
        log(response.body);
        final result = json.decode(response.body);

        //response.body as Map;

        token = result["rtcToken"];
        await agoraEngine.startPreview();
        log("helloooooooooooooooooooooooooooooooooooooooooo33333333333");

        // Set channel options including the client role and channel profile
        ChannelMediaOptions options = const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        );

        await agoraEngine.joinChannel(
            token: token!,
            channelId: channelName,
            uid: localUid,
            options: options);
      }
      log("$token $channelName $localUid");
      // Register the event handler
    });
//============================================================================================================
    /// this event trigger when remote user joined
    /// and local user also

    on<ClientJoinedEvent>((event, emit) async {
      emit(ConnectingState());
      emit(VideocallingState(
          agoraEngine: event.agoraEngine,
          channelName: event.channelName,
          isJoined: event.isJoined,
          isLocalJoined: event.isLocalJoined,
          remoteUid: event.remoteUid,
          localUid: event.localUid));
      Map<String, dynamic> messages = {
        "message": "${event.localusername} ",
        "sendby": FirebaseAuth.instance.currentUser!.uid,
        "time": FieldValue.serverTimestamp(),
        "isread": false,
        "messageType": "notif"
      };

      final docId = await firestore
          .collection("chatroom")
          .doc(event.channelName)
          .collection("chats")
          .add(messages);
      if (docId != null) {
        firestore
            .collection("chatroom")
            .doc(event.channelName)
            .collection("chats")
            .doc(docId.id)
            .update(messages.update("isread", (value) => true));
      }
    });
//========================================================================
// trigger when user accept call
    on<CallAcceptEvent>((event, emit) async {
      emit(ConnectingState());

      String? token;
      int localUid = FirebaseAuth.instance.currentUser!.uid.codeUnitAt(0);
      bool islocalJoin = false;
      bool isremoteJoin = false;
      int? remoteUid;

      // retrieve or request camera and microphone permissions
      await [Permission.microphone, Permission.camera].request();

      //create an instance of the Agora engine
      // agoraEngine = createAgoraRtcEngine();
      await agoraEngine.initialize(const RtcEngineContext(appId: appId));

      await agoraEngine.enableVideo();
      agoraEngine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            islocalJoin = true;

            add(ClientJoinedEvent(
                agoraEngine: agoraEngine,
                channelName: event.channelname,
                isJoined: isremoteJoin,
                isLocalJoined: islocalJoin,
                remoteUid: remoteUid,
                localUid: localUid));
          },
          onUserJoined:
              (RtcConnection connection, int remoteUidd, int elapsed) {
            isremoteJoin = true;
            remoteUid = remoteUidd;

            add(ClientJoinedEvent(
                agoraEngine: agoraEngine,
                channelName: event.channelname,
                isJoined: isremoteJoin,
                isLocalJoined: islocalJoin,
                remoteUid: remoteUidd,
                localUid: localUid));
          },
          onUserOffline: (RtcConnection connection, int remoteuserId,
              UserOfflineReasonType reason) {
            remoteUid = null;
            add(LeavecallEvent());
          },
        ),
      );
      //end register event handler==================================
      //create token

      final response = await http.get(Uri.parse(
          "$tokenBase${event.channelname}/$role/$tokenType/$localUid/"));
      final result = json.decode(response.body);

      //response.body as Map;

      token = result["rtcToken"];
      await agoraEngine.startPreview();

      // Set channel options including the client role and channel profile
      ChannelMediaOptions options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      );

      await agoraEngine.joinChannel(
          token: token!,
          channelId: event.channelname,
          uid: localUid,
          options: options);
    }

        // Register the event handler

        );
    //=============================================================================
    on<LeavecallEvent>((event, emit) {
      distroy();
      emit(LeavecallState());
    });
  }

  //push notificaation   to fcm
  Future<void> sendNotification(
      {required String channelName,
      required String tokenOfRemoteUser,
      required String userName}) async {
    try {
      http.Response response = await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAQQSRYHE:APA91bEHoVH-smuDDnbeIANR5kfRnzuE9wdZAlBvR-_AUzHjwelzANQ9HEIPAul701O-pL9EwHbb_b5_GA_wpBUdlZcL-zAwieZTSPJvsEglQ5WHcThuQA4pJOMMDlWK4bPDufbE0pgT',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'Incoming Videocall',
              'title': userName,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'channelName': channelName
            },
            'to': tokenOfRemoteUser,
          },
        ),
      );
      response;
    } catch (e) {
      e;
    }
  }

  distroy() {
    agoraEngine.leaveChannel();
    // agoraEngine.release();
  }

  @override
  Future<void> close() {
    agoraEngine.leaveChannel();
    agoraEngine.release();
    return super.close();
  }
}
