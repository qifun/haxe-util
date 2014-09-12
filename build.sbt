organization := "com.qifun"

name := "haxe-util"

version := "0.1.0-SNAPSHOT"

haxeCSharpSettings

haxeJavaSettings

for (c <- Seq(CSharp, TestCSharp)) yield {
  haxeOptions in c ++= Seq("-D", "dll")
}

