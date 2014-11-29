package com.qifun.util;

import haxe.macro.*;

class DefinedValue
{

  macro public static function get(name:String):Expr return
  {
    Context.makeExpr(Context.definedValue("ast_export"), PositionTools.here());
  }
  
}