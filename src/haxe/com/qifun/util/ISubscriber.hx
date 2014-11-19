package com.qifun.util;

interface ISubscriber<F:haxe.Constraints.Function>
{
  function subscribe(f:F):Void;
  function unsubscribe(f:F):Void;
}