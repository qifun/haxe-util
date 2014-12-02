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
import haxe.unit.TestCase;

@:final
class Final<Left> extends Pair<Left, String>
{
}

class Pair<Left, Right> implements IEntity
{
  var left:Left;
  var right:Right;

  public function new(left:Left, right:Right)
  {
    this.left = left;
    this.right = right;
  }

}

class EqualsAndHashCodeTest extends TestCase
{
  function testPair()
  {
    #if java
    assertTrue(new Final(1, "xx").equals(new Final(1, "xx")));
    assertEquals(new Final(1, "xx").hashCode(), new Final(1, "xx").hashCode());
    #elseif cs
    assertTrue(new Final(1, "xx").Equals(new Final(1, "xx")));
    assertEquals(new Final(1, "xx").GetHashCode(), new Final(1, "xx").GetHashCode());
    #end
  }

}

