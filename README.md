AkaSaveUtil
===========

This is a really,really simple and quick util class for saving and loading data on SharedObject. 



I always use stringified jsons for save/load features and SharedObject is quite sufficient cross-platform saving solution. However some might get paranoid (like me) that if you're saving crucial save game data (like a player-id which is used to request client data from server), you shouldn't just save it in easily manipulatable format.

What i do is simply generate a savedata encrypted with a player-specific key (which can easily be facebook id if it's a social game, or you can figure something) and each time client requests to access savedata, device has to know the key to decrypt the value.

 How this class works:
==================

```
var so = new EncryptedSharedObjectWrapper();
//var so = new EncryptedSharedObjectWrapper("sharedObjectName", "local-path-to-shardObject", "aesKey-Unique-ID");

so.setData("gameSave", "your-string-here");
so.save();

//...

var gameSave = so.getData("gameSave");

```


Note: This util class uses ASCrypt haxe port which is available in this repository(license included) or here https://github.com/Meychi/ASCrypt