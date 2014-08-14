package com.qifun.util;
import haxe.macro.Context;
import haxe.macro.Expr;
class ClassList
{
  macro public static function save(fileName:String):Void return
  {

    Context.onGenerate(function(types)
    {
      var f = sys.io.File.write(fileName, false);
      try
      {
        var classList:Array<String> = [];
        for( t in types )
        {
          switch( t )
          {
            case TInst(c, _):
            {
              classList.push(c.toString() + "\n");
            }
            case TEnum(e, _):
            {
              classList.push(e.toString() + "\n");
            }
            default:
          }
        }
        for (str in classList)
        {
          if (str == "haxe.io.Output\n" || str == "haxe.io.Input\n" || str == "cs.internal._HxObject.HxObject\n")
            continue;
          f.writeString(str);
        }
      }
      catch (e:Dynamic)
      {
        f.close();
        neko.Lib.rethrow("WriteFileError");
      }
      f.close();
    });
  }
}