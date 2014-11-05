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

import haxe.ds.Vector;

/*
  梅森旋转算法伪随机数生成器(The Mersenne Twister pseudo-random number generator)
  论文：http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/ARTICLES/mt.pdf
  @author 张修羽
*/
class Random
{
  private static var SIZE(default, null):UInt = 624; 
  
  private static var PERIOD(default, null):UInt = 397; 
  
  private static var DIFF(default, null):UInt = SIZE - PERIOD;
  
  private static inline function isOdd(n:UInt):UInt return n & 1;
  
  private static inline function m32(n:UInt):UInt return 0x80000000 & n;
  
  private static inline function l31(n:UInt):UInt return 0x7FFFFFFF & n;
  
  private var mersenneTwister:Vector<UInt> = new Vector<UInt>(SIZE);
  
  private var index:Int;
  
  public function new(seed:Int):Void return
  {
    resetSeed(seed);
  }
  

  
  public function generate_numbers():Void
  {
    var m:Array<UInt> = [0, 0x9908b0df];
    var i:Int = -1;
    var y:Int;
    
    
    while (++i < DIFF)
    {
      y = m32(mersenneTwister.get(i)) | l31(mersenneTwister.get(i + 1));
      mersenneTwister.set(i, mersenneTwister.get(i + PERIOD) ^ (y >> 1) ^ m[isOdd(y)]);
    }

    function unroll()
    {
      y = m32(mersenneTwister.get(i)) | l31(mersenneTwister.get(i + 1));
      mersenneTwister.set(i, mersenneTwister.get(i - DIFF) ^ (y >> 1) ^ m[isOdd(y)]);
    }
    
    i = DIFF;
    while (++i < SIZE - 1) 
    {
      var j:Int = 0;
      while (++j < 11)
      {
        unroll();
      }
    }

    // i = [623]
    y = m32(mersenneTwister.get(SIZE - 1)) | l31(mersenneTwister.get(SIZE - 1));
    mersenneTwister.set(SIZE - 1, mersenneTwister.get(PERIOD - 1) ^ (y >> 1) ^ m[isOdd(y)]);
  }
  
  public function resetSeed(seed:Int):Void return
  {
    mersenneTwister.set(0, seed);
    index = 0;
    var i = 1;
    while (i < SIZE)
    {
      mersenneTwister.set(i, 0x6c078965 * (mersenneTwister.get(i - 1) ^ mersenneTwister.get(i - 1) >> 30) + i);
      ++i;
    }
  }

  public function rand():Int return {
    
    if (index == 0)
      generate_numbers();

    var res:UInt = mersenneTwister[index];

    res ^= res >> 11;
    res ^= res << 7 & 0x9d2c5680;
    res ^= res << 15 & 0xefc60000;
    res ^= res >> 18;

    if ( ++index == SIZE )
      index = 0;
    return 0x7FFFFFFF & res;
  }
}
