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
import haxe.macro.Expr;

class Patcher
{

  #if macro

  public static function noExternalDoc():Void return
  {
    if (Context.defined("doc_gen"))
    {
      Context.onGenerate(function(types)
      {
        for (t in types)
        {
          switch (t)
          {
            case TInst(_.get() => baseType, _):
            {
              if (baseType.isExtern)
              {
                baseType.meta.add(":noDoc", [], baseType.pos);
              }
            }
            default:
            {
              continue;
            }
          }
        }
      });
    }
  }
  #end

}

// vim: et sts=2 sw=2

