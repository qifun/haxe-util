package com.qifun.util;
import haxe.macro.*;
import haxe.macro.Expr;

class ClassRenamer
{

  #if macro
  public static function addDefinedPrefix(definedKey:String):Array<Field> return
  {
    addPrefix(Context.definedValue(definedKey));
  }

  public static function addPrefix(prefix:Null<String>):Array<Field> return
  {
    if (prefix != null)
    {
      var localClass = Context.getLocalClass().get();
      var nativePack = switch (localClass.pack)
      {
        case []: "haxe.root";
        case p: p.join(".");
      }
      var nativeName = '$nativePack.$prefix${localClass.name}';
      localClass.meta.add(":native", [ macro $v{nativeName} ], Context.currentPos());
    }
    return Context.getBuildFields();
  }
  #end

}

// vim: et sts=2 sw=2
