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

import haxe.ds.List;
import haxe.Timer;
import haxe.PosInfos;

/**
 * A class representing an algorithm.
 *
 * @author Yann Spoeri
 */
abstract class Algorithm
{
    /**
     * The name of the algorithm.
     */
    private var mAlgorithmName:String;

    /**
     * A timestamp representing the time this algorithm was called.
     */
    private var mStartTime:Float;
    
    /**
     * A timestamp representing the time this algorithm finished calculation.
     */
    private var mEndTime:Float;
    
    /**
     * All log entries occurred during calculation of this algorithm.
     */
    public var mLog:List<LogEntry>;
    
    /**
     * The name of the algorithm.
     */
    public function new(algorithmName:String) {
        mAlgorithmName = algorithmName;
    }
    
    /**
     * Log a log entry.
     */
    public function logLogEntry(le:LogEntry):Void {
        if (mLog == null) {
            mLog = new List<LogEntry>();
        }
        mLog.add(le);
    }
    
    /**
     * Log something by data.
     */
    public function log(logLevel:Int, str:String, ?pos:PosInfos):Void {
        var timestamp:Float = Timer.stamp();
        var lineNr:Int = pos.lineNumber;
        var methodName:String = pos.methodName;
        var fileName:String = pos.fileName;
        var className:String = pos.className;
        var le:LogEntry = new LogEntry(timestamp, logLevel, lineNr, methodName, fileName, className, str);
        logLogEntry(le);
    }
    
    /**
     * Get all log entries.
     */
    public function getAllLogEntries():List<LogEntry> {
        var copy:List<LogEntry> = new List<LogEntry>();
        for (e in mLog) {
            copy.add(e);
        }
        return copy;
    }
    
    /**
     * Calculate the algorithm.
     */
    public abstract function calculate(input:Dynamic):Dynamic;
    
    /**
     * Call a particular algorithm.
     */
    public function call(input:Dynamic):Dynamic {
        mStartTime = Timer.stamp();
        try {
            log(LogEntry.NOTE, "Start calculating algorithm " + mAlgorithmName);
            return calculate(input);
        } catch(e) {
            mEndTime = Timer.stamp();
            throw e;
        }
        mEndTime = Timer.stamp();
        return null;
    }
}