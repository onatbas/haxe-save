package com.onatbas.utils;
/**
 * @author Onat Baş
 * 16.02.2014
 *
 * */

import String;
import org.ascrypt.common.OperationMode;
import org.ascrypt.encoding.UTF8;
import org.ascrypt.padding.PKCS7;
import org.ascrypt.AES;
import org.ascrypt.Base16;
import flash.net.SharedObjectFlushStatus;
import flash.net.SharedObject;
class EncryptedSharedObjectWrapper
{
    private var AES_KEY:Array<Int>;
    private var AES_ITERATE_VECTOR:Array<Int>;

    private var sharedObject:SharedObject;

    /**
    *
    *
    * */

    public function new(objName:String = "status", 
                        path:String = "content", 
                        aesKey:String = "X2TBMINZRJCQ882QPEMRKKI4RWS48ULF", 
                        iterateVector:String = "BYSBT5O7M6ZTIOY5")
    {
        initSharedObject(objName, path);
        initKeys(aesKey, iterateVector);
    }

    private function initSharedObject(objName:String, path:String):Void
    {
        sharedObject = SharedObject.getLocal(objName, path);
    }

    public function setData(id:String, value:String):Void
    {
        Reflect.setField(sharedObject.data, id, encrypt(value));
    }

    public function getData(id:String):String
    {
        var dynamicData = Reflect.field(sharedObject.data, id);
        if (dynamicData == null) return null;
        return decrypt(Std.string(dynamicData));
    }

    public function save():Void
    {
        #if ( cpp || neko )
        var flushStatus:SharedObjectFlushStatus = null;
        #else
        var flushStatus:String = null; // flash uses strings as status.
        #end

        try
        {
            flushStatus = sharedObject.flush(); // Save the object
        } catch (e:Dynamic)
        {
            trace("couldn\'t write...");
        }

        if (flushStatus != null)
        {
            switch( flushStatus ) {
                case SharedObjectFlushStatus.PENDING:
                    trace("requesting permission to save");
                case SharedObjectFlushStatus.FLUSHED:
                    trace("value saved");
            }
        }
    }

    /**
    *
    *
    * The default values are put for testing purposes, in final build, you should
    * replace them with your values.
    *
    *
    * */

    private function initKeys(aesKey:String, iterateVector:String):Void
    {
        AES_KEY = UTF8.textToBytes(aesKey);
        AES_ITERATE_VECTOR = UTF8.textToBytes(iterateVector);
    }

    /**
    * @private
    */
    public function encrypt(value:String):String
    {
        return Base16.encode(AES.encrypt(AES_KEY, PKCS7.pad(UTF8.textToBytes(value), 16), OperationMode.CTR,
                                         AES_ITERATE_VECTOR));
    }

    /**
    * @private
    */
    public function decrypt(value:String):String
    {
        return UTF8.bytesToText(PKCS7.unpad(AES.encrypt(AES_KEY, Base16.decode(value), OperationMode.CTR,
                                                        AES_ITERATE_VECTOR)));
    }
}
