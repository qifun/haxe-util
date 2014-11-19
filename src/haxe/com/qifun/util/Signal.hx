package com.qifun.util;

import haxe.macro.Context;
import haxe.macro.TypeTools;
import haxe.macro.Expr;

private class Subscriber<F:haxe.Constraints.Function> implements ISubscriber<F>
{

  var functions:Array<F> = [];

  public inline function new() { }

  public inline function subscribe(f:F):Void
  {
    functions.push(f);
  }

  public inline function unsubscribe(f:F):Void
  {
    functions.remove(f);
  }

}

@:genericBuild(com.qifun.util.Signal.SignalBuilder.build())
class Signal<F:haxe.Constraints.Function> extends Subscriber<F> {}

#if macro
class SignalBuilder
{
  public static function build():ComplexType return
  {
    switch (Context.getLocalType())
    {
      case TInst(
        _,
        [
          Context.follow(_) => TFun(
            args,
            Context.follow(_) => TAbstract(_.get() => { module: "StdTypes", name: "Void" }, []))
        ]):
      {
        TPath(
        {
          pack: [ "com", "qifun", "util" ],
          name: "Signal",
          sub: 'Signal${args.length}',
          params: [ for (arg in args) TPType(TypeTools.toComplexType(arg.t)) ],
        });
      }
      default:
      {
        throw Context.error("Expect Signal<?->Void>", Context.currentPos());
      }
    }
  }
}
#end

@:dox(hide)
class Signal0 extends Subscriber<Void->Void>
{

  public inline function publish():Void
  {
    for (f in functions)
    {
      f();
    }
  }

}

@:dox(hide)
class Signal1<Event0> extends Subscriber<Event0->Void>
{

  public inline function publish(event0:Event0):Void
  {
    for (f in functions)
    {
      f(event0);
    }
  }

}

@:dox(hide)
class Signal2<Event0, Event1> extends Subscriber<Event0->Event1->Void>
{

  public inline function publish(event0:Event0, event1:Event1):Void
  {
    for (f in functions)
    {
      f(event0, event1);
    }
  }

}

