package com.qifun.util.timer;

@:nativeGen
interface ITimerUpdater
{

  #if cs
  function update(elapsedSecond:Single, durationSeconds:Single):Void;
  #end

  function fixedUpdate(elapsedMillisecond:Int, durationMilliseconds:Int):Void;

}