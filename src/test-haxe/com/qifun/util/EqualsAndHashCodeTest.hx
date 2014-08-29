package com.qifun.util;
import haxe.unit.TestCase;

@:final
class Final<Left> extends Pair<Left, String>
{
}

#if java
@:autoBuild(com.qifun.util.HashCodeBuilder.build("hashCode"))
@:autoBuild(com.qifun.util.EqualsBuilder.build("equals"))
#elseif cs
@:autoBuild(com.qifun.util.HashCodeBuilder.build("GetHashCode"))
@:autoBuild(com.qifun.util.EqualsBuilder.build("Equals"))
#end
@:nativeGen
interface IEntity #if java extends java.internal.IEquatable #end
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
