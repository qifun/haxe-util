/*
 * haxe-util
 * Copyright 2014 深圳岂凡网络有限公司 (Shenzhen QiFun Network Corp., LTD)
 *
 * Author: 杨博 (Yang Bo) <pop.atry@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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

