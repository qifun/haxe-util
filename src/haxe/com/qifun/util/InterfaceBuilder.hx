package com.qifun.util;


import haxe.ds.StringMap;
import haxe.macro.Context;
import haxe.macro.ExprTools;
import haxe.macro.MacroStringTools;
import haxe.macro.TypeTools;
import haxe.macro.ComplexTypeTools;
import haxe.macro.Type;
import haxe.macro.Expr;
using StringTools;

@:final
@:access(haxe.macro.TypeTools)
class InterfaceBuilder
{

  #if macro

  @:isVar
  static var realTypes(get, set):StringMap<Type>;

  static function set_realTypes(value:StringMap<Type>):StringMap<Type>
  {
    return realTypes = value;
  }

  static function get_realTypes():StringMap<Type>
  {
    if (realTypes == null)
    {
      Context.onGenerate(
        function(allType)
        {
          realTypes = null;
        });
      return realTypes = new StringMap<Type>();
    }
    else
    {
      return realTypes;
    }
  }
  #end

  macro public static function getRealType(fullyTypeName:String):Type return
  {
    realTypes.get(fullyTypeName);
  }

  /**
    为类型添加`implements ICommand`

    例如，`@:genericBuild(com.qifun.sun.entity.CommandBuilder.build()) class MyCommand {}`会生成
    `class MyCommand_Hacked extends MyCommand implements ICommand`。
  **/
  macro public static function build(interfacePath:String):Type return
  {
    var localType = Context.getLocalType();
    switch (localType)
    {
      case TInst(_.get() => classType, []):
      {
        switch (classType)
        {
          case { module: module, pack: pack, name: name, pos: pos, superClass: superClass, } :
          {
            var fullyTypeName = '$module.$name';
            if (!realTypes.exists(fullyTypeName))
            {
              var interfaceTypePath = switch (MacroStringTools.toComplex(interfacePath))
              {
                case TPath(p): p;
                default: throw "Expect TPath";
              }
              Context.defineModule(
                module,
                [
                  {
                    meta: [ { pos: pos, name: ":nativeGen", params: [], }, ],
                    pack: pack,
                    name: '${name}_Hacked',
                    pos: pos,
                    fields:
                    [
                    ],
                    kind: TDClass(
                      {
                        pack: [ "haxe", "macro" ],
                        name: "MacroType",
                        params: [ TPExpr(macro com.qifun.util.InterfaceBuilder.getRealType($v{fullyTypeName})) ],
                      },
                      [
                        interfaceTypePath
                      ])
                  }
                ]);
              realTypes.set(fullyTypeName, localType);
            }
            ComplexTypeTools.toType(TPath(
              {
                pack: pack,
                name: module.substring(module.lastIndexOf(".") + 1),
                sub: name + "_Hacked",
              }));
          }
        }
      }
      default:
      {
        throw "Unreachable code!";
      }
    }
  }

}
