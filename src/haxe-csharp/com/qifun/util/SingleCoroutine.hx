package com.qifun.util;
#if unity
import dotnet.system.collections.IEnumerator;
import unityengine.MonoBehaviour;
import unityengine.WaitForEndOfFrame;
import unityengine.WaitForFixedUpdate;
import unityengine.WaitForSeconds;

@:final
@:nativeGen
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class SingleCoroutine
{

  function new(completeFunction:Void->Void)
  {
    this.completeFunction = completeFunction;
  }

  var completeFunction:Void->Void;

  function complete():Void
  {
    completeFunction();
  }

  @:functionCode('
    yield return element;
    complete();
  ')
  function singleElementEnumerator(element:Dynamic):IEnumerator return null;

  @:noUsing
  public static function yield(monoBehaviour:MonoBehaviour, element:Dynamic, completeFunction:Void->Void):Void
  {
    monoBehaviour.StartCoroutine_Auto(cast new SingleCoroutine(completeFunction).singleElementEnumerator(element));
  }

  @:noUsing
  @:async
  public static function waitForUpdate(monoBehaviour:MonoBehaviour):Void
  {
    @await yield(monoBehaviour, null);
  }

  static var WAIT_FOR_END_OF_FRAME(default, never) = new WaitForEndOfFrame();

  @:noUsing
  @:async
  public static function waitForEndOfFrame(monoBehaviour:MonoBehaviour):Void
  {
    @await yield(monoBehaviour, WAIT_FOR_END_OF_FRAME);
  }

  static var WAIT_FOR_FIXED_UPDATE(default, never) = new WaitForFixedUpdate();

  @:noUsing
  @:async
  public static function waitForFixedUpdate(monoBehaviour:MonoBehaviour):Void
  {
    @await yield(monoBehaviour, WAIT_FOR_FIXED_UPDATE);
  }

  @:noUsing
  @:async
  public static function waitForSeconds(monoBehaviour:MonoBehaviour, seconds:Single):Void
  {
    @await yield(monoBehaviour, new WaitForSeconds(seconds));
  }

}
#end
