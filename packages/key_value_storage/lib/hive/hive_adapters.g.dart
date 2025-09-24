// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class AppUserCacheModelAdapter extends TypeAdapter<AppUserCacheModel> {
  @override
  final typeId = 0;

  @override
  AppUserCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppUserCacheModel(
      userId: fields[0] as String,
      slug: fields[1] as String,
      fname: fields[2] as String,
      lname: fields[3] as String,
      userLanguage: fields[4] as String,
      groups: (fields[5] as List).cast<String>(),
      trustLevelInfo: fields[6] as String,
      voteValue: (fields[7] as num).toInt(),
      trustLevelInt: (fields[8] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, AppUserCacheModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.slug)
      ..writeByte(2)
      ..write(obj.fname)
      ..writeByte(3)
      ..write(obj.lname)
      ..writeByte(4)
      ..write(obj.userLanguage)
      ..writeByte(5)
      ..write(obj.groups)
      ..writeByte(6)
      ..write(obj.trustLevelInfo)
      ..writeByte(7)
      ..write(obj.voteValue)
      ..writeByte(8)
      ..write(obj.trustLevelInt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUserCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PostCacheModelAdapter extends TypeAdapter<PostCacheModel> {
  @override
  final typeId = 1;

  @override
  PostCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostCacheModel(
      collaborative: fields[0] as bool,
      statistics: fields[1] as PostStatisticsCacheModel,
      createdAt: (fields[2] as num).toInt(),
      postId: fields[3] as String,
      postText: fields[4] as String,
      data: fields[5] as PostDataCacheModel,
      updatedAt: (fields[6] as num).toInt(),
      subReply: (fields[7] as num).toInt(),
      sk: fields[8] as String,
      cardUrl: fields[10] as String?,
      pk: fields[9] as String,
      authors: (fields[11] as List?)?.cast<AuthorCacheModel>(),
      blurLabel: fields[12] as String?,
      archivedBy: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PostCacheModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.collaborative)
      ..writeByte(1)
      ..write(obj.statistics)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.postId)
      ..writeByte(4)
      ..write(obj.postText)
      ..writeByte(5)
      ..write(obj.data)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.subReply)
      ..writeByte(8)
      ..write(obj.sk)
      ..writeByte(9)
      ..write(obj.pk)
      ..writeByte(10)
      ..write(obj.cardUrl)
      ..writeByte(11)
      ..write(obj.authors)
      ..writeByte(12)
      ..write(obj.blurLabel)
      ..writeByte(13)
      ..write(obj.archivedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AuthorCacheModelAdapter extends TypeAdapter<AuthorCacheModel> {
  @override
  final typeId = 2;

  @override
  AuthorCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthorCacheModel(
      fname: fields[0] as String,
      userLanguage: fields[1] as String?,
      lname: fields[2] as String,
      userId: fields[3] as String,
      slug: fields[4] as String,
      trustLevel: (fields[5] as num?)?.toDouble(),
      trustName: fields[6] as String?,
      membershipType: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AuthorCacheModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.fname)
      ..writeByte(1)
      ..write(obj.userLanguage)
      ..writeByte(2)
      ..write(obj.lname)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.slug)
      ..writeByte(5)
      ..write(obj.trustLevel)
      ..writeByte(6)
      ..write(obj.trustName)
      ..writeByte(7)
      ..write(obj.membershipType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthorCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PostStatisticsCacheModelAdapter
    extends TypeAdapter<PostStatisticsCacheModel> {
  @override
  final typeId = 4;

  @override
  PostStatisticsCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostStatisticsCacheModel(
      authorCount: (fields[0] as num).toInt(),
      commentCount: (fields[1] as num).toInt(),
      topLevelCommentCount: (fields[2] as num).toInt(),
      revisionCount: (fields[3] as num).toInt(),
      voteCount: (fields[4] as num).toInt(),
      voteValueSum: (fields[5] as num).toInt(),
      reactions: fields[6] as ReactionsCacheModel?,
    );
  }

  @override
  void write(BinaryWriter writer, PostStatisticsCacheModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.authorCount)
      ..writeByte(1)
      ..write(obj.commentCount)
      ..writeByte(2)
      ..write(obj.topLevelCommentCount)
      ..writeByte(3)
      ..write(obj.revisionCount)
      ..writeByte(4)
      ..write(obj.voteCount)
      ..writeByte(5)
      ..write(obj.voteValueSum)
      ..writeByte(6)
      ..write(obj.reactions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostStatisticsCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PostDataCacheModelAdapter extends TypeAdapter<PostDataCacheModel> {
  @override
  final typeId = 5;

  @override
  PostDataCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostDataCacheModel(
      createdByUser: fields[0] as AuthorCacheModel,
      subwiki: fields[1] as SubwikiPostOriginCacheModel?,
      maintrunk: fields[2] as MainTrunkPostOriginCacheModel?,
      userprofile: fields[3] as UserProfilePostOriginCacheModel?,
    );
  }

  @override
  void write(BinaryWriter writer, PostDataCacheModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.createdByUser)
      ..writeByte(1)
      ..write(obj.subwiki)
      ..writeByte(2)
      ..write(obj.maintrunk)
      ..writeByte(3)
      ..write(obj.userprofile);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostDataCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubwikiPostOriginCacheModelAdapter
    extends TypeAdapter<SubwikiPostOriginCacheModel> {
  @override
  final typeId = 6;

  @override
  SubwikiPostOriginCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubwikiPostOriginCacheModel(
      slug: fields[0] as String?,
      sk: fields[1] as String?,
      pk: fields[2] as String?,
      label: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SubwikiPostOriginCacheModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.slug)
      ..writeByte(1)
      ..write(obj.sk)
      ..writeByte(2)
      ..write(obj.pk)
      ..writeByte(3)
      ..write(obj.label);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubwikiPostOriginCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MainTrunkPostOriginCacheModelAdapter
    extends TypeAdapter<MainTrunkPostOriginCacheModel> {
  @override
  final typeId = 7;

  @override
  MainTrunkPostOriginCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MainTrunkPostOriginCacheModel(
      slug: fields[0] as String?,
      sk: fields[1] as String?,
      pk: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MainTrunkPostOriginCacheModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.slug)
      ..writeByte(1)
      ..write(obj.sk)
      ..writeByte(2)
      ..write(obj.pk);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainTrunkPostOriginCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserProfilePostOriginCacheModelAdapter
    extends TypeAdapter<UserProfilePostOriginCacheModel> {
  @override
  final typeId = 8;

  @override
  UserProfilePostOriginCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfilePostOriginCacheModel(
      slug: fields[0] as String?,
      sk: fields[1] as String?,
      pk: fields[2] as String?,
      fname: fields[3] as String?,
      lname: fields[4] as String?,
      userId: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfilePostOriginCacheModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.slug)
      ..writeByte(1)
      ..write(obj.sk)
      ..writeByte(2)
      ..write(obj.pk)
      ..writeByte(3)
      ..write(obj.fname)
      ..writeByte(4)
      ..write(obj.lname)
      ..writeByte(5)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfilePostOriginCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PostPageCacheModelAdapter extends TypeAdapter<PostPageCacheModel> {
  @override
  final typeId = 9;

  @override
  PostPageCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostPageCacheModel(
      postList: (fields[0] as List).cast<String>(),
      pageKey: fields[1] as String?,
      nextPageKey: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PostPageCacheModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.postList)
      ..writeByte(1)
      ..write(obj.pageKey)
      ..writeByte(2)
      ..write(obj.nextPageKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostPageCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CommentCacheModelAdapter extends TypeAdapter<CommentCacheModel> {
  @override
  final typeId = 10;

  @override
  CommentCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommentCacheModel(
      statistics: fields[1] as CommentStatisticsCacheModel,
      slug: fields[2] as String,
      createdAt: (fields[3] as num).toInt(),
      updatedAt: (fields[4] as num).toInt(),
      level: (fields[6] as num).toInt(),
      commentText: fields[7] as String,
      sk: fields[9] as String,
      pk: fields[10] as String,
      authors: (fields[11] as List).cast<AuthorCacheModel>(),
      data: fields[12] as CommentDataCacheModel,
      archived: fields[13] as bool?,
      deleted: fields[14] as bool?,
      topLevel: fields[15] as CommentOriginCacheModel,
      blurLabel: fields[16] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CommentCacheModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(1)
      ..write(obj.statistics)
      ..writeByte(2)
      ..write(obj.slug)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.level)
      ..writeByte(7)
      ..write(obj.commentText)
      ..writeByte(9)
      ..write(obj.sk)
      ..writeByte(10)
      ..write(obj.pk)
      ..writeByte(11)
      ..write(obj.authors)
      ..writeByte(12)
      ..write(obj.data)
      ..writeByte(13)
      ..write(obj.archived)
      ..writeByte(14)
      ..write(obj.deleted)
      ..writeByte(15)
      ..write(obj.topLevel)
      ..writeByte(16)
      ..write(obj.blurLabel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CommentStatisticsCacheModelAdapter
    extends TypeAdapter<CommentStatisticsCacheModel> {
  @override
  final typeId = 11;

  @override
  CommentStatisticsCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommentStatisticsCacheModel(
      authorCount: (fields[0] as num).toInt(),
      commentReplies: (fields[1] as num).toInt(),
      revisionCount: (fields[2] as num).toInt(),
      voteCount: fields[3] == null ? 0 : (fields[3] as num).toInt(),
      voteValueSum: fields[4] == null ? 0 : (fields[4] as num).toInt(),
      reactions: fields[5] as ReactionsCacheModel?,
    );
  }

  @override
  void write(BinaryWriter writer, CommentStatisticsCacheModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.authorCount)
      ..writeByte(1)
      ..write(obj.commentReplies)
      ..writeByte(2)
      ..write(obj.revisionCount)
      ..writeByte(3)
      ..write(obj.voteCount)
      ..writeByte(4)
      ..write(obj.voteValueSum)
      ..writeByte(5)
      ..write(obj.reactions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentStatisticsCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CommentDestinationCacheModelAdapter
    extends TypeAdapter<CommentDestinationCacheModel> {
  @override
  final typeId = 12;

  @override
  CommentDestinationCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommentDestinationCacheModel(
      name: fields[0] as String,
      entity: fields[1] as String,
      slug: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CommentDestinationCacheModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.entity)
      ..writeByte(2)
      ..write(obj.slug);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentDestinationCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CommentDataCacheModelAdapter extends TypeAdapter<CommentDataCacheModel> {
  @override
  final typeId = 13;

  @override
  CommentDataCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommentDataCacheModel(
      createdByUser: fields[0] as AuthorCacheModel,
      post: fields[1] as CommentOriginCacheModel?,
      comment: fields[2] as CommentOriginCacheModel?,
    );
  }

  @override
  void write(BinaryWriter writer, CommentDataCacheModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.createdByUser)
      ..writeByte(1)
      ..write(obj.post)
      ..writeByte(2)
      ..write(obj.comment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentDataCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CommentOriginCacheModelAdapter
    extends TypeAdapter<CommentOriginCacheModel> {
  @override
  final typeId = 14;

  @override
  CommentOriginCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommentOriginCacheModel(
      sk: fields[0] as String,
      pk: fields[1] as String,
      slug: fields[2] as String,
      createdByUser: fields[3] as AuthorCacheModel?,
    );
  }

  @override
  void write(BinaryWriter writer, CommentOriginCacheModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.sk)
      ..writeByte(1)
      ..write(obj.pk)
      ..writeByte(2)
      ..write(obj.slug)
      ..writeByte(3)
      ..write(obj.createdByUser);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentOriginCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CommentPageCacheModelAdapter extends TypeAdapter<CommentPageCacheModel> {
  @override
  final typeId = 15;

  @override
  CommentPageCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommentPageCacheModel(
      commentList: (fields[0] as List).cast<CommentCacheModel>(),
      pageKey: fields[1] as String?,
      nextPageKey: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CommentPageCacheModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.commentList)
      ..writeByte(1)
      ..write(obj.pageKey)
      ..writeByte(2)
      ..write(obj.nextPageKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentPageCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserVoteCacheModelAdapter extends TypeAdapter<UserVoteCacheModel> {
  @override
  final typeId = 16;

  @override
  UserVoteCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserVoteCacheModel(
      parentSk: fields[1] as String,
      parentPk: fields[2] as String,
      isUp: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserVoteCacheModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.parentSk)
      ..writeByte(2)
      ..write(obj.parentPk)
      ..writeByte(3)
      ..write(obj.isUp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserVoteCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TranslationCacheModelAdapter extends TypeAdapter<TranslationCacheModel> {
  @override
  final typeId = 17;

  @override
  TranslationCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TranslationCacheModel(
      itemId: fields[0] as String,
      sourceHash: fields[1] as String,
      sourceLanguage: fields[2] as String,
      targetLanguage: fields[3] as String,
      translatedText: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TranslationCacheModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.sourceHash)
      ..writeByte(2)
      ..write(obj.sourceLanguage)
      ..writeByte(3)
      ..write(obj.targetLanguage)
      ..writeByte(4)
      ..write(obj.translatedText);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslationCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReactionsCacheModelAdapter extends TypeAdapter<ReactionsCacheModel> {
  @override
  final typeId = 18;

  @override
  ReactionsCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReactionsCacheModel(
      values: (fields[12] as Map?)?.cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, ReactionsCacheModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(12)
      ..write(obj.values);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReactionsCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TrustObjectCacheModelAdapter extends TypeAdapter<TrustObjectCacheModel> {
  @override
  final typeId = 19;

  @override
  TrustObjectCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrustObjectCacheModel(
      trustLevel: (fields[0] as num).toInt(),
      pk: fields[1] as String,
      sk: fields[2] as String,
      updatedAt: (fields[3] as num).toInt(),
      createdAt: (fields[4] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, TrustObjectCacheModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.trustLevel)
      ..writeByte(1)
      ..write(obj.pk)
      ..writeByte(2)
      ..write(obj.sk)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrustObjectCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SpiderUrlDataCacheModelAdapter
    extends TypeAdapter<SpiderUrlDataCacheModel> {
  @override
  final typeId = 20;

  @override
  SpiderUrlDataCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpiderUrlDataCacheModel(
      url: fields[0] as String,
      expiresAt: (fields[1] as num).toInt(),
      fetchData: fields[2] as SpiderFetchDataCacheModel?,
      oembedData: fields[3] as SpiderOembedDataCacheModel?,
    );
  }

  @override
  void write(BinaryWriter writer, SpiderUrlDataCacheModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.expiresAt)
      ..writeByte(2)
      ..write(obj.fetchData)
      ..writeByte(3)
      ..write(obj.oembedData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpiderUrlDataCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SpiderFetchDataCacheModelAdapter
    extends TypeAdapter<SpiderFetchDataCacheModel> {
  @override
  final typeId = 21;

  @override
  SpiderFetchDataCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpiderFetchDataCacheModel(
      title: fields[0] as String,
      screenshot: fields[1] as String,
      cachedImage: fields[2] as String?,
      description: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SpiderFetchDataCacheModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.screenshot)
      ..writeByte(2)
      ..write(obj.cachedImage)
      ..writeByte(3)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpiderFetchDataCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SpiderOembedDataCacheModelAdapter
    extends TypeAdapter<SpiderOembedDataCacheModel> {
  @override
  final typeId = 22;

  @override
  SpiderOembedDataCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpiderOembedDataCacheModel(
      type: fields[0] as String,
      title: fields[1] as String,
      thumbnailUrl: fields[2] as String?,
      providerName: fields[3] as String,
      html: fields[4] as String,
      authorName: fields[5] as String?,
      authorUrl: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SpiderOembedDataCacheModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.thumbnailUrl)
      ..writeByte(3)
      ..write(obj.providerName)
      ..writeByte(4)
      ..write(obj.html)
      ..writeByte(5)
      ..write(obj.authorName)
      ..writeByte(6)
      ..write(obj.authorUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpiderOembedDataCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubwikiListCacheModelAdapter extends TypeAdapter<SubwikiListCacheModel> {
  @override
  final typeId = 23;

  @override
  SubwikiListCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubwikiListCacheModel(
      subwikiList: (fields[1] as List).cast<SubwikiCacheModel>(),
      timestamp: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SubwikiListCacheModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.subwikiList)
      ..writeByte(2)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubwikiListCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubwikiCacheModelAdapter extends TypeAdapter<SubwikiCacheModel> {
  @override
  final typeId = 24;

  @override
  SubwikiCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubwikiCacheModel(
      slug: fields[1] as String,
      subwikiLabel: fields[2] as String,
      subwikiDesc: fields[3] as String,
      createdAt: (fields[4] as num).toInt(),
      statistics: fields[6] as SubwikiStatisticsCacheModel,
      branchColor: fields[15] as String?,
      branchId: fields[16] as String?,
      isFollowing: fields[17] as bool?,
      subwikiLang: fields[7] as String?,
      createdByUser: fields[9] as AuthorCacheModel?,
      branchIcon: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SubwikiCacheModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(1)
      ..write(obj.slug)
      ..writeByte(2)
      ..write(obj.subwikiLabel)
      ..writeByte(3)
      ..write(obj.subwikiDesc)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.statistics)
      ..writeByte(7)
      ..write(obj.subwikiLang)
      ..writeByte(9)
      ..write(obj.createdByUser)
      ..writeByte(10)
      ..write(obj.branchIcon)
      ..writeByte(15)
      ..write(obj.branchColor)
      ..writeByte(16)
      ..write(obj.branchId)
      ..writeByte(17)
      ..write(obj.isFollowing);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubwikiCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubwikiStatisticsCacheModelAdapter
    extends TypeAdapter<SubwikiStatisticsCacheModel> {
  @override
  final typeId = 25;

  @override
  SubwikiStatisticsCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubwikiStatisticsCacheModel(
      totalFollowers: (fields[1] as num).toInt(),
      totalPosts: (fields[2] as num).toInt(),
      authorCount: (fields[3] as num?)?.toInt(),
      revisionCount: (fields[4] as num?)?.toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, SubwikiStatisticsCacheModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.totalFollowers)
      ..writeByte(2)
      ..write(obj.totalPosts)
      ..writeByte(3)
      ..write(obj.authorCount)
      ..writeByte(4)
      ..write(obj.revisionCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubwikiStatisticsCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
