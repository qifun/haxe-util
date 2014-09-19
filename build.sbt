organization := "com.qifun"

name := "haxe-util"

version := "0.1.2-SNAPSHOT"

haxeCSharpSettings

haxeJavaSettings

autoScalaLibrary := false

crossPaths := false

haxeOptions in CSharp ++= Seq("-D", "dll")

haxeOptions in TestCSharp ++= Seq("-main", "com.qifun.util.Main")

testFrameworks += new TestFramework("com.qifun.haxeUnit.HaxeUnitFramework")

homepage := Some(url(s"https://github.com/qifun/${name.value}"))

startYear := Some(2014)

licenses := Seq("Apache License, Version 2.0" -> url("http://www.apache.org/licenses/LICENSE-2.0.html"))

publishTo <<= (isSnapshot) { isSnapshot: Boolean =>
  if (isSnapshot)
    Some("snapshots" at "https://oss.sonatype.org/content/repositories/snapshots")
  else
    Some("releases" at "https://oss.sonatype.org/service/local/staging/deploy/maven2")
}

scmInfo := Some(ScmInfo(
  url(s"https://github.com/qifun/${name.value}"),
  s"scm:git:git://github.com/qifun/${name.value}.git",
  Some(s"scm:git:git@github.com:qifun/${name.value}.git")))

pomExtra :=
  <developers>
    <developer>
      <id>Atry</id>
      <name>Ñî²©</name>
      <timezone>+8</timezone>
      <email>pop.atry@gmail.com</email>
    </developer>
  </developers>
