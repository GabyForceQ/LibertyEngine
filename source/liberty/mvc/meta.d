// TODO: PrimaryKey shoudn't be updated

module liberty.mvc.meta;

import std.json : JSONValue;

/**
 *
**/
struct Model;

/**
 *
**/
struct View;

/**
 *
**/
struct Controller;

/**
 *
**/
immutable BindModel = q{
  import std.traits : hasUDA;
  import std.array : replace;
  static if (hasUDA!(typeof(this), Controller)) {
    mixin("private " ~ (typeof(this).stringof).replace("Controller", "") ~ "Model model;");
  } else {
    static assert(0, (typeof(this).stringof).replace("Controller", "") ~ " is not a controller.");
  }
};

/**
 *
**/
immutable BindView = q{
  import std.traits : hasUDA;
  static if (hasUDA!(typeof(this), Controller)) {
    mixin("private " ~ (typeof(this).stringof).replace("Controller", "") ~ "View view;");
  } else {
    static assert(0, (typeof(this).stringof).replace("Controller", "") ~ " is not a controller.");
  }
};

/**
 *
**/
struct Ignore;

/**
 *
**/
immutable Serialize = q{
  @Ignore
  private {
    import std.json : JSONValue, parseJSON;
    
    string jsonStr;
    JSONValue jsonValue;

    void buildJSON() {
      import std.traits : hasUDA;
      import std.array : empty, popBack;
      jsonStr = "{";
      static foreach (member; __traits(derivedMembers, typeof(this))) {
        static if (mixin("!hasUDA!(" ~ typeof(this).stringof ~ "." ~ member ~ ", Ignore)")) {
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
  @Ignore
  inout(T) get(T)(string field) inout {
    import std.conv : to;
    return jsonValue[field].str.to!T;
  }

  /**
   *
  **/
  @Ignore
  void update(JSONValue val) {
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

/**
 *
**/
alias JSON = JSONValue; 