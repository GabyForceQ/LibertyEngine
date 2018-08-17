/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/world/meta.d, _meta.d)
 * Documentation:
 * Coverage:
**/
// TODO: PrimaryKey shoudn't be updated
module liberty.world.meta;

import std.json : JSONValue;

/**
 *
**/
struct Property;

/**
 *
**/
immutable Serialize = q{
  private {
    import std.json : JSONValue, parseJSON;
    
    string jsonStr;
    JSONValue jsonValue;

    void buildJSON() {
      import std.traits : hasUDA;
      import std.array : empty, popBack;
      jsonStr = "{";
      static foreach (member; __traits(derivedMembers, typeof(this))) {
        static if (mixin("hasUDA!(" ~ typeof(this).stringof ~ "." ~ member ~ ", Property)")) {
          jsonStr ~= member.stringof ~ ": \"" ~ id ~ "\",";
        }
      }
      if (jsonStr != "{") {
        jsonStr.popBack();
      }
      jsonStr ~= "}";
      jsonValue = parseJSON(jsonStr);
    }
  }

  /**
   *
  **/
  inout(T) getFiled(T)(string field) inout {
    import std.conv : to;
    return jsonValue[field].str.to!T;
  }

  /**
   *
  **/
  void updateState(JSONValue val) {
    import std.traits : hasUDA;
    static foreach (member; __traits(derivedMembers, typeof(this))) {
      static if (mixin("!hasUDA!(" ~ typeof(this).stringof ~ "." ~ member ~ ", Ignore)")) {
        if (member in val.object) {
          mixin("this." ~ member ~ " = val[\"" ~ member ~ "\"].str;");
        }
      }
    }
    buildJSON();
  }
  //serializedResponeData
};