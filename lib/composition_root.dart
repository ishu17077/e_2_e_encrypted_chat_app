import 'package:chat/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secuchat/cache/local_cache.dart';
import 'package:secuchat/data/datasources/datasource_contract.dart';
import 'package:secuchat/data/datasources/sqflite_datasource_impl.dart';
import 'package:secuchat/data/factories/db_factory_impl.dart';
import 'package:secuchat/state_management/home/chats_cubit.dart';
import 'package:secuchat/state_management/message/message_bloc.dart';
import 'package:secuchat/state_management/typing/typing_notif_bloc.dart';
import 'package:secuchat/ui/pages/home/home.dart';
import 'package:secuchat/ui/pages/home/home_router.dart';
import 'package:secuchat/viewmodels/chats_view_model.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart' hide Key;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class CompositionRoot {
  static late FirebaseFirestore _firebaseFirestore;
  static late IUserService _userService;
  static late Database _db;
  static late IMessageService _messageService;
  static late ITypingNotification _typingNotification;
  static late IDataSource _dataSource;
  static late ILocalCache _localCache;
  static late IEncryption _encryption;
  static late MessageBloc _messageBloc;
  static late TypingNotifBloc _typingNotifBloc;
  static late ChatsCubit _chatsCubit;

  static configure() async {
    await Firebase.initializeApp();
    _firebaseFirestore = FirebaseFirestore.instance;
    _userService = UserService(_firebaseFirestore);
    _db = await LocalDatabaseFactory().getDatabase();
    _encryption = await EncryptionService(Encrypter(AES(Key.fromLength(32))));
    _messageService =
        MessageService(_firebaseFirestore, encryption: _encryption);
    _typingNotification = TypingNotification(_firebaseFirestore);
    _dataSource = SqfliteDatasource(_db);
    final sp = await SharedPreferences.getInstance();
    _localCache = LocalCache(sp);
    _messageBloc = MessageBloc(_messageService);
    _typingNotifBloc = TypingNotifBloc(_typingNotification);
    final viewModel = ChatsViewModel(_dataSource, userService: _userService);
    _chatsCubit = ChatsCubit(viewModel);
  }

  static Widget start() {
    // final user = _localCache.fetch("USER");1
    final IHomeRouter homeRouter =
        HomeRouter((receiver, me, {chatId}) => SizedBox());
    //TODO: Final Impl
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _chatsCubit),
        BlocProvider(create: (context) => _messageBloc),
        BlocProvider(create: (context) => _typingNotifBloc),
        //  BlocProvider(create: (context) => _cu,)
      ],
      child: Home(
          User(
            email: "lalalab@gmdsd.com",
            lastSeen: DateTime.now(),
            name: "Lalala",
            photoUrl:
                "https://static.vecteezy.com/system/resources/previews/025/220/125/large_2x/picture-a-captivating-scene-of-a-tranquil-lake-at-sunset-ai-generative-photo.jpg",
            username: "lolichan",
            active: true,
          ),
          homeRouter),
    );
  }
}
