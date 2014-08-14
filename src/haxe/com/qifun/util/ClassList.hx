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
          switch(str)
          { 
            case "haxe.io.Output\n":
            case "haxe.io.Input\n":
            case "cs.internal._HxObject.HxObject\n":
            case "java.internal._HxObject.HxObject\n":
            case "haxe.ds.IntMap\n":
            default: 
            {
              f.writeString(str);
              trace(str);
            }
          }
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