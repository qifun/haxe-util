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
        for( t in types )
        {
          switch( t )
          {
            case TInst(c, _):
            {
              f.writeString(c.toString() + "\n");
            }
            case TEnum(e, _):
            {
              f.writeString(e.toString() + "\n"); 
            }
            default:
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