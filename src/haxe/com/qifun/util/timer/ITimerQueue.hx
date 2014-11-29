package com.qifun.util.timer;

@:nativeGen
interface ITimerQueue
{

  //这个只会expire
  public function newOneshotTimer(durationMilliseconds:Int):ITimer;

  //这个每帧会更新
  public function newIntervalTimer(durationMilliseconds:Int, updater:ITimerUpdater):ITimer;

}