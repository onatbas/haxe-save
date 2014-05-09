﻿package org.ascrypt.encoding;

/**
* Converts bytes and text in UTF-8 encoding.
* @author Mika Palmu
*/
class UTF8
{
	/**
	* Converts text to an array of bytes.
	* @param text An ASCII or UTF-8 encoded string.
	* @return An array of single byte values.
	*/
	public static function textToBytes(text:String):Array<Int>
	{
		var l:Int = text.length;
		var c:Int, p:Int = 0, b:Array<Int> = [];
		for (i in 0...l)
		{
			c = text.charCodeAt(i);
			if (c <= 0x07F)
			{
				b[p] = c;
				p++;
			}
			else if (c <= 0x07FF)
			{
				b[p] = (c >>> 6) | 0x0C0;
				b[p + 1] = (c & 0x03F) | 0x080;
				p += 2;
			}
			else if (c <= 0x0FFFF)
			{
				b[p] = (c >>> 12) | 0x0E0;
				b[p + 1] = ((c >>> 6 ) & 0x03F) | 0x080;
				b[p + 2] = (c & 0x03F) | 0x080;
				p += 3;
			}
			else if (c <= 0x010FFFF)
			{
				b[p] = (c >>> 18) | 0x0F0;
				b[p + 1] = ((c >>> 12) & 0x03F) | 0x080;
				b[p + 2] = ((c >>> 6 ) & 0x03F) | 0x080;
				b[p + 3] = (c & 0x03F) | 0x080;
				p += 4;
			}
		}
		return b;
	}
	
	/**
	* Converts an array of bytes to text.
	* @param bytes An array of single byte values.
	* @return An ASCII or UTF-8 encoded string.
	*/
	public static function bytesToText(bytes:Array<Int>):String
	{
		var i:Int = 0;
		var l:Int = bytes.length;
		var c:Int, s:String = "";
		while (i < l)
		{
			c = 0;
			if ((bytes[i] & 0x080) != 0x080)
			{
				c = bytes[i];
			}
			else if ((bytes[i] & 0x0F0) == 0x0F0)
			{
				c |= (bytes[i] & 0x007) << 18;
				c |= (bytes[i + 1] & 0x03F) << 12;
				c |= (bytes[i + 2] & 0x03F) << 6;
				c |= (bytes[i + 3] & 0x03F);
				i += 3;
			}
			else if ((bytes[i] & 0x0E0) == 0x0E0)
			{
				c |= ((bytes[i] & 0x00F) << 12);
				c |= ((bytes[i + 1] & 0x03F) << 6);
				c |= (bytes[i + 2] & 0x03F);
				i += 2;
			}
			else if ((bytes[i] & 0x0C0) == 0x0C0)
			{
				c |= (bytes[i] & 0x01F) << 6;
				c |= (bytes[i + 1] & 0x03F);
				i++;
			}
			s += String.fromCharCode(c);
			i++;
		}
		return s;
	}

}
