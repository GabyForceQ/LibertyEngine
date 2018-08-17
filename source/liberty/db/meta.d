/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/db/meta.d, _meta.d)
 * Documentation:
 * Coverage:
**/
module liberty.db.meta;

/**
 *
**/
struct PrimaryKey;

/**
 *
**/
struct ForeignKey;

/**
 *
**/
struct AutoIncrement;

/**
 * Didn't accept null values.
**/
struct Required;

/**
 *
**/
immutable DatabaseEntity = q{

};

/*
@Model(Serializable)
struct UserModel {
    mixin(DatabaseEntity);

    @PrimaryKey
    @AutoIncrement
    private ulong id;

    @Required
    private string username;

    @Required
    private string password;
}

@Controller("\user")
class User : Actor {
    mixin(BindModel);
    mixin(NodeBody);

    @WebRoute(RequestType.Get, "\:id")
    ulong getId() {
        return this.model.serializedResponseData("id");
    }

    @WebRoute("PUT", "\:id")
    void changeUsername(string username) {
        this.model.update({
            username
        });
    }
}
*/

/**
unittest {
  assert(
    (new WorldObject("MyNode", null).id) == "MyNode", 
    "Id from serialized model is wrong!"
  );
}
*/