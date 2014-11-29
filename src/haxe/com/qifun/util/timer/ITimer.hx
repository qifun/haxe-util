package com.qifun.util.timer;

import com.qifun.util.ISubscriber;

@:nativeGen
interface ITimer
{
  
  /**
    Tween启动后，经过的时间。只能用于数值计算，不得用于刷新显示。
  **/
  public var elapsedMilliseconds(get, never):Int;

  private function get_elapsedMilliseconds():Int;
  
  public var durationMilliseconds(get, never):Int;

  private function get_durationMilliseconds():Int;

  function run(interruptSubscriber:ISubscriber<Void->Void>, expiredCallback:Void->Void):Void;

}
