package com.qifun.util;

/**
  实现本接口的类会为Java平台和C#平台自动创建哈希函数和比较函数，
  以便用于比较或查表。
**/
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
