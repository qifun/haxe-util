/*
 * haxe-util
 * Copyright 2014 深圳岂凡网络有限公司 (Shenzhen QiFun Network Corp., LTD)
 *
 * Author: 杨博 (Yang Bo) <pop.atry@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.qifun.util.locale ;
import haxe.macro.*;
import haxe.macro.Expr;

typedef Translation = Iterable<{ var source(default, never):String; var translated(default, never):String; }>;

class Translator {

	#if run_time_translation
	public static var runTimeLocale:Null<String>;
	#end

	macro public static function translate(self:ExprOf<String>):ExprOf<String> return {
		#if run_time_translation
		runTimeTranslate(self, defaultDictionary, macro com.qifun.util.locale.Translator.runTimeLocale);
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
		merge(d, "zh_CN.GBK", readJsonFile("com/qifun/util/locale/translation.zh_CN.GBK.json"));
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


