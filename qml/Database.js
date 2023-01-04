.pragma library
.import QtQuick.LocalStorage 2.0 as Sql

var db = Sql.LocalStorage.openDatabaseSync("scorekeeperdb", "1.0", "Database for game score board", 100000000);

function init() {
    console.log("init db");
    db.transaction(
        function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS "players" ( \
                "player_id" INTEGER PRIMARY KEY  AUTOINCREMENT UNIQUE , \
                "player_name" TEXT NOT NULL , \
                "player_color" INTEGER NOT NULL DEFAULT 0, \
                "player_photo" TEXT NOT NULL DEFAULT "qrc:/qml/default-player_photo.png", \
                "deleted" BOOL NOT NULL DEFAULT 0);');
            tx.executeSql('CREATE TABLE IF NOT EXISTS "games"   ( \
                "game_id" INTEGER PRIMARY KEY  AUTOINCREMENT UNIQUE , \
                "comments" TEXT DEFAULT CURRENT_TIMESTAMP, \
                "started" DATETIME DEFAULT CURRENT_TIMESTAMP, \
                "finished" DATETIME, \
                "final_photo" TEXT , \
                "deleted" BOOL NOT NULL DEFAULT 0);');
            tx.executeSql('CREATE TABLE IF NOT EXISTS "scores"  ( \
                "score_id" INTEGER PRIMARY KEY  AUTOINCREMENT UNIQUE , \
                "game_id" INTEGER NOT NULL , \
                "player_id" INTEGER NOT NULL , \
                "score_value" INTEGER NOT NULL , \
                "score_photo" TEXT NOT NULL DEFAULT "qrc:/qml/default-score_photo.png", \
                "score_appended" DATETIME DEFAULT CURRENT_TIMESTAMP,\
                "comments" TEXT DEFAULT CURRENT_TIMESTAMP, \
                "deleted" BOOL NOT NULL DEFAULT 0);');
            tx.executeSql('CREATE TABLE IF NOT EXISTS "colors"  ( \
                "color_id" INTEGER PRIMARY KEY  AUTOINCREMENT UNIQUE , \
                "color_name" TEXT NOT NULL , \
                "color" TEXT NOT NULL , \
                "deleted" BOOL DEFAULT 0);');
            var rs = tx.executeSql('SELECT * FROM "colors";');
            if (0 >= rs.rows.length) {
                tx.executeSql('INSERT INTO "colors" ("color","color_name") VALUES(?,?);', [ "red"   ,"red"    ]);
                tx.executeSql('INSERT INTO "colors" ("color","color_name") VALUES(?,?);', [ "yellow","yellow" ]);
                tx.executeSql('INSERT INTO "colors" ("color","color_name") VALUES(?,?);', [ "green" ,"green"  ]);
                tx.executeSql('INSERT INTO "colors" ("color","color_name") VALUES(?,?);', [ "blue"  ,"blue"   ]);
                tx.executeSql('INSERT INTO "colors" ("color","color_name") VALUES(?,?);', [ "black" ,"black"  ]);
                tx.executeSql('INSERT INTO "colors" ("color","color_name") VALUES(?,?);', [ "silver","silver" ]);
            }
            tx.executeSql('CREATE TABLE IF NOT EXISTS "color"  ( \
                "color_id" INTEGER NOT NULL , \
                "game_id" INTEGER NOT NULL , \
                "player_id" INTEGER NOT NULL, \
                CONSTRAINT player_color_in_game PRIMARY KEY (player_id, color_id, game_id ) );');
        }
    )
}

function getPlayers() {
    var records = [];

    db.transaction(
        function(tx) {
            var rs = tx.executeSql('SELECT * FROM "players" WHERE deleted=0;');
            for (var i = 0; i < rs.rows.length; i++) {
                var tmp = rs.rows.item(i);
                delete tmp.deleted;
                records.push(tmp);
            }
        }
    );

    return records;
}
function addPlayer(name,color,avatar) {
    db.transaction(
        function(tx) {
            tx.executeSql('INSERT INTO "players" ("player_name","player_color","player_photo") VALUES(?,?,?);', [ name,color,avatar ]);
        }
    );
}
function editPlayer(player_id,name,color,avatar) {
    db.transaction(
        function(tx) {
            tx.executeSql('UPDATE "players" SET "player_name"=?,"player_color"=?,"player_photo"=? WHERE player_id=?;', [ name,color,avatar,player_id ]);
        }
    );
}
function delPlayer(id) {
    db.transaction(
        function(tx) {
            tx.executeSql('UPDATE "players" SET "deleted"=1 WHERE player_id=?;', [ id ]);
        }
    );
}

