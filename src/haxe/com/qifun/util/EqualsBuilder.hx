package com.qifun.util;
import haxe.macro.*;
import haxe.macro.Type;
import haxe.macro.Expr;
using Lambda;

class EqualsBuilder
{

  static function equalsMethod(methodName:String, classType:ClassType, fields:Array<Field>):Field return
  {
    var classParts = classType.module.split(".");
    classParts.push(classType.name);
    var classExpr = MacroStringTools.toFieldExpr(classParts);
    var thisEqualsExpr = fields.fold(
      function(field, equalsExpr:Expr) return
      {
        switch (field)
        {
          case { name: fieldName, kind: FProp("default" | "null", "default" | "null", _, _) | FVar(_, _) }:
          {
            if (field.meta.foreach(function(e)return e.name != ":transient"))
            {
              macro $equalsExpr && this.$fieldName == that.$fieldName;
            }
            else
            {
              equalsExpr;
            }
          }
          default:
          {
            equalsExpr;
          }
        }
      },
      macro that != null);
    function checkSuperEquals(classType:ClassType):Expr return
    {
      switch (classType.superClass)
      {
        case null:
        {
          thisEqualsExpr;
        }
        case { t: _.get() => superClassType } :
        {
          superClassType.fields.get().fold(
            function (cf:ClassField, equalsExpr:Expr) return
            {
              switch (cf)
              {
                case { name: fieldName, kind: FVar(AccNormal | AccNo, AccNormal | AccNo) }:
                {
                  if (!cf.meta.has(":transient"))
                  {
                    macro $equalsExpr && this.$fieldName == that.$fieldName;
                  }
                  else
                  {
                    equalsExpr;
                  }
                }
                default:
                {
                  equalsExpr;
                }
              }
            },
            checkSuperEquals(superClassType));
        }
      }
    }
    var equalsExpr = checkSuperEquals(classType);
    {
      access: TypeTools.findField(classType, methodName) != null ? [ AOverride, APublic ] : [ APublic ],
      name: methodName,
      pos: PositionTools.here(),
      kind: FFun(
        {
          args: [ { name: "d", type: macro : Dynamic } ],
          ret: macro : Bool,
          expr: macro
          {
            var that = Std.instance(d, $classExpr);
            return $equalsExpr;
          }
        }),
    }
  }

  macro public static function build(methodName:String):Array<Field> return
  {
    var classType = Context.getLocalClass().get();
    var fields = Context.getBuildFields();
    fields.push(equalsMethod(methodName, classType, fields));
    fields;
  }

}
