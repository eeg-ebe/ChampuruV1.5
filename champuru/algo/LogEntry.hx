/**
 * Copyright (c) 2023 Université libre de Bruxelles, eeg-ebe Department, Yann Spöri
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
package champuru.algo;

import haxe.Timer;
import haxe.PosInfos;

/**
 * A class representing a LogEntry.
 * 
 * @author Yann Spoeri
 */
class LogEntry
{
    @:final public static var FATAL:Int = 10;
    @:final public static var ERROR:Int = 9;
    @:final public static var WARNING_CRITICAL:Int = 8;
    @:final public static var WARNING:Int = 7;
    @:final public static var WARNING_MINOR:Int = 6;
    @:final public static var SUSPICIOUS:Int = 5;
    @:final public static var ALERT:Int = 4;
    @:final public static var MESSAGE:Int = 3;
    @:final public static var NOTE:Int = 2;
    @:final public static var DEBUG:Int = 1;
    @:final public static var ALL:Int = 0;
    
    /**
     * The timestamp when this log output was logged.
     */
    private var mTimestamp:Float;
    
    /**
     * The log level of this log entry.
     */
    private var mLogLevel:Int;
    
    /**
     * The line where this logEntry was created.
     */
    private var mLineNr:Int;
    
    /**
     * The method name.
     */
    private var mMethodName:String;
    
    /**
     * The file name.
     */
    private var mFileName:String;
    
    /**
     * The class name.
     */
    private var mClassName:String;
    
    /**
     * The string that was logged.
     */
    private var mStr:String;
    
    /**
     * Createa new log entry.
     */
    public inline function new(timestamp:Float, logLevel:Int, lineNr:Int, methodName:String, fileName:String, className:String, str:String) {
        mTimestamp = timestamp;
        mLogLevel = logLevel;
        mLineNr = lineNr;
        mMethodName = methodName;
        mFileName = fileName;
        mClassName = className;
        mStr = str;
    }
    
    /**
     * Return the timestamp of this log entry.
     */
    public inline function getTimestamp():Float {
        return mTimestamp;
    }
    
    /**
     * Return the loglevel of this log entry.
     */
    public inline function getLogLevel():Int {
        return mLogLevel;
    }
    
    /**
     * Return the line number where this log entry was logged.
     */
    public inline function getLineNr():Int {
        return mLineNr;
    }
    
    /**
     * Return the method name where this log entry was logged.
     */
    public inline function getMethodName():String {
        return mMethodName;
    }
    
    /**
     * Return the name of the file where this log entry was logged.
     */
    public inline function getFileName():String {
        return mFileName;
    }
    
    /**
     * Return the class of the file where this log entry was logged.
     */
    public inline function getClassName():String {
        return mClassName;
    }
    
    /**
     * Get the string that was logged.
     */
    public inline function getStr():String {
        return mStr;
    }
}