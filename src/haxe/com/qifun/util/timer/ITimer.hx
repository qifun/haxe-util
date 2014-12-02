package com.qifun.util.timer;

import com.qifun.util.ISubscriber;

@:nativeGen
interface ITimer
{

  function run(interruptSubscriber:ISubscriber<Void->Void>, expiredCallback:Void->Void):Void;

}
