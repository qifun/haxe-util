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