function getGameWinners(game_id) {
    var records = []

    db.transaction(
        function(tx) {
            // thanks White Owl (http://www.sql.ru/forum/actualutils.aspx?action=gotomsg&tid=1250998&msg=20238209) for sql query
            var rs = tx.executeSql('SELECT player_id, max_score,player_name,player_color,player_photo\
                                     FROM "players" \
                                      JOIN ( with t(player_id, max_score) as (\
                                       SELECT player_id, sum(score_value)\
                                        FROM "scores" where deleted=0 AND game_id=? group by "player_id") \
                                       SELECT t.* FROM t WHERE t.max_score=(select max(max_score) FROM t) \
                                      )USING ("player_id") WHERE deleted=0;', [game_id]);
            for (var i = 0; i < rs.rows.length; i++) {
                var tmp = rs.rows.item(i);
                delete tmp.deleted;
                records.push(tmp);
            }
        }
    );

    return records
}
function getGames() {
    var records = []

    db.transaction(
        function(tx) {
            var rs = tx.executeSql('SELECT * FROM "games" WHERE deleted=0;');
            for (var i = 0; i < rs.rows.length; i++) {
                var tmp = rs.rows.item(i);
                delete tmp.deleted;
                records.push(tmp);
            }
        }
    );

    return records
}
function addGame(coments) {
    var game_id=null;
    db.transaction(
        function(tx) {
            tx.executeSql('INSERT INTO "games" ("comments") VALUES(?);', [ coments ]);
            var rs = tx.executeSql('SELECT max(game_id) as game_id FROM "games" WHERE deleted=0 LIMIT 1 ;');
            if (1 === rs.rows.length) {
                game_id = rs.rows.item(0).game_id;
            }
        }
    );
    return game_id;
}
function finGame(id,final_photo) {
    db.transaction(
        function(tx) {
            tx.executeSql('UPDATE "games" SET "final_photo"=?, "finished"=CURRENT_TIMESTAMP WHERE id=?;', [ final_photo, id ]);
        }
    );
}
function delGame(id) {
    db.transaction(
        function(tx) {
            tx.executeSql('UPDATE "games" SET "deleted"=1 WHERE id=?;', [ id ]);
        }
    );
}

function getGameScores(game_id) {
    var records = []

    db.transaction(
        function(tx) {
            var rs = tx.executeSql('SELECT * FROM "scores"  JOIN "players" USING ("player_id") WHERE "game_id"=?;',[ game_id ]);
            for (var i = 0; i < rs.rows.length; i++) {
//                 for (var p in rs.rows.item(i)){
//                     console.log("item("+i+")["+p+"]"+rs.rows.item(i)[p]);
//                 }
                var tmp = rs.rows.item(i);
                delete tmp.deleted;
                records.push(tmp);
            }
        }
    );

    return records
}
function addScore(game_id,player_id,value,photo) {
    db.transaction(
        function(tx) {
            tx.executeSql('INSERT INTO "scores" ("game_id","player_id","score_value","score_photo") VALUES(?,?,?,?);', [ game_id,player_id,value,photo ]);
        }
    );
}
function editScore(score_id,player_id,score_value,score_photo) {
    db.transaction(
        function(tx) {
            tx.executeSql('UPDATE "scores" SET "player_id"=?, "score_value"=?, "score_photo"=?, "score_appended"=CURRENT_TIMESTAMP WHERE score_id=?;', [ player_id,score_value,score_photo,score_id ]);
        }
    );
}
function delScore(id) {
    db.transaction(
        function(tx) {
    // TODO delete image
            tx.executeSql('DELETE FROM "scores" WHERE id=?;', [ id ]);
        }
    );
}

function getColors() {
    var records = []

    db.transaction(
        function(tx) {
            var rs = tx.executeSql('SELECT * FROM "colors";');
            for (var i = 0; i < rs.rows.length; i++) {
                var tmp = rs.rows.item(i);
                delete tmp.deleted;
                records.push(tmp);
            }
        }
    );

    return records
}
