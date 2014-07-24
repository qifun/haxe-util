package com.qifun.locale;
import haxe.macro.*;
import haxe.macro.Expr;

typedef Translation = Iterable<{ var source(default, never):String; var translated(default, never):String; }>;

class Translator {

	#if run_time_translation
	public static var runTimeLocale:Null<String>;
	#end

	macro public static function translate(self:ExprOf<String>):ExprOf<String> return {
		#if run_time_translation
		runTimeTranslate(self, defaultDictionary, macro com.qifun.locale.Translator.runTimeLocale);
		#else
		compileTimeTranslate(self, defaultDictionary, Context.definedValue("locale"));
		#end
	}
	#if macro

	@:access(haxe.format.JsonParser)
	static function readJsonFile(file:String):Dynamic return {
		var path = Context.resolvePath(file);
		var content = sys.io.File.getContent(path);
		var parser = new haxe.format.JsonParser(content);
		try {
			parser.parseRec();
		} catch (e:Dynamic) {
			Context.error(Std.string(e), Context.makePosition({ min: parser.pos, max: parser.pos, file: path }));
		}
	}

	static function merge(dictionary:Map<String, Map<String, String>>, locale:String, translation:Translation):Void {
		var map = dictionary.get(locale);
		if (map == null) {
			map = new Map<String, String>();
			dictionary.set(locale, map);
		}
		for (entry in translation) {
			map.set(entry.source, entry.translated);
		}
	}

	static var defaultDictionary(default, never) = {
		var d = new Map<String, Map<String, String>>();
		merge(d, "zh_CN.GBK", readJsonFile("com/qifun/locale/translation.zh_CN.GBK.json"));
		d;
	}

	@:noUsing
	public static function addTranslationFile(locale:String, translationFile:String):Void {
		addTranslation(locale, readJsonFile(translationFile));
	}

	@:noUsing
	public static function addTranslation(locale:String, translation:Translation):Void {
		merge(defaultDictionary, locale, translation);
	}

	@:noUsing
	public static function compileTimeTranslate(text:ExprOf<String>, dictionary:Map<String, Map<String, String>>, locale:Null<String>):ExprOf<String> return {
		if (locale == null) {
			text;
		} else {
			switch (text) {
				case { expr: EConst(CString(source)) }:
					var mapping = dictionary.get(locale);
					if (mapping == null) {
						text;
					} else {
						var translated = mapping.get(source);
						if (translated == null) {
							text;
						} else {
							if (MacroStringTools.isFormatExpr(text)) {
								MacroStringTools.formatString(translated, Context.currentPos());
							} else {
								Context.makeExpr(translated, Context.currentPos());
							}
						}
					}
				case { expr: EMeta({ name: ":this", params: []}, {expr: EConst(CIdent("this")) }), pos: p }:
					Context.error(translate("Using mix-in macro is not supported"), p);
				case { pos: p }:
					Context.error(translate("Expect a string literal"), p);
			}
		}
	}

	@:noUsing
	public static function runTimeTranslate(text:ExprOf<String>, dictionary:Map<String, Map<String, String>>, locale:ExprOf<String>):ExprOf<String> return {
		pos: Context.currentPos(),
		expr: ESwitch(
			locale,
			[
				for (locale in dictionary.keys()) {
					values: [ macro $v{locale} ],
					expr: compileTimeTranslate(text, dictionary, locale),
				}
			],
			text)
	}

	#end
}

