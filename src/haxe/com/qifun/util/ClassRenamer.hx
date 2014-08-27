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

class ClassRenamer
{

  #if macro

  public static function addPrefix(prefix:Null<String>):Array<Field> return
  {
    if (prefix != null)
    {
      var localClass = Context.getLocalClass().get();
      var nativePack = switch (localClass.pack)
      {
        case []: "haxe.root";
        case p: p.join(".");
      }
      var nativeName = '$nativePack.$prefix${localClass.name}';
      localClass.meta.add(":native", [ macro $v{nativeName} ], Context.currentPos());
    }
    return Context.getBuildFields();
  }
  #end

}

// vim: et sts=2 sw=2

