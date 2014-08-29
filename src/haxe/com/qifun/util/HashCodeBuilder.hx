package com.qifun.util;
import haxe.crypto.Adler32;
import haxe.io.Bytes;
import haxe.macro.*;
import haxe.macro.Type;
import haxe.macro.Expr;
using Lambda;

@:dox(hide)
class HashCodeBuilderRuntime
{
  public static inline function getHashCode(d:Dynamic):Int return
  {
    #if java
    (d:java.lang.Object).hashCode();
    #elseif cs
    untyped d.GetHashCode();
    #elseif flash
    d.hashCode
    #else
    Adler32.make(Bytes.ofString(Std.string(d)));
    #end
  }
}

class HashCodeBuilder
{

  static function hashCodeMethod(methodName:String, classType:ClassType, fields:Array<Field>):Field return
  {
    var adler32 = new Adler32();
    var moduleBytes = Bytes.ofString(classType.module);
    adler32.update(moduleBytes, 0, moduleBytes.length);
    var nameBytes = Bytes.ofString(classType.name);
    adler32.update(nameBytes, 0, nameBytes.length);
    var classHashCode = adler32.get();
    var classHashCodeExpr =
    {
      expr: EConst(CInt(Std.string(classHashCode))),
      pos: PositionTools.here(),
    }
    function checkSuperHashCode(classType:ClassType):Expr return
    {
      switch (classType.superClass)
      {
        case null:
        {
          classHashCodeExpr;
        }
        case { t: _.get() => superClassType } :
        {
          superClassType.fields.get().fold(
            function (cf:ClassField, hashCodeExpr:Expr) return
            {
              switch (cf)
              {
                case { name: fieldName, kind: FVar(AccNormal | AccNo, AccNormal | AccNo) }:
                {
                  if (cf.meta.has(":transient"))
                  {
                    hashCodeExpr;
                  }
                  else
                  {
                    macro $hashCodeExpr ^ com.qifun.util.HashCodeBuilder.HashCodeBuilderRuntime.getHashCode(this.$fieldName);
                  }
                }
                default:
                {
                  hashCodeExpr;
                }
              }
            },
            checkSuperHashCode(superClassType));
        }
      }
    }
    var hashCodeExpr = fields.fold(
      function(field, hashCodeExpr:Expr) return
      {
        switch (field)
        {
          case { name: fieldName, kind: FProp("default" | "null", "default" | "null", _, _) | FVar(_, _) }:
          {
            if (field.meta.exists(function(e)return e.name == ":transient"))
            {
              hashCodeExpr;
            }
            else
            {
              macro $hashCodeExpr ^ com.qifun.util.HashCodeBuilder.HashCodeBuilderRuntime.getHashCode(this.$fieldName);
            }
          }
          default:
          {
            hashCodeExpr;
          }
        }
      },
      checkSuperHashCode(classType));
    {
      access: TypeTools.findField(classType, methodName) != null ? [ AOverride, APublic ] : [ APublic ],
      name: methodName,
      pos: PositionTools.here(),
      kind: FFun(
        {
          args: [ ],
          ret: macro : Int,
          expr: macro return $hashCodeExpr,
        }),
    }
  }

  macro public static function build(methodName:String):Array<Field> return
  {
    var classType = Context.getLocalClass().get();
    var fields = Context.getBuildFields();
    fields.push(hashCodeMethod(methodName, classType, fields));
    fields;
  }

}
