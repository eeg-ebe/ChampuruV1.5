import sys

import math as python_lib_Math
import math as Math
import inspect as python_lib_Inspect
import sys as python_lib_Sys
import functools as python_lib_Functools
import random as python_lib_Random
import time as python_lib_Time
import timeit as python_lib_Timeit
import traceback as python_lib_Traceback
from io import StringIO as python_lib_io_StringIO
from threading import Semaphore as Lock
from threading import RLock as sys_thread__Mutex_NativeRLock
import threading


class _hx_AnonObject:
    _hx_disable_getattr = False
    def __init__(self, fields):
        self.__dict__ = fields
    def __repr__(self):
        return repr(self.__dict__)
    def __contains__(self, item):
        return item in self.__dict__
    def __getitem__(self, item):
        return self.__dict__[item]
    def __getattr__(self, name):
        if (self._hx_disable_getattr):
            raise AttributeError('field does not exist')
        else:
            return None
    def _hx_hasattr(self,field):
        self._hx_disable_getattr = True
        try:
            getattr(self, field)
            self._hx_disable_getattr = False
            return True
        except AttributeError:
            self._hx_disable_getattr = False
            return False



class Enum:
    _hx_class_name = "Enum"
    __slots__ = ("tag", "index", "params")
    _hx_fields = ["tag", "index", "params"]
    _hx_methods = ["__str__"]

    def __init__(self,tag,index,params):
        self.tag = tag
        self.index = index
        self.params = params

    def __str__(self):
        if (self.params is None):
            return self.tag
        else:
            return self.tag + '(' + (', '.join(str(v) for v in self.params)) + ')'



class Class: pass


class Reflect:
    _hx_class_name = "Reflect"
    __slots__ = ()
    _hx_statics = ["field"]

    @staticmethod
    def field(o,field):
        return python_Boot.field(o,field)


class Std:
    _hx_class_name = "Std"
    __slots__ = ()
    _hx_statics = ["isOfType", "string", "parseInt"]

    @staticmethod
    def isOfType(v,t):
        if ((v is None) and ((t is None))):
            return False
        if (t is None):
            return False
        if ((type(t) == type) and (t == Dynamic)):
            return (v is not None)
        isBool = isinstance(v,bool)
        if (((type(t) == type) and (t == Bool)) and isBool):
            return True
        if ((((not isBool) and (not ((type(t) == type) and (t == Bool)))) and ((type(t) == type) and (t == Int))) and isinstance(v,int)):
            return True
        vIsFloat = isinstance(v,float)
        tmp = None
        tmp1 = None
        if (((not isBool) and vIsFloat) and ((type(t) == type) and (t == Int))):
            f = v
            tmp1 = (((f != Math.POSITIVE_INFINITY) and ((f != Math.NEGATIVE_INFINITY))) and (not python_lib_Math.isnan(f)))
        else:
            tmp1 = False
        if tmp1:
            tmp1 = None
            try:
                tmp1 = int(v)
            except BaseException as _g:
                None
                tmp1 = None
            tmp = (v == tmp1)
        else:
            tmp = False
        if ((tmp and ((v <= 2147483647))) and ((v >= -2147483648))):
            return True
        if (((not isBool) and ((type(t) == type) and (t == Float))) and isinstance(v,(float, int))):
            return True
        if ((type(t) == type) and (t == str)):
            return isinstance(v,str)
        isEnumType = ((type(t) == type) and (t == Enum))
        if ((isEnumType and python_lib_Inspect.isclass(v)) and hasattr(v,"_hx_constructs")):
            return True
        if isEnumType:
            return False
        isClassType = ((type(t) == type) and (t == Class))
        if ((((isClassType and (not isinstance(v,Enum))) and python_lib_Inspect.isclass(v)) and hasattr(v,"_hx_class_name")) and (not hasattr(v,"_hx_constructs"))):
            return True
        if isClassType:
            return False
        tmp = None
        try:
            tmp = isinstance(v,t)
        except BaseException as _g:
            None
            tmp = False
        if tmp:
            return True
        if python_lib_Inspect.isclass(t):
            cls = t
            loop = None
            def _hx_local_1(intf):
                f = (intf._hx_interfaces if (hasattr(intf,"_hx_interfaces")) else [])
                if (f is not None):
                    _g = 0
                    while (_g < len(f)):
                        i = (f[_g] if _g >= 0 and _g < len(f) else None)
                        _g = (_g + 1)
                        if (i == cls):
                            return True
                        else:
                            l = loop(i)
                            if l:
                                return True
                    return False
                else:
                    return False
            loop = _hx_local_1
            currentClass = v.__class__
            result = False
            while (currentClass is not None):
                if loop(currentClass):
                    result = True
                    break
                currentClass = python_Boot.getSuperClass(currentClass)
            return result
        else:
            return False

    @staticmethod
    def string(s):
        return python_Boot.toString1(s,"")

    @staticmethod
    def parseInt(x):
        if (x is None):
            return None
        try:
            return int(x)
        except BaseException as _g:
            None
            base = 10
            _hx_len = len(x)
            foundCount = 0
            sign = 0
            firstDigitIndex = 0
            lastDigitIndex = -1
            previous = 0
            _g = 0
            _g1 = _hx_len
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                c = (-1 if ((i >= len(x))) else ord(x[i]))
                if (((c > 8) and ((c < 14))) or ((c == 32))):
                    if (foundCount > 0):
                        return None
                    continue
                else:
                    c1 = c
                    if (c1 == 43):
                        if (foundCount == 0):
                            sign = 1
                        elif (not (((48 <= c) and ((c <= 57))))):
                            if (not (((base == 16) and ((((97 <= c) and ((c <= 122))) or (((65 <= c) and ((c <= 90))))))))):
                                break
                    elif (c1 == 45):
                        if (foundCount == 0):
                            sign = -1
                        elif (not (((48 <= c) and ((c <= 57))))):
                            if (not (((base == 16) and ((((97 <= c) and ((c <= 122))) or (((65 <= c) and ((c <= 90))))))))):
                                break
                    elif (c1 == 48):
                        if (not (((foundCount == 0) or (((foundCount == 1) and ((sign != 0))))))):
                            if (not (((48 <= c) and ((c <= 57))))):
                                if (not (((base == 16) and ((((97 <= c) and ((c <= 122))) or (((65 <= c) and ((c <= 90))))))))):
                                    break
                    elif ((c1 == 120) or ((c1 == 88))):
                        if ((previous == 48) and ((((foundCount == 1) and ((sign == 0))) or (((foundCount == 2) and ((sign != 0))))))):
                            base = 16
                        elif (not (((48 <= c) and ((c <= 57))))):
                            if (not (((base == 16) and ((((97 <= c) and ((c <= 122))) or (((65 <= c) and ((c <= 90))))))))):
                                break
                    elif (not (((48 <= c) and ((c <= 57))))):
                        if (not (((base == 16) and ((((97 <= c) and ((c <= 122))) or (((65 <= c) and ((c <= 90))))))))):
                            break
                if (((foundCount == 0) and ((sign == 0))) or (((foundCount == 1) and ((sign != 0))))):
                    firstDigitIndex = i
                foundCount = (foundCount + 1)
                lastDigitIndex = i
                previous = c
            if (firstDigitIndex <= lastDigitIndex):
                digits = HxString.substring(x,firstDigitIndex,(lastDigitIndex + 1))
                try:
                    return (((-1 if ((sign == -1)) else 1)) * int(digits,base))
                except BaseException as _g:
                    return None
            return None


class Float: pass


class Int: pass


class Bool: pass


class Dynamic: pass


class StringTools:
    _hx_class_name = "StringTools"
    __slots__ = ()
    _hx_statics = ["htmlEscape", "replace"]

    @staticmethod
    def htmlEscape(s,quotes = None):
        buf_b = python_lib_io_StringIO()
        _g_offset = 0
        _g_s = s
        while (_g_offset < len(_g_s)):
            index = _g_offset
            _g_offset = (_g_offset + 1)
            code = ord(_g_s[index])
            code1 = code
            if (code1 == 34):
                if quotes:
                    buf_b.write("&quot;")
                else:
                    buf_b.write("".join(map(chr,[code])))
            elif (code1 == 38):
                buf_b.write("&amp;")
            elif (code1 == 39):
                if quotes:
                    buf_b.write("&#039;")
                else:
                    buf_b.write("".join(map(chr,[code])))
            elif (code1 == 60):
                buf_b.write("&lt;")
            elif (code1 == 62):
                buf_b.write("&gt;")
            else:
                buf_b.write("".join(map(chr,[code])))
        return buf_b.getvalue()

    @staticmethod
    def replace(s,sub,by):
        _this = (list(s) if ((sub == "")) else s.split(sub))
        return by.join([python_Boot.toString1(x1,'') for x1 in _this])


class Sys:
    _hx_class_name = "Sys"
    __slots__ = ()
    _hx_statics = ["exit", "args", "systemName"]

    @staticmethod
    def exit(code):
        python_lib_Sys.exit(code)

    @staticmethod
    def args():
        argv = python_lib_Sys.argv
        return argv[1:None]

    @staticmethod
    def systemName():
        _g = python_lib_Sys.platform
        x = _g
        if x.startswith("linux"):
            return "Linux"
        else:
            _g1 = _g
            _hx_local_0 = len(_g1)
            if (_hx_local_0 == 5):
                if (_g1 == "win32"):
                    return "Windows"
                else:
                    raise haxe_Exception.thrown("not supported platform")
            elif (_hx_local_0 == 6):
                if (_g1 == "cygwin"):
                    return "Windows"
                elif (_g1 == "darwin"):
                    return "Mac"
                else:
                    raise haxe_Exception.thrown("not supported platform")
            else:
                raise haxe_Exception.thrown("not supported platform")


class haxe_ds_List:
    _hx_class_name = "haxe.ds.List"
    __slots__ = ("h", "q", "length")
    _hx_fields = ["h", "q", "length"]
    _hx_methods = ["add", "push", "last", "clear", "join"]

    def __init__(self):
        self.q = None
        self.h = None
        self.length = 0

    def add(self,item):
        x = haxe_ds__List_ListNode(item,None)
        if (self.h is None):
            self.h = x
        else:
            self.q.next = x
        self.q = x
        _hx_local_0 = self
        _hx_local_1 = _hx_local_0.length
        _hx_local_0.length = (_hx_local_1 + 1)
        _hx_local_1

    def push(self,item):
        x = haxe_ds__List_ListNode(item,self.h)
        self.h = x
        if (self.q is None):
            self.q = x
        _hx_local_0 = self
        _hx_local_1 = _hx_local_0.length
        _hx_local_0.length = (_hx_local_1 + 1)
        _hx_local_1

    def last(self):
        if (self.q is None):
            return None
        else:
            return self.q.item

    def clear(self):
        self.h = None
        self.q = None
        self.length = 0

    def join(self,sep):
        s_b = python_lib_io_StringIO()
        first = True
        l = self.h
        while (l is not None):
            if first:
                first = False
            else:
                s_b.write(Std.string(sep))
            s_b.write(Std.string(l.item))
            l = l.next
        return s_b.getvalue()



class champuru_Worker:
    _hx_class_name = "champuru.Worker"
    __slots__ = ()
    _hx_statics = ["mMsgs", "out", "out2", "timeToStr", "formatFloat", "generateHtml", "printUsageAndExit", "parseArgs", "main"]

    @staticmethod
    def out(s):
        pass

    @staticmethod
    def out2(s):
        _hx_str = Std.string(s)
        python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))

    @staticmethod
    def timeToStr(f):
        return ("" + Std.string(Math.floor(((f * 1000) + 0.5))))

    @staticmethod
    def formatFloat(f):
        number = (f * Math.pow(10,3))
        return ("" + Std.string(((Math.floor((number + 0.5)) / Math.pow(10,3)))))

    @staticmethod
    def generateHtml(fwd,rev,scoreCalculationMethod,iOffset,jOffset,useThisOffsets,searchForAlternativeSolutions):
        champuru_Worker.mMsgs.clear()
        useThisOffsets1 = useThisOffsets
        timestamp = python_lib_Timeit.default_timer()
        perlReimplementationOutput = champuru_perl_PerlChampuruReimplementation.runChampuru(fwd,rev,False)
        output = perlReimplementationOutput.getOutput()
        output = StringTools.htmlEscape(output)
        output = StringTools.replace(output,"\n","<br/>")
        s = (("<div class='timelegend'>Calculation took " + HxOverrides.stringOrNull((("" + Std.string(Math.floor(((((python_lib_Timeit.default_timer() - timestamp)) * 1000) + 0.5))))))) + "ms</div>")
        s1 = champuru_base_NucleotideSequence.fromString(fwd)
        s2 = champuru_base_NucleotideSequence.fromString(rev)
        timestamp = python_lib_Timeit.default_timer()
        lst = champuru_score_ScoreCalculatorList.instance()
        calculator = lst.getScoreCalculator(scoreCalculationMethod)
        scores = calculator.calcOverlapScores(s1,s2)
        sortedScores = champuru_score_ScoreSorter().sort(scores)
        ge = champuru_score_GumbelDistributionEstimator(s1,s2)
        scores1 = haxe_ds_List()
        _g = 0
        while (_g < 20):
            i = _g
            _g = (_g + 1)
            _g1 = 0
            while (_g1 < 100):
                j = _g1
                _g1 = (_g1 + 1)
                s = ge.mSeq1
                copySequence = haxe_ds_List()
                sLen = s.mLength
                _g2 = 0
                _g3 = sLen
                while (_g2 < _g3):
                    i1 = _g2
                    _g2 = (_g2 + 1)
                    randomPos = Math.floor((python_lib_Random.random() * sLen))
                    if (not (((0 <= randomPos) and ((randomPos < s.mLength))))):
                        raise haxe_Exception.thrown((((("Position " + Std.string(randomPos)) + " out of range [0,") + Std.string(s.mLength)) + "("))
                    newNN = s.mSequence.h.get(randomPos,None)
                    copySequence.add(newNN)
                result = champuru_base_NucleotideSequence(copySequence)
                randomFwd = result
                s3 = ge.mSeq2
                copySequence1 = haxe_ds_List()
                sLen1 = s3.mLength
                _g4 = 0
                _g5 = sLen1
                while (_g4 < _g5):
                    i2 = _g4
                    _g4 = (_g4 + 1)
                    randomPos1 = Math.floor((python_lib_Random.random() * sLen1))
                    if (not (((0 <= randomPos1) and ((randomPos1 < s3.mLength))))):
                        raise haxe_Exception.thrown((((("Position " + Std.string(randomPos1)) + " out of range [0,") + Std.string(s3.mLength)) + "("))
                    newNN1 = s3.mSequence.h.get(randomPos1,None)
                    copySequence1.add(newNN1)
                result1 = champuru_base_NucleotideSequence(copySequence1)
                randomRev = result1
                a = -randomFwd.mLength
                b = randomRev.mLength
                result2 = 0
                rand = python_lib_Random.random()
                if (rand > 0.5):
                    result2 = Math.floor((a * python_lib_Random.random()))
                else:
                    result2 = Math.floor((b * python_lib_Random.random()))
                randPos = result2
                score = calculator.calcScore(randPos,randomFwd,randomRev)
                scores1.add(score.score)
        summe = 0.0
        _g_head = scores1.h
        while (_g_head is not None):
            val = _g_head.item
            _g_head = _g_head.next
            score = val
            summe = (summe + score)
        mean = (summe / scores1.length)
        summe = 0.0
        _g_head = scores1.h
        while (_g_head is not None):
            val = _g_head.item
            _g_head = _g_head.next
            score = val
            diff = (score - mean)
            summe = (summe + ((diff * diff)))
        v = (summe / ((scores1.length - 1)))
        deviation = (Math.NaN if ((v < 0)) else python_lib_Math.sqrt(v))
        beta = ((python_lib_Math.sqrt(6) * deviation) / Math.PI)
        mu = (mean - ((champuru_score_GumbelDistribution.eulerMascheroniConst * beta)))
        distribution = champuru_score_GumbelDistribution(mu,beta)
        sortedScoresStringList = haxe_ds_List()
        sortedScoresStringList.add("#\tOffset\tScore\tMatches\tMismatches\tP(score)\tP(higher score)")
        i = 1
        _g = 0
        while (_g < len(sortedScores)):
            score = (sortedScores[_g] if _g >= 0 and _g < len(sortedScores) else None)
            _g = (_g + 1)
            tmp = (((((((((Std.string(i) + "\t") + Std.string(score.index)) + "\t") + Std.string(score.score)) + "\t") + Std.string(score.matches)) + "\t") + Std.string(score.mismatches)) + "\t")
            z = (((score.score - distribution.mMu)) / distribution.mBeta)
            tmp1 = (1.0 / distribution.mBeta)
            v = -z
            v1 = -((z + ((0.0 if ((v == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v))))))
            tmp2 = (0.0 if ((v1 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v1 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v1)))
            s = (-((score.score - distribution.mMu)) / distribution.mBeta)
            v2 = -((0.0 if ((s == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((s == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(s))))
            sortedScoresStringList.add((((("null" if tmp is None else tmp) + Std.string((tmp1 * tmp2))) + "\t") + Std.string(((1 - ((0.0 if ((v2 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v2 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v2)))))))))
            i = (i + 1)
        sortedScoresString = sortedScoresStringList.join("\n")
        sortedScoresStringB64 = haxe_crypto_Base64.encode(haxe_io_Bytes.ofString(sortedScoresString))
        vis = champuru_score_ScoreListVisualizer(scores,sortedScores)
        scorePlot = vis.genScorePlot()
        histPlot = vis.genScorePlotHist(distribution)
        _hx_str = "Best scores:"
        python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        _hx_str = "#\tIndex\tScore\tMatches\tMismatches\tP(score)\tP(higher score)"
        python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        i = 1
        _g = 0
        while (_g < len(sortedScores)):
            score = (sortedScores[_g] if _g >= 0 and _g < len(sortedScores) else None)
            _g = (_g + 1)
            s = (((((((((("<td>" + Std.string(i)) + "</td><td>") + Std.string(score.index)) + "</td><td>") + Std.string(score.score)) + "</td><td>") + Std.string(score.matches)) + "</td><td>") + Std.string(score.mismatches)) + "</td><td>")
            z = (((score.score - distribution.mMu)) / distribution.mBeta)
            f = (1.0 / distribution.mBeta)
            v = -z
            v1 = -((z + ((0.0 if ((v == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v))))))
            number = ((f * ((0.0 if ((v1 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v1 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v1))))) * Math.pow(10,3))
            s3 = ((("null" if s is None else s) + HxOverrides.stringOrNull((("" + Std.string(((Math.floor((number + 0.5)) / Math.pow(10,3)))))))) + "</td><td>")
            s4 = (-((score.score - distribution.mMu)) / distribution.mBeta)
            v2 = -((0.0 if ((s4 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((s4 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(s4))))
            number1 = (((1 - ((0.0 if ((v2 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v2 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v2)))))) * Math.pow(10,3))
            s5 = ((("null" if s3 is None else s3) + HxOverrides.stringOrNull((("" + Std.string(((Math.floor((number1 + 0.5)) / Math.pow(10,3)))))))) + "</td>")
            if (i <= 5):
                s6 = (((((((((("" + Std.string(i)) + "\t") + Std.string(score.index)) + "\t") + Std.string(score.score)) + "\t") + Std.string(score.matches)) + "\t") + Std.string(score.mismatches)) + "\t")
                z1 = (((score.score - distribution.mMu)) / distribution.mBeta)
                f1 = (1.0 / distribution.mBeta)
                v3 = -z1
                v4 = -((z1 + ((0.0 if ((v3 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v3 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v3))))))
                number2 = ((f1 * ((0.0 if ((v4 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v4 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v4))))) * Math.pow(10,3))
                s7 = ((("null" if s6 is None else s6) + HxOverrides.stringOrNull((("" + Std.string(((Math.floor((number2 + 0.5)) / Math.pow(10,3)))))))) + "\t")
                s8 = (-((score.score - distribution.mMu)) / distribution.mBeta)
                v5 = -((0.0 if ((s8 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((s8 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(s8))))
                number3 = (((1 - ((0.0 if ((v5 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v5 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v5)))))) * Math.pow(10,3))
                _hx_str = Std.string((("null" if s7 is None else s7) + HxOverrides.stringOrNull((("" + Std.string(((Math.floor((number3 + 0.5)) / Math.pow(10,3)))))))))
                python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
            i = (i + 1)
        score1 = (sortedScores[0] if 0 < len(sortedScores) else None).index
        score2 = (sortedScores[1] if 1 < len(sortedScores) else None).index
        if useThisOffsets:
            score1 = iOffset
            score2 = jOffset
        useThisOffsets1 = useThisOffsets
        _hx_str = Std.string((((("Using offsets " + Std.string(score1)) + " and ") + Std.string(score2)) + " for calculation."))
        python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        s = (("<div class='timelegend'>Calculation took " + HxOverrides.stringOrNull((("" + Std.string(Math.floor(((((python_lib_Timeit.default_timer() - timestamp)) * 1000) + 0.5))))))) + "ms</div>")
        timestamp = python_lib_Timeit.default_timer()
        o1 = champuru_consensus_OverlapSolver(score1,s1,s2).solve()
        o2 = champuru_consensus_OverlapSolver(score2,s1,s2).solve()
        _hx_str = "Consensus sequence calculation:"
        python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        result = haxe_ds_List()
        _g = 0
        _g1 = o1.mLength
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            c = o1.mSequence.h.get(i,None)
            s = c.toIUPACCode()
            result.add(s)
        s = result.join("")
        result = haxe_ds_List()
        _g = 0
        _g1 = o1.mLength
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            c = o1.mSequence.h.get(i,None)
            s = c.toIUPACCode()
            result.add(s)
        _hx_str = Std.string(("" + HxOverrides.stringOrNull(result.join(""))))
        python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        result = haxe_ds_List()
        _g = 0
        _g1 = o2.mLength
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            c = o2.mSequence.h.get(i,None)
            s = c.toIUPACCode()
            result.add(s)
        s = result.join("")
        result = haxe_ds_List()
        _g = 0
        _g1 = o2.mLength
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            c = o2.mSequence.h.get(i,None)
            s = c.toIUPACCode()
            result.add(s)
        _hx_str = Std.string(("" + HxOverrides.stringOrNull(result.join(""))))
        python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        problems = (o1.countGaps() + o2.countGaps())
        remainingAmbFwd = o1.countPolymorphisms()
        remainingAmbRev = o2.countPolymorphisms()
        if (problems == 1):
            _hx_str = "There is 1 incompatible position (indicated with an underscore), please check the input sequences."
            python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        elif (problems > 1):
            _hx_str = Std.string((("There are " + Std.string(problems)) + " incompatible positions (indicated with underscores), please check the input sequences."))
            python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        tmp = (problems > 0)
        if (remainingAmbFwd == 1):
            _hx_str = "There is 1 ambiguity in the first consensus sequence."
            python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        elif (remainingAmbFwd > 1):
            _hx_str = Std.string((("There are " + Std.string(remainingAmbFwd)) + " ambiguities in the first consensus sequence."))
            python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        if (remainingAmbRev == 1):
            _hx_str = "There is 1 ambiguity in the second consensus sequence."
            python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        elif (remainingAmbRev > 1):
            _hx_str = Std.string((("There are " + Std.string(remainingAmbRev)) + " ambiguities in the second consensus sequence."))
            python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        tmp = ((remainingAmbFwd + remainingAmbRev) > 0)
        s = (("<div class='timelegend'>Calculation took " + HxOverrides.stringOrNull((("" + Std.string(Math.floor(((((python_lib_Timeit.default_timer() - timestamp)) * 1000) + 0.5))))))) + "ms</div>")
        if (problems > 0):
            return _hx_AnonObject({'result': champuru_Worker.mMsgs.join("")})
        timestamp = python_lib_Timeit.default_timer()
        result = champuru_reconstruction_SequenceReconstructor.reconstruct(o1,o2)
        _hx_str = "Sequence reconstruction:"
        python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        _this = result.seq1
        result1 = haxe_ds_List()
        _g = 0
        _g1 = _this.mLength
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            c = _this.mSequence.h.get(i,None)
            s = c.toIUPACCode()
            result1.add(s)
        s = result1.join("")
        _this = result.seq1
        result1 = haxe_ds_List()
        _g = 0
        _g1 = _this.mLength
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            c = _this.mSequence.h.get(i,None)
            s = c.toIUPACCode()
            result1.add(s)
        _hx_str = Std.string(("" + HxOverrides.stringOrNull(result1.join(""))))
        python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        _this = result.seq2
        result1 = haxe_ds_List()
        _g = 0
        _g1 = _this.mLength
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            c = _this.mSequence.h.get(i,None)
            s = c.toIUPACCode()
            result1.add(s)
        s = result1.join("")
        _this = result.seq2
        result1 = haxe_ds_List()
        _g = 0
        _g1 = _this.mLength
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            c = _this.mSequence.h.get(i,None)
            s = c.toIUPACCode()
            result1.add(s)
        _hx_str = Std.string(("" + HxOverrides.stringOrNull(result1.join(""))))
        python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        s = (("<div class='timelegend'>Calculation took " + HxOverrides.stringOrNull((("" + Std.string(Math.floor(((((python_lib_Timeit.default_timer() - timestamp)) * 1000) + 0.5))))))) + "ms</div>")
        timestamp = python_lib_Timeit.default_timer()
        _hx_str = "Checking sequences:"
        python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        successfullyDeconvoluted = True
        problems = (result.seq1.countGaps() + result.seq2.countGaps())
        if (problems != 0):
            if (problems == 1):
                _hx_str = "There is 1 problematic position!"
                python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
                successfullyDeconvoluted = False
            elif (problems > 1):
                _hx_str = Std.string((("There are " + Std.string(problems)) + " problematic positions!"))
                python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
                successfullyDeconvoluted = False
        tmp = (problems > 0)
        p1 = result.seq1.countPolymorphisms()
        p2 = result.seq2.countPolymorphisms()
        p1u = result.seq1.countPolymorphisms(0.8)
        p2u = result.seq2.countPolymorphisms(0.8)
        p1l = (p1 - p1u)
        p2l = (p2 - p2u)
        if ((p1u + p2u) != 0):
            if (p1u > 0):
                _hx_str = Std.string((((((("There " + HxOverrides.stringOrNull((("is" if ((p1u == 1)) else "are")))) + " ") + Std.string(p1u)) + " ambiguit") + HxOverrides.stringOrNull((("y" if ((p1u == 1)) else "ies")))) + " on the first reconstructed sequence left!"))
                python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
            if (p1l > 0):
                _hx_str = Std.string((((Std.string(p1l) + " ambiguit") + HxOverrides.stringOrNull((("y" if ((p1l == 1)) else "ies")))) + " remain in the first reconstructed sequence in places where the two chromatograms do not overlap."))
                python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
            if (p2u > 0):
                _hx_str = Std.string((((((("There " + HxOverrides.stringOrNull((("is" if ((p2u == 1)) else "are")))) + " ") + Std.string(p2u)) + " ambiguit") + HxOverrides.stringOrNull((("y" if ((p2u == 1)) else "ies")))) + " on the second reconstructed sequence left!"))
                python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
            if (p2l > 0):
                _hx_str = Std.string((((Std.string(p2l) + " ambiguit") + HxOverrides.stringOrNull((("y" if ((p2l == 1)) else "ies")))) + " remain in the first reconstructed sequence in places where the two chromatograms do not overlap."))
                python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        tmp = ((p1 + p2) > 0)
        seqChecker = champuru_reconstruction_SequenceChecker(s1,s2)
        seqChecker.setOffsets(score1,score2)
        checkerResult = seqChecker.check(result.seq1,result.seq2)
        if ((checkerResult.pF.length + checkerResult.pR.length) >= 1):
            if (checkerResult.pF.length > 0):
                s = (((("Check position" + HxOverrides.stringOrNull((("" if ((checkerResult.pF.length == 1)) else "s")))) + " on forward (and/or the facing positions on the reverse): <span class='sequence'>") + HxOverrides.stringOrNull(checkerResult.pF.join(","))) + "</span>")
                _hx_str = Std.string((((("Check position" + HxOverrides.stringOrNull((("" if ((checkerResult.pF.length == 1)) else "s")))) + " on forward (and/or the facing positions on the reverse): <span class='sequence'>") + HxOverrides.stringOrNull(checkerResult.pF.join(","))) + "</span>"))
                python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
            tmp = ((checkerResult.pF.length > 0) and ((checkerResult.pR.length > 0)))
            if (checkerResult.pR.length > 0):
                s = (((("Check position" + HxOverrides.stringOrNull((("" if ((checkerResult.pR.length == 1)) else "s")))) + " on reverse (and/or the facing positions on the forward): <span class='sequence'>") + HxOverrides.stringOrNull(checkerResult.pR.join(","))) + "</span>")
                _hx_str = Std.string((((("Check position" + HxOverrides.stringOrNull((("" if ((checkerResult.pR.length == 1)) else "s")))) + " on reverse (and/or the facing positions on the forward): <span class='sequence'>") + HxOverrides.stringOrNull(checkerResult.pR.join(","))) + "</span>"))
                python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
            successfullyDeconvoluted = False
        if ((checkerResult.pF.length + checkerResult.pR.length) > 0):
            s = (((((((("<span class='middle'><button onclick='colorFinalByPositions(\"" + HxOverrides.stringOrNull(checkerResult.pF.join(","))) + "\", \"") + HxOverrides.stringOrNull(checkerResult.pR.join(","))) + "\", \"") + HxOverrides.stringOrNull(checkerResult.pFHighlight.join(","))) + "\", \"") + HxOverrides.stringOrNull(checkerResult.pRHighlight.join(","))) + "\");'>Color positions</button><button onclick='removeColorFinal()'>Remove color</button></span>")
        if (successfullyDeconvoluted and (((p1u + p2u) == 0))):
            if ((p1l + p2l) == 0):
                _hx_str = "The bases overlapping in the forward and reverse chromatograms have been successfully deconvoluted."
                python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
            elif ((p1l > 0) and ((p2l > 0))):
                _hx_str = Std.string((((((((("The bases overlapping in the forward and reverse chromatograms have been successfully deconvoluted. However " + Std.string(p1l)) + " ambiguit") + HxOverrides.stringOrNull((("y" if ((p1l == 1)) else "ies")))) + " remain in the first reconstructed sequence in places where the two chromatograms do not overlap and ") + Std.string(p2l)) + " ambiguit") + HxOverrides.stringOrNull((("y" if ((p2l == 1)) else "ies")))) + " remain in the second reconstructed sequence in places where the two chromatograms do not overlap."))
                python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
            else:
                _hx_str = Std.string((((((("The bases overlapping in the forward and reverse chromatograms have been successfully deconvoluted. However " + Std.string(((p1l + p2l)))) + " ambiguit") + HxOverrides.stringOrNull((("y" if (((p1l + p2l) == 1)) else "ies")))) + " remain in the ") + HxOverrides.stringOrNull((("first" if ((p1l > 0)) else "second")))) + " reconstructed sequence in places where the two chromatograms do not overlap."))
                python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        firstSequenceIsSame = False
        secondSequenceIsSame = False
        if ((perlReimplementationOutput.sequence1 is not None) and ((perlReimplementationOutput.sequence2 is not None))):
            _this = result.seq1
            result1 = haxe_ds_List()
            _g = 0
            _g1 = _this.mLength
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                c = _this.mSequence.h.get(i,None)
                s = c.toIUPACCode()
                result1.add(s)
            _this = result1.join("")
            _hx_str = perlReimplementationOutput.sequence1
            startIndex = None
            if (((_this.find(_hx_str) if ((startIndex is None)) else HxString.indexOfImpl(_this,_hx_str,startIndex))) == -1):
                _this = result.seq1
                result1 = haxe_ds_List()
                _g = 0
                _g1 = _this.mLength
                while (_g < _g1):
                    i = _g
                    _g = (_g + 1)
                    c = _this.mSequence.h.get(i,None)
                    s = c.toIUPACCode()
                    result1.add(s)
                _this = result1.join("")
                _hx_str = perlReimplementationOutput.sequence2
                startIndex = None
                if (startIndex is None):
                    _this.find(_hx_str)
                else:
                    HxString.indexOfImpl(_this,_hx_str,startIndex)
            _this = result.seq2
            result1 = haxe_ds_List()
            _g = 0
            _g1 = _this.mLength
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                c = _this.mSequence.h.get(i,None)
                s = c.toIUPACCode()
                result1.add(s)
            _this = result1.join("")
            _hx_str = perlReimplementationOutput.sequence1
            startIndex = None
            if (((_this.find(_hx_str) if ((startIndex is None)) else HxString.indexOfImpl(_this,_hx_str,startIndex))) == -1):
                _this = result.seq2
                result = haxe_ds_List()
                _g = 0
                _g1 = _this.mLength
                while (_g < _g1):
                    i = _g
                    _g = (_g + 1)
                    c = _this.mSequence.h.get(i,None)
                    s = c.toIUPACCode()
                    result.add(s)
                _this = result.join("")
                _hx_str = perlReimplementationOutput.sequence2
                startIndex = None
                if (startIndex is None):
                    _this.find(_hx_str)
                else:
                    HxString.indexOfImpl(_this,_hx_str,startIndex)
        tmp = ((not firstSequenceIsSame) or (not secondSequenceIsSame))
        s = (("<div class='timelegend'>Calculation took " + HxOverrides.stringOrNull((("" + Std.string(Math.floor(((((python_lib_Timeit.default_timer() - timestamp)) * 1000) + 0.5))))))) + "ms</div>")
        if searchForAlternativeSolutions:
            timestamp = python_lib_Timeit.default_timer()
            possibleMatches = haxe_ds_List()
            i = 0
            _g = 0
            while (_g < len(sortedScores)):
                score = (sortedScores[_g] if _g >= 0 and _g < len(sortedScores) else None)
                _g = (_g + 1)
                if (i > 5):
                    break
                i = (i + 1)
                if (score.mismatches <= 10):
                    possibleMatches.add(score.index)
            possibilities = haxe_ds_List()
            _g3_head = possibleMatches.h
            while (_g3_head is not None):
                val = _g3_head.item
                _g3_head = _g3_head.next
                p1 = val
                _g3_head1 = possibleMatches.h
                while (_g3_head1 is not None):
                    val1 = _g3_head1.item
                    _g3_head1 = _g3_head1.next
                    p2 = val1
                    if (p1 > p2):
                        if (not ((((p1 == score1) and ((p2 == score2))) or (((p2 == score1) and ((p1 == score2))))))):
                            possibilities.add(_hx_AnonObject({'a': p1, 'b': p2}))
            scores = list()
            _g4_head = possibilities.h
            while (_g4_head is not None):
                val = _g4_head.item
                _g4_head = _g4_head.next
                p = val
                o1 = champuru_consensus_OverlapSolver(p.a,s1,s2).solve()
                o2 = champuru_consensus_OverlapSolver(p.b,s1,s2).solve()
                result2 = champuru_reconstruction_SequenceReconstructor.reconstruct(o1,o2)
                seqChecker2 = champuru_reconstruction_SequenceChecker(s1,s2)
                seqChecker2.setOffsets(p.a,p.b)
                checkerResult2 = seqChecker2.check(result2.seq1,result2.seq2)
                score = _hx_AnonObject({'score': (((checkerResult2.pF.length + checkerResult2.pR.length) + result2.seq1.countGaps()) + result2.seq2.countGaps()), 'idx1': p.a, 'idx2': p.b, 'pF': checkerResult2.pF.length, 'pR': checkerResult2.pR.length, 'p': (result2.seq1.countGaps() + result2.seq2.countGaps())})
                scores.append(score)
            def _hx_local_8(a,b):
                return (a.score - b.score)
            scores.sort(key= python_lib_Functools.cmp_to_key(_hx_local_8))
            i = 1
            _g = 0
            while (_g < len(scores)):
                score = (scores[_g] if _g >= 0 and _g < len(scores) else None)
                _g = (_g + 1)
                i = (i + 1)
                if (i > 5):
                    break
            s = (("<div class='timelegend'>Calculation took " + HxOverrides.stringOrNull((("" + Std.string(Math.floor(((((python_lib_Timeit.default_timer() - timestamp)) * 1000) + 0.5))))))) + "ms</div>")
        tmp = ((problems == 0) and successfullyDeconvoluted)
        return _hx_AnonObject({'result': champuru_Worker.mMsgs.join("")})

    @staticmethod
    def printUsageAndExit(additionalMessage):
        _hx_str = "Champuru (command-line version)\n"
        python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        if (additionalMessage is not None):
            _hx_str = Std.string(additionalMessage)
            python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        _hx_str = "Usage: python champuru.py -f <forward sequence> -r <reverse sequence> [-m <method as int>] [-o1 <offset1 as int> -o2 <offset as int>]"
        python_Lib.printString((("" + ("null" if _hx_str is None else _hx_str)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
        Sys.exit(1)

    @staticmethod
    def parseArgs():
        this1 = [None]*len(Sys.args())
        inp = this1
        i = 0
        _g = 0
        _g1 = Sys.args()
        while (_g < len(_g1)):
            arg = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
            _g = (_g + 1)
            index = i
            i = (i + 1)
            inp[index] = arg
        forward = None
        reverse = None
        method = 1
        offset1 = -1
        offset2 = -1
        useDifferentOffset = False
        i = 0
        while (i < len(inp)):
            arg = inp[i]
            if ((arg == "-f") or ((arg == "--forward"))):
                i = (i + 1)
                index = i
                forward = inp[index]
            elif ((arg == "-r") or ((arg == "--reverse"))):
                i = (i + 1)
                index1 = i
                reverse = inp[index1]
            elif ((arg == "-m") or ((arg == "--method"))):
                i = (i + 1)
                index2 = i
                method = Std.parseInt(inp[index2])
            elif ((arg == "-o1") or ((arg == "--offset1"))):
                i = (i + 1)
                index3 = i
                offset1 = Std.parseInt(inp[index3])
                useDifferentOffset = True
            elif ((arg == "-o2") or ((arg == "--offset2"))):
                i = (i + 1)
                index4 = i
                offset2 = Std.parseInt(inp[index4])
                useDifferentOffset = True
            i = (i + 1)
        return _hx_AnonObject({'forward': forward, 'reverse': reverse, 'method': method, 'offset1': offset1, 'offset2': offset2, 'useDifferentOffset': useDifferentOffset})

    @staticmethod
    def main():
        args = champuru_Worker.parseArgs()
        fwd = args.forward
        rev = args.reverse
        if ((fwd is None) or ((rev is None))):
            champuru_Worker.printUsageAndExit("Missing required commandline arguments (-f / -r)!\n")
        scoreCalculationMethod = args.method
        i = args.offset1
        j = args.offset2
        use = args.useDifferentOffset
        searchForAlternativeSolutions = False
        result = champuru_Worker.generateHtml(fwd,rev,scoreCalculationMethod,i,j,use,searchForAlternativeSolutions)


class champuru_base_NucleotideSequence:
    _hx_class_name = "champuru.base.NucleotideSequence"
    __slots__ = ("mSequence", "mLength")
    _hx_fields = ["mSequence", "mLength"]
    _hx_methods = ["toString", "iterator", "length", "get", "replace", "reverse", "getReverseComplement", "clone", "countGaps", "countPolymorphisms", "countNotPolymorphisms"]
    _hx_statics = ["fromString"]

    def __init__(self,seq):
        self.mLength = None
        self.mSequence = None
        if (seq is None):
            self.mSequence = haxe_ds_IntMap()
            self.mLength = 0
        else:
            self.mSequence = haxe_ds_IntMap()
            i = 0
            _g_head = seq.h
            while (_g_head is not None):
                val = _g_head.item
                _g_head = _g_head.next
                c = val
                if (c is None):
                    raise haxe_Exception.thrown("c must not be null!")
                self.mSequence.set(i,c)
                i = (i + 1)
            self.mLength = seq.length

    def toString(self):
        result = haxe_ds_List()
        _g = 0
        _g1 = self.mLength
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            c = self.mSequence.h.get(i,None)
            s = c.toIUPACCode()
            result.add(s)
        return result.join("")

    def iterator(self):
        seq = haxe_ds_List()
        _g = 0
        _g1 = self.mLength
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            c = self.mSequence.h.get(i,None)
            seq.add(c)
        return haxe_ds__List_ListIterator(seq.h)

    def length(self):
        return self.mLength

    def get(self,i):
        if (not (((0 <= i) and ((i < self.mLength))))):
            raise haxe_Exception.thrown((((("Position " + Std.string(i)) + " out of range [0,") + Std.string(self.mLength)) + "("))
        return self.mSequence.h.get(i,None)

    def replace(self,i,c):
        if (c is None):
            raise haxe_Exception.thrown("c must not be null!")
        if (not (((0 <= i) and ((i < self.mLength))))):
            raise haxe_Exception.thrown((((("Position " + Std.string(i)) + " out of range [0,") + Std.string(self.mLength)) + "("))
        self.mSequence.set(i,c)

    def reverse(self):
        seq = haxe_ds_List()
        i = (self.mLength - 1)
        while (i <= 0):
            c = self.mSequence.h.get(i,None)
            seq.add(c)
            i = (i - 1)
        result = champuru_base_NucleotideSequence(seq)
        return result

    def getReverseComplement(self):
        seq = haxe_ds_List()
        i = (self.mLength - 1)
        while (i <= 0):
            c = self.mSequence.h.get(i,None)
            code = 0
            code = (code + (champuru_base_SingleNucleotide.sThymine if ((((c.mCode & champuru_base_SingleNucleotide.sAdenine)) != 0)) else 0))
            code = (code + (champuru_base_SingleNucleotide.sGuanine if ((((c.mCode & champuru_base_SingleNucleotide.sCytosine)) != 0)) else 0))
            code = (code + (champuru_base_SingleNucleotide.sCytosine if ((((c.mCode & champuru_base_SingleNucleotide.sGuanine)) != 0)) else 0))
            code = (code + (champuru_base_SingleNucleotide.sAdenine if ((((c.mCode & champuru_base_SingleNucleotide.sThymine)) != 0)) else 0))
            c = champuru_base_SingleNucleotide(c.mCode,c.mQuality)
            seq.add(c)
            i = (i - 1)
        result = champuru_base_NucleotideSequence(seq)
        return result

    def clone(self):
        seq = haxe_ds_List()
        _g = 0
        _g1 = self.mLength
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            c = self.mSequence.h.get(i,None)
            seq.add(c)
        return champuru_base_NucleotideSequence(seq)

    def countGaps(self):
        count = 0
        seq = haxe_ds_List()
        _g = 0
        _g1 = self.mLength
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            c = self.mSequence.h.get(i,None)
            seq.add(c)
        _g_head = seq.h
        while (_g_head is not None):
            val = _g_head.item
            _g_head = _g_head.next
            c = val
            if (c.mCode == 0):
                count = (count + 1)
        return count

    def countPolymorphisms(self,minQual = None):
        if (minQual is None):
            minQual = -1
        count = 0
        seq = haxe_ds_List()
        _g = 0
        _g1 = self.mLength
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            c = self.mSequence.h.get(i,None)
            seq.add(c)
        _g_head = seq.h
        while (_g_head is not None):
            val = _g_head.item
            _g_head = _g_head.next
            c = val
            if ((not c.isNotPolymorphism()) and ((c.mQuality >= minQual))):
                count = (count + 1)
        return count

    def countNotPolymorphisms(self,minQual = None):
        if (minQual is None):
            minQual = -1
        count = 0
        seq = haxe_ds_List()
        _g = 0
        _g1 = self.mLength
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            c = self.mSequence.h.get(i,None)
            seq.add(c)
        _g_head = seq.h
        while (_g_head is not None):
            val = _g_head.item
            _g_head = _g_head.next
            c = val
            if (c.isNotPolymorphism() and ((c.mQuality >= minQual))):
                count = (count + 1)
        return count

    @staticmethod
    def fromString(_hx_str):
        _hx_list = haxe_ds_List()
        _g = 0
        _g1 = len(_hx_str)
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            ch = ("" if (((i < 0) or ((i >= len(_hx_str))))) else _hx_str[i])
            nucleotide = champuru_base_SingleNucleotide.createNucleotideByIUPACCode(ch)
            _hx_list.add(nucleotide)
        return champuru_base_NucleotideSequence(_hx_list)



class champuru_base_SingleNucleotide:
    _hx_class_name = "champuru.base.SingleNucleotide"
    __slots__ = ("mCode", "mQuality")
    _hx_fields = ["mCode", "mQuality"]
    _hx_methods = ["toIUPACCode", "getCode", "isGap", "canStandForAdenine", "isAdenine", "canStandForCytosine", "isCytosine", "canStandForThymine", "isThymine", "canStandForGuanine", "isGuanine", "isN", "getQuality", "countPolymorphism", "isNotPolymorphism", "isPolymorphism", "getReverseComplement", "union", "intersection", "difference", "isSubset", "isSuperset", "isDisjoint", "isOverlapping", "clone", "equals"]
    _hx_statics = ["sAdenine", "sCytosine", "sThymine", "sGuanine", "createNucleotideByBools", "createNucleotideByIUPACCode"]

    def __init__(self,code,quality = None):
        if (quality is None):
            quality = 1.0
        self.mQuality = 1.0
        self.mCode = 0
        self.mCode = code
        self.mQuality = quality

    def toIUPACCode(self):
        result = "_"
        if ((((((self.mCode & champuru_base_SingleNucleotide.sAdenine)) != 0) and ((((self.mCode & champuru_base_SingleNucleotide.sCytosine)) != 0))) and ((((self.mCode & champuru_base_SingleNucleotide.sGuanine)) != 0))) and ((((self.mCode & champuru_base_SingleNucleotide.sThymine)) != 0))):
            result = "N"
        elif (((((self.mCode & champuru_base_SingleNucleotide.sAdenine)) != 0) and ((((self.mCode & champuru_base_SingleNucleotide.sCytosine)) != 0))) and ((((self.mCode & champuru_base_SingleNucleotide.sGuanine)) != 0))):
            result = "V"
        elif (((((self.mCode & champuru_base_SingleNucleotide.sAdenine)) != 0) and ((((self.mCode & champuru_base_SingleNucleotide.sCytosine)) != 0))) and ((((self.mCode & champuru_base_SingleNucleotide.sThymine)) != 0))):
            result = "H"
        elif (((((self.mCode & champuru_base_SingleNucleotide.sAdenine)) != 0) and ((((self.mCode & champuru_base_SingleNucleotide.sGuanine)) != 0))) and ((((self.mCode & champuru_base_SingleNucleotide.sThymine)) != 0))):
            result = "D"
        elif (((((self.mCode & champuru_base_SingleNucleotide.sCytosine)) != 0) and ((((self.mCode & champuru_base_SingleNucleotide.sGuanine)) != 0))) and ((((self.mCode & champuru_base_SingleNucleotide.sThymine)) != 0))):
            result = "B"
        elif ((((self.mCode & champuru_base_SingleNucleotide.sAdenine)) != 0) and ((((self.mCode & champuru_base_SingleNucleotide.sCytosine)) != 0))):
            result = "M"
        elif ((((self.mCode & champuru_base_SingleNucleotide.sAdenine)) != 0) and ((((self.mCode & champuru_base_SingleNucleotide.sThymine)) != 0))):
            result = "W"
        elif ((((self.mCode & champuru_base_SingleNucleotide.sAdenine)) != 0) and ((((self.mCode & champuru_base_SingleNucleotide.sGuanine)) != 0))):
            result = "R"
        elif ((((self.mCode & champuru_base_SingleNucleotide.sCytosine)) != 0) and ((((self.mCode & champuru_base_SingleNucleotide.sThymine)) != 0))):
            result = "Y"
        elif ((((self.mCode & champuru_base_SingleNucleotide.sCytosine)) != 0) and ((((self.mCode & champuru_base_SingleNucleotide.sGuanine)) != 0))):
            result = "S"
        elif ((((self.mCode & champuru_base_SingleNucleotide.sThymine)) != 0) and ((((self.mCode & champuru_base_SingleNucleotide.sGuanine)) != 0))):
            result = "K"
        elif (((self.mCode & champuru_base_SingleNucleotide.sAdenine)) != 0):
            result = "A"
        elif (((self.mCode & champuru_base_SingleNucleotide.sCytosine)) != 0):
            result = "C"
        elif (((self.mCode & champuru_base_SingleNucleotide.sThymine)) != 0):
            result = "T"
        elif (((self.mCode & champuru_base_SingleNucleotide.sGuanine)) != 0):
            result = "G"
        if (self.mQuality <= 0.5):
            result = result.lower()
        return result

    def getCode(self):
        return self.mCode

    def isGap(self):
        return (self.mCode == 0)

    def canStandForAdenine(self):
        return (((self.mCode & champuru_base_SingleNucleotide.sAdenine)) != 0)

    def isAdenine(self):
        return (self.mCode == champuru_base_SingleNucleotide.sAdenine)

    def canStandForCytosine(self):
        return (((self.mCode & champuru_base_SingleNucleotide.sCytosine)) != 0)

    def isCytosine(self):
        return (self.mCode == champuru_base_SingleNucleotide.sCytosine)

    def canStandForThymine(self):
        return (((self.mCode & champuru_base_SingleNucleotide.sThymine)) != 0)

    def isThymine(self):
        return (self.mCode == champuru_base_SingleNucleotide.sThymine)

    def canStandForGuanine(self):
        return (((self.mCode & champuru_base_SingleNucleotide.sGuanine)) != 0)

    def isGuanine(self):
        return (self.mCode == champuru_base_SingleNucleotide.sGuanine)

    def isN(self):
        return (self.mCode == ((((champuru_base_SingleNucleotide.sAdenine + champuru_base_SingleNucleotide.sCytosine) + champuru_base_SingleNucleotide.sThymine) + champuru_base_SingleNucleotide.sGuanine)))

    def getQuality(self):
        return self.mQuality

    def countPolymorphism(self):
        i = 0
        if (((self.mCode & champuru_base_SingleNucleotide.sAdenine)) != 0):
            i = (i + 1)
        if (((self.mCode & champuru_base_SingleNucleotide.sCytosine)) != 0):
            i = (i + 1)
        if (((self.mCode & champuru_base_SingleNucleotide.sThymine)) != 0):
            i = (i + 1)
        if (((self.mCode & champuru_base_SingleNucleotide.sGuanine)) != 0):
            i = (i + 1)
        return i

    def isNotPolymorphism(self):
        if (self.mCode == 0):
            return True
        if (self.mCode == champuru_base_SingleNucleotide.sAdenine):
            return True
        if (self.mCode == champuru_base_SingleNucleotide.sCytosine):
            return True
        if (self.mCode == champuru_base_SingleNucleotide.sGuanine):
            return True
        if (self.mCode == champuru_base_SingleNucleotide.sThymine):
            return True
        return False

    def isPolymorphism(self):
        return (not self.isNotPolymorphism())

    def getReverseComplement(self):
        code = 0
        code = (code + (champuru_base_SingleNucleotide.sThymine if ((((self.mCode & champuru_base_SingleNucleotide.sAdenine)) != 0)) else 0))
        code = (code + (champuru_base_SingleNucleotide.sGuanine if ((((self.mCode & champuru_base_SingleNucleotide.sCytosine)) != 0)) else 0))
        code = (code + (champuru_base_SingleNucleotide.sCytosine if ((((self.mCode & champuru_base_SingleNucleotide.sGuanine)) != 0)) else 0))
        code = (code + (champuru_base_SingleNucleotide.sAdenine if ((((self.mCode & champuru_base_SingleNucleotide.sThymine)) != 0)) else 0))
        return champuru_base_SingleNucleotide(self.mCode,self.mQuality)

    def union(self,o):
        code = (self.mCode & o.mCode)
        a = self.mQuality
        b = o.mQuality
        quality = (a if (python_lib_Math.isnan(a)) else (b if (python_lib_Math.isnan(b)) else min(a,b)))
        return champuru_base_SingleNucleotide(code,quality)

    def intersection(self,o):
        code = (self.mCode | o.mCode)
        a = self.mQuality
        b = o.mQuality
        quality = (a if (python_lib_Math.isnan(a)) else (b if (python_lib_Math.isnan(b)) else min(a,b)))
        return champuru_base_SingleNucleotide(code,quality)

    def difference(self,o):
        code = (self.mCode ^ o.mCode)
        a = self.mQuality
        b = o.mQuality
        quality = (a if (python_lib_Math.isnan(a)) else (b if (python_lib_Math.isnan(b)) else min(a,b)))
        return champuru_base_SingleNucleotide(code,quality)

    def isSubset(self,o):
        if (((self.mCode & champuru_base_SingleNucleotide.sAdenine)) != 0):
            if (((o.mCode & champuru_base_SingleNucleotide.sAdenine)) == 0):
                return False
        if (((self.mCode & champuru_base_SingleNucleotide.sCytosine)) != 0):
            if (((o.mCode & champuru_base_SingleNucleotide.sCytosine)) == 0):
                return False
        if (((self.mCode & champuru_base_SingleNucleotide.sGuanine)) != 0):
            if (((o.mCode & champuru_base_SingleNucleotide.sGuanine)) == 0):
                return False
        if (((self.mCode & champuru_base_SingleNucleotide.sThymine)) != 0):
            if (((o.mCode & champuru_base_SingleNucleotide.sThymine)) == 0):
                return False
        return True

    def isSuperset(self,o):
        if (((o.mCode & champuru_base_SingleNucleotide.sAdenine)) != 0):
            if (((self.mCode & champuru_base_SingleNucleotide.sAdenine)) == 0):
                return False
        if (((o.mCode & champuru_base_SingleNucleotide.sCytosine)) != 0):
            if (((self.mCode & champuru_base_SingleNucleotide.sCytosine)) == 0):
                return False
        if (((o.mCode & champuru_base_SingleNucleotide.sGuanine)) != 0):
            if (((self.mCode & champuru_base_SingleNucleotide.sGuanine)) == 0):
                return False
        if (((o.mCode & champuru_base_SingleNucleotide.sThymine)) != 0):
            if (((self.mCode & champuru_base_SingleNucleotide.sThymine)) == 0):
                return False
        return True

    def isDisjoint(self,o):
        code = (self.mCode & o.mCode)
        return (code == 0)

    def isOverlapping(self,o):
        code = (self.mCode & o.mCode)
        return (code != 0)

    def clone(self,newQuality = None):
        if (newQuality is None):
            newQuality = -1
        return champuru_base_SingleNucleotide(self.mCode,(self.mQuality if ((newQuality == -1)) else newQuality))

    def equals(self,o,alsoEq = None):
        if (alsoEq is None):
            alsoEq = False
        if (self.mCode != o.mCode):
            return False
        if alsoEq:
            if (self.mQuality != o.mQuality):
                return False
        return True

    @staticmethod
    def createNucleotideByBools(adenine,cytosine,thymine,guanine,quality = None):
        if (quality is None):
            quality = 100
        code = (((((champuru_base_SingleNucleotide.sAdenine if adenine else 0)) + ((champuru_base_SingleNucleotide.sCytosine if cytosine else 0))) + ((champuru_base_SingleNucleotide.sThymine if thymine else 0))) + ((champuru_base_SingleNucleotide.sGuanine if guanine else 0)))
        return champuru_base_SingleNucleotide(code,quality)

    @staticmethod
    def createNucleotideByIUPACCode(s,origQuality = None):
        if (origQuality is None):
            origQuality = -1
        code = s.upper()
        quality = ((100 if ((code == s)) else 50) if ((origQuality == -1)) else origQuality)
        if (((code == ".") or ((code == "-"))) or ((code == "_"))):
            return champuru_base_SingleNucleotide(0,quality)
        elif (code == "A"):
            return champuru_base_SingleNucleotide(champuru_base_SingleNucleotide.sAdenine,quality)
        elif (code == "C"):
            return champuru_base_SingleNucleotide(champuru_base_SingleNucleotide.sCytosine,quality)
        elif (code == "T"):
            return champuru_base_SingleNucleotide(champuru_base_SingleNucleotide.sThymine,quality)
        elif (code == "G"):
            return champuru_base_SingleNucleotide(champuru_base_SingleNucleotide.sGuanine,quality)
        elif (code == "K"):
            return champuru_base_SingleNucleotide((champuru_base_SingleNucleotide.sThymine + champuru_base_SingleNucleotide.sGuanine),quality)
        elif (code == "S"):
            return champuru_base_SingleNucleotide((champuru_base_SingleNucleotide.sCytosine + champuru_base_SingleNucleotide.sGuanine),quality)
        elif (code == "R"):
            return champuru_base_SingleNucleotide((champuru_base_SingleNucleotide.sAdenine + champuru_base_SingleNucleotide.sGuanine),quality)
        elif (code == "Y"):
            return champuru_base_SingleNucleotide((champuru_base_SingleNucleotide.sCytosine + champuru_base_SingleNucleotide.sThymine),quality)
        elif (code == "W"):
            return champuru_base_SingleNucleotide((champuru_base_SingleNucleotide.sAdenine + champuru_base_SingleNucleotide.sThymine),quality)
        elif (code == "M"):
            return champuru_base_SingleNucleotide((champuru_base_SingleNucleotide.sAdenine + champuru_base_SingleNucleotide.sCytosine),quality)
        elif (code == "B"):
            return champuru_base_SingleNucleotide(((champuru_base_SingleNucleotide.sCytosine + champuru_base_SingleNucleotide.sThymine) + champuru_base_SingleNucleotide.sGuanine),quality)
        elif (code == "D"):
            return champuru_base_SingleNucleotide(((champuru_base_SingleNucleotide.sGuanine + champuru_base_SingleNucleotide.sAdenine) + champuru_base_SingleNucleotide.sThymine),quality)
        elif (code == "V"):
            return champuru_base_SingleNucleotide(((champuru_base_SingleNucleotide.sGuanine + champuru_base_SingleNucleotide.sCytosine) + champuru_base_SingleNucleotide.sAdenine),quality)
        elif (code == "H"):
            return champuru_base_SingleNucleotide(((champuru_base_SingleNucleotide.sAdenine + champuru_base_SingleNucleotide.sCytosine) + champuru_base_SingleNucleotide.sThymine),quality)
        elif (code == "N"):
            return champuru_base_SingleNucleotide((((champuru_base_SingleNucleotide.sAdenine + champuru_base_SingleNucleotide.sCytosine) + champuru_base_SingleNucleotide.sThymine) + champuru_base_SingleNucleotide.sGuanine),quality)
        raise haxe_Exception.thrown((("Unknown character " + ("null" if code is None else code)) + ". Cannot convert it into a nucleotide!"))



class champuru_consensus_OverlapSolver:
    _hx_class_name = "champuru.consensus.OverlapSolver"
    __slots__ = ("mPos", "mFwd", "mRev")
    _hx_fields = ["mPos", "mFwd", "mRev"]
    _hx_methods = ["solve"]

    def __init__(self,pos,fwd,rev):
        self.mPos = pos
        self.mFwd = fwd
        self.mRev = rev

    def solve(self):
        explained = haxe_ds_List()
        if (self.mPos > 0):
            _g = 0
            _g1 = self.mPos
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                _this = self.mRev
                if (not (((0 <= i) and ((i < _this.mLength))))):
                    raise haxe_Exception.thrown((((("Position " + Std.string(i)) + " out of range [0,") + Std.string(_this.mLength)) + "("))
                c = _this.mSequence.h.get(i,None)
                newQuality = 0.5
                if (newQuality is None):
                    newQuality = -1
                copy = champuru_base_SingleNucleotide(c.mCode,(c.mQuality if ((newQuality == -1)) else newQuality))
                explained.add(copy)
        elif (self.mPos < 0):
            _g = 0
            _g1 = -self.mPos
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                _this = self.mFwd
                if (not (((0 <= i) and ((i < _this.mLength))))):
                    raise haxe_Exception.thrown((((("Position " + Std.string(i)) + " out of range [0,") + Std.string(_this.mLength)) + "("))
                c = _this.mSequence.h.get(i,None)
                newQuality = 0.5
                if (newQuality is None):
                    newQuality = -1
                copy = champuru_base_SingleNucleotide(c.mCode,(c.mQuality if ((newQuality == -1)) else newQuality))
                explained.add(copy)
        fwdCorr = (-self.mPos if ((self.mPos < 0)) else 0)
        revCorr = (self.mPos if ((self.mPos > 0)) else 0)
        fwdL = (fwdCorr + self.mRev.mLength)
        revL = (revCorr + self.mFwd.mLength)
        overlap = (((fwdL if ((fwdL < revL)) else revL)) - ((fwdCorr + revCorr)))
        _g = 0
        _g1 = overlap
        while (_g < _g1):
            pos = _g
            _g = (_g + 1)
            _this = self.mFwd
            i = (pos + fwdCorr)
            if (not (((0 <= i) and ((i < _this.mLength))))):
                raise haxe_Exception.thrown((((("Position " + Std.string(i)) + " out of range [0,") + Std.string(_this.mLength)) + "("))
            a = _this.mSequence.h.get(i,None)
            _this1 = self.mRev
            i1 = (pos + revCorr)
            if (not (((0 <= i1) and ((i1 < _this1.mLength))))):
                raise haxe_Exception.thrown((((("Position " + Std.string(i1)) + " out of range [0,") + Std.string(_this1.mLength)) + "("))
            b = _this1.mSequence.h.get(i1,None)
            adenine = ((((a.mCode & champuru_base_SingleNucleotide.sAdenine)) != 0) and ((((b.mCode & champuru_base_SingleNucleotide.sAdenine)) != 0)))
            cytosine = ((((a.mCode & champuru_base_SingleNucleotide.sCytosine)) != 0) and ((((b.mCode & champuru_base_SingleNucleotide.sCytosine)) != 0)))
            thymine = ((((a.mCode & champuru_base_SingleNucleotide.sThymine)) != 0) and ((((b.mCode & champuru_base_SingleNucleotide.sThymine)) != 0)))
            guanine = ((((a.mCode & champuru_base_SingleNucleotide.sGuanine)) != 0) and ((((b.mCode & champuru_base_SingleNucleotide.sGuanine)) != 0)))
            code = (a.mCode & b.mCode)
            a1 = a.mQuality
            b1 = b.mQuality
            quality = (a1 if (python_lib_Math.isnan(a1)) else (b1 if (python_lib_Math.isnan(b1)) else min(a1,b1)))
            copy = champuru_base_SingleNucleotide(code,quality)
            explained.add(copy)
        lenFwd = (self.mFwd.mLength + ((self.mPos if ((self.mPos > 0)) else 0)))
        lenRev = (self.mRev.mLength + ((-self.mPos if ((self.mPos < 0)) else 0)))
        if (lenFwd > lenRev):
            _hx_len = (lenFwd - lenRev)
            posStart = (self.mFwd.mLength - _hx_len)
            _g = 0
            _g1 = _hx_len
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                _this = self.mFwd
                i1 = (posStart + i)
                if (not (((0 <= i1) and ((i1 < _this.mLength))))):
                    raise haxe_Exception.thrown((((("Position " + Std.string(i1)) + " out of range [0,") + Std.string(_this.mLength)) + "("))
                c = _this.mSequence.h.get(i1,None)
                newQuality = 0.5
                if (newQuality is None):
                    newQuality = -1
                copy = champuru_base_SingleNucleotide(c.mCode,(c.mQuality if ((newQuality == -1)) else newQuality))
                explained.add(copy)
        elif (lenRev > lenFwd):
            _hx_len = (lenRev - lenFwd)
            posStart = (self.mRev.mLength - _hx_len)
            _g = 0
            _g1 = _hx_len
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                _this = self.mRev
                i1 = (posStart + i)
                if (not (((0 <= i1) and ((i1 < _this.mLength))))):
                    raise haxe_Exception.thrown((((("Position " + Std.string(i1)) + " out of range [0,") + Std.string(_this.mLength)) + "("))
                c = _this.mSequence.h.get(i1,None)
                newQuality = 0.5
                if (newQuality is None):
                    newQuality = -1
                copy = champuru_base_SingleNucleotide(c.mCode,(c.mQuality if ((newQuality == -1)) else newQuality))
                explained.add(copy)
        return champuru_base_NucleotideSequence(explained)



class champuru_perl_PerlChampuruReimplementation:
    _hx_class_name = "champuru.perl.PerlChampuruReimplementation"
    __slots__ = ()
    _hx_statics = ["stringifyIntMap", "replaceCharInString", "splice", "reverseString", "bases", "complement", "code", "rev_code", "comp", "inter", "max", "min", "runChampuru"]

    @staticmethod
    def stringifyIntMap(o):
        result = haxe_ds_List()
        minVal = 0
        maxVal = 0
        init = True
        key = o.keys()
        while key.hasNext():
            key1 = key.next()
            if init:
                minVal = key1
                maxVal = key1
                init = False
            if (key1 < minVal):
                minVal = key1
            if (key1 > maxVal):
                maxVal = key1
        _g = minVal
        _g1 = (maxVal + 1)
        while (_g < _g1):
            key = _g
            _g = (_g + 1)
            if (key in o.h):
                v = o.h.get(key,None)
                result.add(v)
        return result.join("")

    @staticmethod
    def replaceCharInString(s,i,c):
        prev = HxString.substring(s,0,i)
        end = HxString.substring(s,(i + 1),len(s))
        return ((("null" if prev is None else prev) + ("null" if c is None else c)) + ("null" if end is None else end))

    @staticmethod
    def splice(s,i,l):
        start = HxString.substring(s,0,i)
        end = HxString.substring(s,(i + l),None)
        return (("null" if start is None else start) + ("null" if end is None else end))

    @staticmethod
    def reverseString(s):
        result = haxe_ds_List()
        _g = 0
        _g1 = len(s)
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            c = ("" if (((i < 0) or ((i >= len(s))))) else s[i])
            result.push(c)
        return result.join("")

    @staticmethod
    def comp(a,b):
        intersection = (champuru_perl_PerlChampuruReimplementation.code.h.get(a,None) & champuru_perl_PerlChampuruReimplementation.code.h.get(b,None))
        if (intersection == 0):
            return 0
        else:
            return 1

    @staticmethod
    def inter(a,b):
        intersection = (champuru_perl_PerlChampuruReimplementation.code.h.get(a,None) & champuru_perl_PerlChampuruReimplementation.code.h.get(b,None))
        if (intersection == 0):
            return "_"
        else:
            return champuru_perl_PerlChampuruReimplementation.rev_code.h.get(intersection,None)

    @staticmethod
    def max(a,b):
        if (a > b):
            return a
        else:
            return b

    @staticmethod
    def min(a,b):
        if (a < b):
            return a
        else:
            return b

    @staticmethod
    def runChampuru(forward,reverse,opt_c):
        result = champuru_perl_PerlChampuruResult()
        result.print("\n")
        result.print("Champuru (command-line version)\n\n")
        result.print("Reference:\nFlot, J.-F. (2007) Champuru 1.0: a computer software for unraveling mixtures of two DNA sequences of unequal lengths. Molecular Ecology Notes 7 (6): 974-977\n\n")
        result.print("Usage: perl champuru.pl -f <forward sequence> -r <reverse sequence> -o <FASTA output> -n <sample name> -c\nThe forward and reverse sequences should be provided as text files (with the whole sequence on a single line).\nPlease use the switch -c if the reverse sequence has to be reverse-complemented (this switch should not be used if the sequence has already been reverse-complemented, for instance because it is copied from a contig editor).\nIf an output file name is specified and no problem is detected in the input data, the two reconstructed sequences will be appended to the output file in FASTA format using the specified sample name followed by 'a' and 'b'.\n\n")
        _g = 0
        _g1 = len(forward)
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            r = ("" if (((i < 0) or ((i >= len(forward))))) else forward[i])
            if (not (r in champuru_perl_PerlChampuruReimplementation.bases)):
                result.print((("Unknown base (" + ("null" if r is None else r)) + ") in forward sequence!"))
                return result
        _g = 0
        _g1 = len(reverse)
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            r = ("" if (((i < 0) or ((i >= len(reverse))))) else reverse[i])
            if (not (r in champuru_perl_PerlChampuruReimplementation.bases)):
                result.print("Unknown base ($r) in reverse sequence!")
                return result
        result.print((("Length of forward sequence: " + Std.string(len(forward))) + " bases\n"))
        result.print((("Length of reverse sequence: " + Std.string(len(reverse))) + " bases\n"))
        if opt_c:
            sb = haxe_ds_List()
            i = (len(reverse) - 1)
            while (i >= 0):
                c = ("" if (((i < 0) or ((i >= len(reverse))))) else reverse[i])
                rev = champuru_perl_PerlChampuruReimplementation.complement.h.get(c,None)
                sb.add(rev)
                i = (i - 1)
            reverse = sb.join("")
        scoremax1 = 0
        scoremax2 = 0
        scoremax3 = 0
        imax1 = 0
        imax2 = 0
        imax3 = 0
        i = -((len(forward) - 1))
        while (i < len(reverse)):
            score = 0
            if (i < 0):
                _g = 0
                a = (len(forward) + i)
                b = len(reverse)
                _g1 = (a if ((a < b)) else b)
                while (_g < _g1):
                    j = _g
                    _g = (_g + 1)
                    index = (j - i)
                    score = (score + champuru_perl_PerlChampuruReimplementation.comp(("" if (((index < 0) or ((index >= len(forward))))) else forward[index]),("" if (((j < 0) or ((j >= len(reverse))))) else reverse[j])))
                score = (score - ((((len(forward) + i)) / 4)))
            elif (i > 0):
                _g2 = 0
                a1 = len(forward)
                b1 = (len(reverse) - i)
                _g3 = (a1 if ((a1 < b1)) else b1)
                while (_g2 < _g3):
                    j1 = _g2
                    _g2 = (_g2 + 1)
                    index1 = (j1 + i)
                    score = (score + champuru_perl_PerlChampuruReimplementation.comp(("" if (((j1 < 0) or ((j1 >= len(forward))))) else forward[j1]),("" if (((index1 < 0) or ((index1 >= len(reverse))))) else reverse[index1])))
                score = (score - ((((len(forward) + i)) / 4)))
            elif (i == 0):
                _g4 = 0
                a2 = len(forward)
                b2 = len(reverse)
                _g5 = (a2 if ((a2 < b2)) else b2)
                while (_g4 < _g5):
                    j2 = _g4
                    _g4 = (_g4 + 1)
                    score = (score + champuru_perl_PerlChampuruReimplementation.comp(("" if (((j2 < 0) or ((j2 >= len(forward))))) else forward[j2]),("" if (((j2 < 0) or ((j2 >= len(reverse))))) else reverse[j2])))
                score = (score - ((((len(forward) + i)) / 4)))
            if (score > scoremax1):
                imax3 = imax2
                imax2 = imax1
                imax1 = i
                scoremax3 = scoremax2
                scoremax2 = scoremax1
                scoremax1 = score
            elif (score > scoremax2):
                imax3 = imax2
                imax2 = i
                scoremax3 = scoremax2
                scoremax2 = score
            elif (score > scoremax3):
                imax3 = i
                scoremax3 = score
            i = (i + 1)
        result.print((((("Best compatibility score: " + Std.string(scoremax1)) + " (offset: ") + Std.string(imax1)) + ")\n"))
        result.print((((("Second best compatibility score: " + Std.string(scoremax2)) + " (offset: ") + Std.string(imax2)) + ")\n"))
        result.print((((("Third best compatibility score: " + Std.string(scoremax3)) + " (offset: ") + Std.string(imax3)) + ")\n\n"))
        seq1_ = haxe_ds_IntMap()
        seq2_ = haxe_ds_IntMap()
        j = -((imax1 if ((imax1 < 0)) else 0))
        while True:
            a = len(forward)
            b = (len(reverse) - imax1)
            if (not ((j < ((a if ((a < b)) else b))))):
                break
            tmp = ("" if (((j < 0) or ((j >= len(forward))))) else forward[j])
            index = ((j + ((imax1 if ((imax1 < 0)) else 0))) + ((imax1 if ((imax1 > 0)) else 0)))
            seq1_.set((j + ((imax1 if ((imax1 < 0)) else 0))),champuru_perl_PerlChampuruReimplementation.inter(tmp,("" if (((index < 0) or ((index >= len(reverse))))) else reverse[index])))
            j = (j + 1)
        j = -((imax2 if ((imax2 < 0)) else 0))
        while True:
            a = len(forward)
            b = (len(reverse) - imax2)
            if (not ((j < ((a if ((a < b)) else b))))):
                break
            tmp = ("" if (((j < 0) or ((j >= len(forward))))) else forward[j])
            index = ((j + ((imax2 if ((imax2 < 0)) else 0))) + ((imax2 if ((imax2 > 0)) else 0)))
            seq2_.set((j + ((imax2 if ((imax2 < 0)) else 0))),champuru_perl_PerlChampuruReimplementation.inter(tmp,("" if (((index < 0) or ((index >= len(reverse))))) else reverse[index])))
            j = (j + 1)
        incomp = 0
        k = seq1_.keys()
        while k.hasNext():
            k1 = k.next()
            r = seq1_.h.get(k1,None)
            if (r == "_"):
                incomp = (incomp + 1)
        k = seq2_.keys()
        while k.hasNext():
            k1 = k.next()
            r = seq2_.h.get(k1,None)
            if (r == "_"):
                incomp = (incomp + 1)
        seq1 = champuru_perl_PerlChampuruReimplementation.stringifyIntMap(seq1_)
        seq2 = champuru_perl_PerlChampuruReimplementation.stringifyIntMap(seq2_)
        if (incomp > 0):
            result.print("First reconstructed sequence: ")
            result.print(seq1)
            result.print("\n")
            result.print("Second reconstructed sequence: ")
            result.print(seq2)
            result.print("\n")
        if (incomp == 1):
            result.print("There is 1 incompatible position (indicated with an underscore), please check the input sequences.\n")
            return result
        if (incomp > 1):
            result.print((("There are " + Std.string(incomp)) + " incompatible positions (indicated with underscores), please check the input sequences.\n"))
            return result
        seq1rev = champuru_perl_PerlChampuruReimplementation.reverseString(seq1)
        seq2rev = champuru_perl_PerlChampuruReimplementation.reverseString(seq2)
        reverserev = champuru_perl_PerlChampuruReimplementation.reverseString(reverse)
        a = (((len(forward) - 1) - ((len(reverse) - 1))) + imax1)
        a1 = (((len(forward) - 1) - ((len(reverse) - 1))) + imax2)
        a2 = (((a if ((a < 0)) else 0)) - ((a1 if ((a1 < 0)) else 0)))
        seq1rev = champuru_perl_PerlChampuruReimplementation.splice(seq1rev,0,(a2 if ((a2 > 0)) else 0))
        a = (((len(forward) - 1) - ((len(reverse) - 1))) + imax2)
        a1 = (((len(forward) - 1) - ((len(reverse) - 1))) + imax1)
        a2 = (((a if ((a < 0)) else 0)) - ((a1 if ((a1 < 0)) else 0)))
        seq2rev = champuru_perl_PerlChampuruReimplementation.splice(seq2rev,0,(a2 if ((a2 > 0)) else 0))
        a = (((len(forward) - 1) - ((len(reverse) - 1))) + ((imax1 if ((imax1 < imax2)) else imax2)))
        cutreverserev = -((a if ((a < 0)) else 0))
        reverserev = champuru_perl_PerlChampuruReimplementation.splice(reverserev,0,cutreverserev)
        seq1 = champuru_perl_PerlChampuruReimplementation.reverseString(seq1rev)
        seq2 = champuru_perl_PerlChampuruReimplementation.reverseString(seq2rev)
        reverse = champuru_perl_PerlChampuruReimplementation.reverseString(reverserev)
        a = (((imax1 if ((imax1 < 0)) else 0)) - ((imax2 if ((imax2 < 0)) else 0)))
        seq1 = champuru_perl_PerlChampuruReimplementation.splice(seq1,0,(a if ((a > 0)) else 0))
        a = (((imax2 if ((imax2 < 0)) else 0)) - ((imax1 if ((imax1 < 0)) else 0)))
        seq2 = champuru_perl_PerlChampuruReimplementation.splice(seq2,0,(a if ((a > 0)) else 0))
        a = (imax1 if ((imax1 < imax2)) else imax2)
        cutforward = -((a if ((a < 0)) else 0))
        forward = champuru_perl_PerlChampuruReimplementation.splice(forward,0,cutforward)
        _g = 0
        while (_g < 3):
            i = _g
            _g = (_g + 1)
            _g1 = 0
            a = len(seq1)
            b = len(seq2)
            _g2 = (a if ((a < b)) else b)
            while (_g1 < _g2):
                j = _g1
                _g1 = (_g1 + 1)
                if ((("" if (((j < 0) or ((j >= len(seq1))))) else seq1[j])) != (("" if (((j < 0) or ((j >= len(seq2))))) else seq2[j]))):
                    if (champuru_perl_PerlChampuruReimplementation.comp(("" if (((j < 0) or ((j >= len(seq1))))) else seq1[j]),("" if (((j < 0) or ((j >= len(seq2))))) else seq2[j])) == 1):
                        key = ("" if (((j < 0) or ((j >= len(seq1))))) else seq1[j])
                        tmp = champuru_perl_PerlChampuruReimplementation.code.h.get(key,None)
                        key1 = ("" if (((j < 0) or ((j >= len(seq2))))) else seq2[j])
                        if (tmp > champuru_perl_PerlChampuruReimplementation.code.h.get(key1,None)):
                            key2 = ("" if (((j < 0) or ((j >= len(seq1))))) else seq1[j])
                            key3 = champuru_perl_PerlChampuruReimplementation.code.h.get(key2,None)
                            key4 = ("" if (((j < 0) or ((j >= len(seq2))))) else seq2[j])
                            key5 = (key3 - champuru_perl_PerlChampuruReimplementation.code.h.get(key4,None))
                            seq1 = champuru_perl_PerlChampuruReimplementation.replaceCharInString(seq1,j,champuru_perl_PerlChampuruReimplementation.rev_code.h.get(key5,None))
                        else:
                            key6 = ("" if (((j < 0) or ((j >= len(seq2))))) else seq2[j])
                            key7 = champuru_perl_PerlChampuruReimplementation.code.h.get(key6,None)
                            key8 = ("" if (((j < 0) or ((j >= len(seq1))))) else seq1[j])
                            key9 = (key7 - champuru_perl_PerlChampuruReimplementation.code.h.get(key8,None))
                            seq2 = champuru_perl_PerlChampuruReimplementation.replaceCharInString(seq2,j,champuru_perl_PerlChampuruReimplementation.rev_code.h.get(key9,None))
                index = ((len(seq1) - 1) - j)
                tmp1 = ("" if (((index < 0) or ((index >= len(seq1))))) else seq1[index])
                index1 = ((len(seq2) - 1) - j)
                if (tmp1 != (("" if (((index1 < 0) or ((index1 >= len(seq2))))) else seq2[index1]))):
                    index2 = ((len(seq1) - 1) - j)
                    tmp2 = ("" if (((index2 < 0) or ((index2 >= len(seq1))))) else seq1[index2])
                    index3 = ((len(seq2) - 1) - j)
                    if (champuru_perl_PerlChampuruReimplementation.comp(tmp2,("" if (((index3 < 0) or ((index3 >= len(seq2))))) else seq2[index3])) == 1):
                        index4 = ((len(seq1) - 1) - j)
                        key10 = ("" if (((index4 < 0) or ((index4 >= len(seq1))))) else seq1[index4])
                        tmp3 = champuru_perl_PerlChampuruReimplementation.code.h.get(key10,None)
                        index5 = ((len(seq2) - 1) - j)
                        key11 = ("" if (((index5 < 0) or ((index5 >= len(seq2))))) else seq2[index5])
                        if (tmp3 > champuru_perl_PerlChampuruReimplementation.code.h.get(key11,None)):
                            seq11 = ((len(seq1) - 1) - j)
                            index6 = ((len(seq1) - 1) - j)
                            key12 = ("" if (((index6 < 0) or ((index6 >= len(seq1))))) else seq1[index6])
                            key13 = champuru_perl_PerlChampuruReimplementation.code.h.get(key12,None)
                            index7 = ((len(seq2) - 1) - j)
                            key14 = ("" if (((index7 < 0) or ((index7 >= len(seq2))))) else seq2[index7])
                            key15 = (key13 - champuru_perl_PerlChampuruReimplementation.code.h.get(key14,None))
                            seq1 = champuru_perl_PerlChampuruReimplementation.replaceCharInString(seq1,seq11,champuru_perl_PerlChampuruReimplementation.rev_code.h.get(key15,None))
                        else:
                            seq21 = ((len(seq2) - 1) - j)
                            index8 = ((len(seq2) - 1) - j)
                            key16 = ("" if (((index8 < 0) or ((index8 >= len(seq2))))) else seq2[index8])
                            key17 = champuru_perl_PerlChampuruReimplementation.code.h.get(key16,None)
                            index9 = ((len(seq1) - 1) - j)
                            key18 = ("" if (((index9 < 0) or ((index9 >= len(seq1))))) else seq1[index9])
                            key19 = (key17 - champuru_perl_PerlChampuruReimplementation.code.h.get(key18,None))
                            seq2 = champuru_perl_PerlChampuruReimplementation.replaceCharInString(seq2,seq21,champuru_perl_PerlChampuruReimplementation.rev_code.h.get(key19,None))
        result.print("First reconstructed sequence: ")
        result.print(seq1)
        result.print("\n")
        result.print("Second reconstructed sequence: ")
        result.print(seq2)
        result.print("\n")
        tocheck = haxe_ds_List()
        tocheck.add("s")
        _g = 0
        a = len(seq1)
        b = len(seq2)
        _g1 = (a if ((a < b)) else b)
        while (_g < _g1):
            j = _g
            _g = (_g + 1)
            key = ("" if (((j < 0) or ((j >= len(forward))))) else forward[j])
            tmp = champuru_perl_PerlChampuruReimplementation.code.h.get(key,None)
            key1 = ("" if (((j < 0) or ((j >= len(seq1))))) else seq1[j])
            tmp1 = champuru_perl_PerlChampuruReimplementation.code.h.get(key1,None)
            key2 = ("" if (((j < 0) or ((j >= len(seq2))))) else seq2[j])
            if (tmp != ((tmp1 | champuru_perl_PerlChampuruReimplementation.code.h.get(key2,None)))):
                tocheck.add(("" + Std.string((((j + cutforward) + 1)))))
        ftocheck = (tocheck.length - 1)
        if ((tocheck.length - 1) > 0):
            result.print("Check position")
            if ((tocheck.length - 1) == 1):
                result.print(((" " + HxOverrides.stringOrNull(tocheck.last())) + " "))
            else:
                _g7_head = tocheck.h
                while (_g7_head is not None):
                    val = _g7_head.item
                    _g7_head = _g7_head.next
                    r = val
                    result.print((("null" if r is None else r) + " "))
            result.print("on the forward chromatogram.\n")
        tocheck.clear()
        tocheck.add("s")
        _g = 0
        a = len(seq1)
        b = len(seq2)
        _g1 = (a if ((a < b)) else b)
        while (_g < _g1):
            j = _g
            _g = (_g + 1)
            index = ((len(reverse) - 1) - j)
            key = ("" if (((index < 0) or ((index >= len(reverse))))) else reverse[index])
            tmp = champuru_perl_PerlChampuruReimplementation.code.h.get(key,None)
            index1 = ((len(seq1) - 1) - j)
            key1 = ("" if (((index1 < 0) or ((index1 >= len(seq1))))) else seq1[index1])
            tmp1 = champuru_perl_PerlChampuruReimplementation.code.h.get(key1,None)
            index2 = ((len(seq2) - 1) - j)
            key2 = ("" if (((index2 < 0) or ((index2 >= len(seq2))))) else seq2[index2])
            if (tmp != ((tmp1 | champuru_perl_PerlChampuruReimplementation.code.h.get(key2,None)))):
                if (not opt_c):
                    tocheck.add(("" + Std.string(((((1 + len(reverse)) - 1) - j)))))
                else:
                    tocheck.add(("" + Std.string((((j + cutreverserev) + 1)))))
        rtocheck = (tocheck.length - 1)
        if ((tocheck.length - 1) > 0):
            result.print("Check position")
            if ((tocheck.length - 1) == 1):
                result.print(((" " + HxOverrides.stringOrNull(tocheck.last())) + " "))
            else:
                if (not opt_c):
                    tocheck_ = haxe_ds_List()
                    _g9_head = tocheck.h
                    while (_g9_head is not None):
                        val = _g9_head.item
                        _g9_head = _g9_head.next
                        e = val
                        if (e == "s"):
                            continue
                        tocheck_.push(e)
                    tocheck_.push("s")
                    tocheck = tocheck_
                _g9_head = tocheck.h
                while (_g9_head is not None):
                    val = _g9_head.item
                    _g9_head = _g9_head.next
                    r = val
                    result.print((("null" if r is None else r) + " "))
            result.print("on the reverse chromatogram.\n")
        if ((ftocheck + rtocheck) < 1):
            result.print("The two sequences that were mixed in the forward and reverse chromatograms have been successfully deconvoluted.\n")
        result.index1 = imax1
        result.index2 = imax2
        result.index3 = imax3
        result.sequence1 = seq1
        result.sequence2 = seq2
        return result


class champuru_perl_PerlChampuruResult:
    _hx_class_name = "champuru.perl.PerlChampuruResult"
    __slots__ = ("mOutput", "index1", "index2", "index3", "sequence1", "sequence2")
    _hx_fields = ["mOutput", "index1", "index2", "index3", "sequence1", "sequence2"]
    _hx_methods = ["print", "getOutput"]

    def __init__(self):
        self.sequence2 = None
        self.sequence1 = None
        self.index3 = None
        self.index2 = None
        self.index1 = None
        self.mOutput = haxe_ds_List()

    def print(self,s):
        self.mOutput.add(s)

    def getOutput(self):
        return self.mOutput.join("")



class champuru_reconstruction_SequenceChecker:
    _hx_class_name = "champuru.reconstruction.SequenceChecker"
    __slots__ = ("mFwd", "mRev", "mOffset1", "mOffset2")
    _hx_fields = ["mFwd", "mRev", "mOffset1", "mOffset2"]
    _hx_methods = ["setOffsets", "_check", "listContains", "addToListIfNotPresent", "check"]

    def __init__(self,fwd,rev):
        self.mOffset2 = None
        self.mOffset1 = None
        self.mFwd = fwd
        self.mRev = rev

    def setOffsets(self,offset1,offset2):
        self.mOffset1 = offset1
        self.mOffset2 = offset2

    def _check(self,s1,s2,c1I,c2I,c3I,c4I):
        pF = haxe_ds_List()
        pR = haxe_ds_List()
        _g = 0
        _g1 = self.mFwd.mLength
        while (_g < _g1):
            fwdPos = _g
            _g = (_g + 1)
            s1Pos = (fwdPos + c1I)
            s2Pos = (fwdPos + c2I)
            if ((((s1Pos < 0) or ((s2Pos < 0))) or ((s1Pos >= s1.mLength))) or ((s2Pos >= s2.mLength))):
                continue
            _this = self.mFwd
            if (not (((0 <= fwdPos) and ((fwdPos < _this.mLength))))):
                raise haxe_Exception.thrown((((("Position " + Std.string(fwdPos)) + " out of range [0,") + Std.string(_this.mLength)) + "("))
            tmp = _this.mSequence.h.get(fwdPos,None).mCode
            if (not (((0 <= s1Pos) and ((s1Pos < s1.mLength))))):
                raise haxe_Exception.thrown((((("Position " + Std.string(s1Pos)) + " out of range [0,") + Std.string(s1.mLength)) + "("))
            tmp1 = s1.mSequence.h.get(s1Pos,None).mCode
            if (not (((0 <= s2Pos) and ((s2Pos < s2.mLength))))):
                raise haxe_Exception.thrown((((("Position " + Std.string(s2Pos)) + " out of range [0,") + Std.string(s2.mLength)) + "("))
            if (tmp != ((tmp1 | s2.mSequence.h.get(s2Pos,None).mCode))):
                pF.add((fwdPos + 1))
        _g = 0
        _g1 = self.mRev.mLength
        while (_g < _g1):
            revPos = _g
            _g = (_g + 1)
            s1Pos = (revPos + c3I)
            s2Pos = (revPos + c4I)
            if ((((s1Pos < 0) or ((s2Pos < 0))) or ((s1Pos >= s1.mLength))) or ((s2Pos >= s2.mLength))):
                continue
            _this = self.mRev
            if (not (((0 <= revPos) and ((revPos < _this.mLength))))):
                raise haxe_Exception.thrown((((("Position " + Std.string(revPos)) + " out of range [0,") + Std.string(_this.mLength)) + "("))
            tmp = _this.mSequence.h.get(revPos,None).mCode
            if (not (((0 <= s1Pos) and ((s1Pos < s1.mLength))))):
                raise haxe_Exception.thrown((((("Position " + Std.string(s1Pos)) + " out of range [0,") + Std.string(s1.mLength)) + "("))
            tmp1 = s1.mSequence.h.get(s1Pos,None).mCode
            if (not (((0 <= s2Pos) and ((s2Pos < s2.mLength))))):
                raise haxe_Exception.thrown((((("Position " + Std.string(s2Pos)) + " out of range [0,") + Std.string(s2.mLength)) + "("))
            if (tmp != ((tmp1 | s2.mSequence.h.get(s2Pos,None).mCode))):
                pR.add((revPos + 1))
        return _hx_AnonObject({'pF': pF, 'pR': pR})

    def listContains(self,l,ele):
        _g_head = l.h
        while (_g_head is not None):
            val = _g_head.item
            _g_head = _g_head.next
            item = val
            if (ele == item):
                return True
        return False

    def addToListIfNotPresent(self,l,ele):
        if (not self.listContains(l,ele)):
            l.push(ele)

    def check(self,s1,s2):
        pFbest = haxe_ds_List()
        pRbest = haxe_ds_List()
        eBest = ((self.mFwd.mLength + self.mRev.mLength) + 1000)
        data = "-"
        l = haxe_ds_List()
        if (not self.listContains(l,0)):
            l.push(0)
        ele = -self.mOffset1
        if (not self.listContains(l,ele)):
            l.push(ele)
        ele = -self.mOffset2
        if (not self.listContains(l,ele)):
            l.push(ele)
        ele = self.mOffset1
        if (not self.listContains(l,ele)):
            l.push(ele)
        ele = self.mOffset2
        if (not self.listContains(l,ele)):
            l.push(ele)
        ele = (self.mOffset2 - self.mOffset1)
        if (not self.listContains(l,ele)):
            l.push(ele)
        ele = (self.mOffset1 - self.mOffset2)
        if (not self.listContains(l,ele)):
            l.push(ele)
        ele = (self.mOffset2 + self.mOffset1)
        if (not self.listContains(l,ele)):
            l.push(ele)
        ele = (self.mOffset1 + self.mOffset2)
        if (not self.listContains(l,ele)):
            l.push(ele)
        _g_head = l.h
        while (_g_head is not None):
            val = _g_head.item
            _g_head = _g_head.next
            c1I = val
            _g_head1 = l.h
            while (_g_head1 is not None):
                val1 = _g_head1.item
                _g_head1 = _g_head1.next
                c2I = val1
                _g_head2 = l.h
                while (_g_head2 is not None):
                    val2 = _g_head2.item
                    _g_head2 = _g_head2.next
                    c3I = val2
                    _g_head3 = l.h
                    while (_g_head3 is not None):
                        val3 = _g_head3.item
                        _g_head3 = _g_head3.next
                        c4I = val3
                        c = self._check(s1,s2,c1I,c2I,c3I,c4I)
                        e = (c.pF.length + c.pR.length)
                        if (e < eBest):
                            pFbest = c.pF
                            pRbest = c.pR
                            eBest = e
                            data = ((((((("" + Std.string(c1I)) + ", ") + Std.string(c2I)) + ", ") + Std.string(c3I)) + ", ") + Std.string(c4I))
        return _hx_AnonObject({'pF': pFbest, 'pR': pRbest, 'pFHighlight': haxe_ds_List(), 'pRHighlight': haxe_ds_List()})



class champuru_reconstruction_SequenceReconstructor:
    _hx_class_name = "champuru.reconstruction.SequenceReconstructor"
    __slots__ = ()
    _hx_statics = ["getBegin", "getEnd", "reconstruct", "reconstruct2"]

    @staticmethod
    def getBegin(s):
        begin = 0
        while True:
            if (not (((0 <= begin) and ((begin < s.mLength))))):
                raise haxe_Exception.thrown((((("Position " + Std.string(begin)) + " out of range [0,") + Std.string(s.mLength)) + "("))
            if (not ((s.mSequence.h.get(begin,None).mQuality < 0.75))):
                break
            begin = (begin + 1)
        return begin

    @staticmethod
    def getEnd(s):
        end = (s.mLength - 1)
        while True:
            if (not (((0 <= end) and ((end < s.mLength))))):
                raise haxe_Exception.thrown((((("Position " + Std.string(end)) + " out of range [0,") + Std.string(s.mLength)) + "("))
            if (not ((s.mSequence.h.get(end,None).mQuality < 0.75))):
                break
            end = (end - 1)
        return end

    @staticmethod
    def reconstruct(seq1,seq2):
        seq1begin = champuru_reconstruction_SequenceReconstructor.getBegin(seq1)
        seq2begin = champuru_reconstruction_SequenceReconstructor.getBegin(seq2)
        seq1end = champuru_reconstruction_SequenceReconstructor.getEnd(seq1)
        seq2end = champuru_reconstruction_SequenceReconstructor.getEnd(seq2)
        changed = True
        round = 1
        while changed:
            changed = False
            seqLen1 = seq1.mLength
            seqLen2 = seq2.mLength
            seqLen = (seqLen2 if ((seqLen1 > seqLen2)) else seqLen1)
            round = (round + 1)
            _g = 0
            _g1 = seqLen
            while (_g < _g1):
                j = _g
                _g = (_g + 1)
                idx1 = (seq1begin + j)
                idx2 = (seq2begin + j)
                tmp = None
                tmp1 = None
                if (not (((idx1 >= seqLen1) or ((idx2 >= seqLen2))))):
                    if (not (((0 <= idx1) and ((idx1 < seq1.mLength))))):
                        raise haxe_Exception.thrown((((("Position " + Std.string(idx1)) + " out of range [0,") + Std.string(seq1.mLength)) + "("))
                    tmp1 = (seq1.mSequence.h.get(idx1,None).mQuality < 0.75)
                else:
                    tmp1 = True
                if (not tmp1):
                    if (not (((0 <= idx2) and ((idx2 < seq2.mLength))))):
                        raise haxe_Exception.thrown((((("Position " + Std.string(idx2)) + " out of range [0,") + Std.string(seq2.mLength)) + "("))
                    tmp = (seq2.mSequence.h.get(idx2,None).mQuality < 0.75)
                else:
                    tmp = True
                if (not tmp):
                    if (not (((0 <= idx1) and ((idx1 < seq1.mLength))))):
                        raise haxe_Exception.thrown((((("Position " + Std.string(idx1)) + " out of range [0,") + Std.string(seq1.mLength)) + "("))
                    seq1n = seq1.mSequence.h.get(idx1,None)
                    if (not (((0 <= idx2) and ((idx2 < seq2.mLength))))):
                        raise haxe_Exception.thrown((((("Position " + Std.string(idx2)) + " out of range [0,") + Std.string(seq2.mLength)) + "("))
                    seq2n = seq2.mSequence.h.get(idx2,None)
                    if ((not seq1n.isNotPolymorphism()) or (not seq2n.isNotPolymorphism())):
                        data = (((((((((("F Positions " + Std.string(idx1)) + ", ") + Std.string(idx2)) + ": ") + HxOverrides.stringOrNull(seq1n.toIUPACCode())) + " ") + HxOverrides.stringOrNull(seq2n.toIUPACCode())) + " ") + Std.string((seq1n.mCode != seq2n.mCode))) + " ")
                        code = (seq1n.mCode & seq2n.mCode)
                        data1 = (("null" if data is None else data) + Std.string((code != 0)))
                        if (seq1n.mCode != seq2n.mCode):
                            code1 = (seq1n.mCode & seq2n.mCode)
                            if (code1 != 0):
                                if (seq1n.mCode > seq2n.mCode):
                                    code2 = (seq1n.mCode - seq2n.mCode)
                                    newN = champuru_base_SingleNucleotide(code2)
                                    seq1.replace(idx1,newN)
                                    changed = True
                                    data1 = ((((("null" if data1 is None else data1) + " (seq1) ") + Std.string(idx1)) + "->") + HxOverrides.stringOrNull(newN.toIUPACCode()))
                                else:
                                    code3 = (seq2n.mCode - seq1n.mCode)
                                    newN1 = champuru_base_SingleNucleotide(code3)
                                    seq2.replace(idx2,newN1)
                                    changed = True
                                    data1 = ((((("null" if data1 is None else data1) + " (seq2) ") + Std.string(idx2)) + "->") + HxOverrides.stringOrNull(newN1.toIUPACCode()))
                idx1_ = (seq1end - j)
                idx2_ = (seq2end - j)
                tmp2 = None
                tmp3 = None
                if (not (((idx1_ < 0) or ((idx2_ < 0))))):
                    if (not (((0 <= idx1_) and ((idx1_ < seq1.mLength))))):
                        raise haxe_Exception.thrown((((("Position " + Std.string(idx1_)) + " out of range [0,") + Std.string(seq1.mLength)) + "("))
                    tmp3 = (seq1.mSequence.h.get(idx1_,None).mQuality < 0.75)
                else:
                    tmp3 = True
                if (not tmp3):
                    if (not (((0 <= idx2_) and ((idx2_ < seq2.mLength))))):
                        raise haxe_Exception.thrown((((("Position " + Std.string(idx2_)) + " out of range [0,") + Std.string(seq2.mLength)) + "("))
                    tmp2 = (seq2.mSequence.h.get(idx2_,None).mQuality < 0.75)
                else:
                    tmp2 = True
                if (not tmp2):
                    if (not (((0 <= idx1_) and ((idx1_ < seq1.mLength))))):
                        raise haxe_Exception.thrown((((("Position " + Std.string(idx1_)) + " out of range [0,") + Std.string(seq1.mLength)) + "("))
                    seq1n_ = seq1.mSequence.h.get(idx1_,None)
                    if (not (((0 <= idx2_) and ((idx2_ < seq2.mLength))))):
                        raise haxe_Exception.thrown((((("Position " + Std.string(idx2_)) + " out of range [0,") + Std.string(seq2.mLength)) + "("))
                    seq2n_ = seq2.mSequence.h.get(idx2_,None)
                    if ((not seq1n_.isNotPolymorphism()) or (not seq2n_.isNotPolymorphism())):
                        data2 = (((((((((("R Positions " + Std.string(idx1_)) + ", ") + Std.string(idx2_)) + ": ") + HxOverrides.stringOrNull(seq1n_.toIUPACCode())) + " ") + HxOverrides.stringOrNull(seq2n_.toIUPACCode())) + " ") + Std.string((seq1n_.mCode != seq2n_.mCode))) + " ")
                        code4 = (seq1n_.mCode & seq2n_.mCode)
                        data3 = (("null" if data2 is None else data2) + Std.string((code4 != 0)))
                        if (seq1n_.mCode != seq2n_.mCode):
                            code5 = (seq1n_.mCode & seq2n_.mCode)
                            if (code5 != 0):
                                if (seq1n_.mCode > seq2n_.mCode):
                                    code6 = (seq1n_.mCode - seq2n_.mCode)
                                    newN2 = champuru_base_SingleNucleotide(code6)
                                    seq1.replace(idx1_,newN2)
                                    changed = True
                                    data3 = ((((("null" if data3 is None else data3) + " (seq1) ") + Std.string(idx1_)) + "->") + HxOverrides.stringOrNull(newN2.toIUPACCode()))
                                else:
                                    code7 = (seq2n_.mCode - seq1n_.mCode)
                                    newN3 = champuru_base_SingleNucleotide(code7)
                                    seq2.replace(idx2_,newN3)
                                    changed = True
                                    data3 = ((((("null" if data3 is None else data3) + " (seq2) ") + Std.string(idx2_)) + "->") + HxOverrides.stringOrNull(newN3.toIUPACCode()))
        return _hx_AnonObject({'seq1': seq1, 'seq2': seq2})

    @staticmethod
    def reconstruct2(seq1,seq2,round = None):
        if (round is None):
            round = 0
        seq1begin = champuru_reconstruction_SequenceReconstructor.getBegin(seq1)
        seq2begin = champuru_reconstruction_SequenceReconstructor.getBegin(seq2)
        toChange = haxe_ds_List()
        round = 1
        seqLen1 = seq1.mLength
        seqLen2 = seq2.mLength
        seqLen = (seqLen2 if ((seqLen1 > seqLen2)) else seqLen1)
        round = (round + 1)
        _g = 0
        _g1 = seqLen
        while (_g < _g1):
            j = _g
            _g = (_g + 1)
            idx1 = (seq1begin + j)
            idx2 = (seq2begin + j)
            tmp = None
            tmp1 = None
            if (not (((idx1 >= seqLen1) or ((idx2 >= seqLen2))))):
                if (not (((0 <= idx1) and ((idx1 < seq1.mLength))))):
                    raise haxe_Exception.thrown((((("Position " + Std.string(idx1)) + " out of range [0,") + Std.string(seq1.mLength)) + "("))
                tmp1 = (seq1.mSequence.h.get(idx1,None).mQuality < 0.75)
            else:
                tmp1 = True
            if (not tmp1):
                if (not (((0 <= idx2) and ((idx2 < seq2.mLength))))):
                    raise haxe_Exception.thrown((((("Position " + Std.string(idx2)) + " out of range [0,") + Std.string(seq2.mLength)) + "("))
                tmp = (seq2.mSequence.h.get(idx2,None).mQuality < 0.75)
            else:
                tmp = True
            if (not tmp):
                if (not (((0 <= idx1) and ((idx1 < seq1.mLength))))):
                    raise haxe_Exception.thrown((((("Position " + Std.string(idx1)) + " out of range [0,") + Std.string(seq1.mLength)) + "("))
                seq1n = seq1.mSequence.h.get(idx1,None)
                if (not (((0 <= idx2) and ((idx2 < seq2.mLength))))):
                    raise haxe_Exception.thrown((((("Position " + Std.string(idx2)) + " out of range [0,") + Std.string(seq2.mLength)) + "("))
                seq2n = seq2.mSequence.h.get(idx2,None)
                if ((not seq1n.isNotPolymorphism()) or (not seq2n.isNotPolymorphism())):
                    if (seq1n.mCode != seq2n.mCode):
                        code = (seq1n.mCode & seq2n.mCode)
                        if (code != 0):
                            if (seq1n.mCode > seq2n.mCode):
                                code1 = (seq1n.mCode - seq2n.mCode)
                                newN = champuru_base_SingleNucleotide(code1)
                                toChange.add(_hx_AnonObject({'isSeq1': True, 'pos': idx1, 'newNN': newN}))
                            else:
                                code2 = (seq2n.mCode - seq1n.mCode)
                                newN1 = champuru_base_SingleNucleotide(code2)
                                toChange.add(_hx_AnonObject({'isSeq1': False, 'pos': idx2, 'newNN': newN1}))
        result = haxe_ds_List()
        if (toChange.length > 0):
            _g2_head = toChange.h
            while (_g2_head is not None):
                val = _g2_head.item
                _g2_head = _g2_head.next
                change = val
                if (result.length > 5):
                    break
                r = haxe_ds_List()
                if change.isSeq1:
                    seq1Clone = seq1.clone()
                    seq1Clone.replace(change.pos,change.newNN)
                    r1 = round
                    round = (round + 1)
                    r = champuru_reconstruction_SequenceReconstructor.reconstruct2(seq1Clone,seq2,r1)
                else:
                    seq2Clone = seq2.clone()
                    seq2Clone.replace(change.pos,change.newNN)
                    r2 = round
                    round = (round + 1)
                    r = champuru_reconstruction_SequenceReconstructor.reconstruct2(seq1,seq2Clone,r2)
                _g2_head1 = r.h
                while (_g2_head1 is not None):
                    val1 = _g2_head1.item
                    _g2_head1 = _g2_head1.next
                    e = val1
                    if (result.length > 5):
                        break
                    _this = e.seq1
                    result1 = haxe_ds_List()
                    _g = 0
                    _g1 = _this.mLength
                    while (_g < _g1):
                        i = _g
                        _g = (_g + 1)
                        c = _this.mSequence.h.get(i,None)
                        s = c.toIUPACCode()
                        result1.add(s)
                    s1 = result1.join("")
                    _this1 = e.seq2
                    result2 = haxe_ds_List()
                    _g2 = 0
                    _g3 = _this1.mLength
                    while (_g2 < _g3):
                        i1 = _g2
                        _g2 = (_g2 + 1)
                        c1 = _this1.mSequence.h.get(i1,None)
                        s2 = c1.toIUPACCode()
                        result2.add(s2)
                    s21 = result2.join("")
                    found = False
                    _g2_head2 = result.h
                    while (_g2_head2 is not None):
                        val2 = _g2_head2.item
                        _g2_head2 = _g2_head2.next
                        ele = val2
                        _this2 = e.seq1
                        result3 = haxe_ds_List()
                        _g4 = 0
                        _g5 = _this2.mLength
                        while (_g4 < _g5):
                            i2 = _g4
                            _g4 = (_g4 + 1)
                            c2 = _this2.mSequence.h.get(i2,None)
                            s3 = c2.toIUPACCode()
                            result3.add(s3)
                        s1ele = result3.join("")
                        _this3 = e.seq2
                        result4 = haxe_ds_List()
                        _g6 = 0
                        _g7 = _this3.mLength
                        while (_g6 < _g7):
                            i3 = _g6
                            _g6 = (_g6 + 1)
                            c3 = _this3.mSequence.h.get(i3,None)
                            s4 = c3.toIUPACCode()
                            result4.add(s4)
                        s2ele = result4.join("")
                        if ((s1 == s1ele) and ((s21 == s2ele))):
                            found = True
                            break
                    if (not found):
                        result.add(e)
        else:
            result.add(_hx_AnonObject({'seq1': seq1, 'seq2': seq2}))
        return result


class champuru_score_AScoreCalculator:
    _hx_class_name = "champuru.score.AScoreCalculator"
    __slots__ = ()
    _hx_methods = ["calcOverlapScores", "getName", "getDescription", "calcScore"]

    def __init__(self):
        pass

    def calcOverlapScores(self,fwd,rev):
        result = list()
        _g = (-fwd.mLength + 1)
        _g1 = rev.mLength
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            score = self.calcScore(i,fwd,rev)
            x = _hx_AnonObject({'nr': ((i - fwd.mLength) + 1), 'index': i, 'score': score.score, 'matches': score.matches, 'mismatches': score.mismatches})
            result.append(x)
        return result



class champuru_score_AmbiguityCorrectionScoreCalculator(champuru_score_AScoreCalculator):
    _hx_class_name = "champuru.score.AmbiguityCorrectionScoreCalculator"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = ["getName", "getDescription", "calcScore"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = champuru_score_AScoreCalculator


    def __init__(self):
        super().__init__()

    def getName(self):
        return "Ambiguity correction"

    def getDescription(self):
        return "A modification of the score correction method described in the Champuru 1.0 paper. The score will get corrected for the fact that ambiguous characters (e.g. W) can match multiple other characters (e.g. A, T). Preliminary results suggests that this score calculation method works better when the reconstructed consensus sequences contain a lot of ambiguities. However this score correction method seems to work less good on short input sequences."

    def calcScore(self,i,fwd,rev):
        matches = 0
        fullMatches = 0
        mismatches = 0
        fwdCorr = (-i if ((i < 0)) else 0)
        revCorr = (i if ((i > 0)) else 0)
        fwdL = (fwdCorr + rev.mLength)
        revL = (revCorr + fwd.mLength)
        overlap = (((fwdL if ((fwdL < revL)) else revL)) - ((fwdCorr + revCorr)))
        _g = 0
        _g1 = overlap
        while (_g < _g1):
            pos = _g
            _g = (_g + 1)
            i = (pos + fwdCorr)
            if (not (((0 <= i) and ((i < fwd.mLength))))):
                raise haxe_Exception.thrown((((("Position " + Std.string(i)) + " out of range [0,") + Std.string(fwd.mLength)) + "("))
            a = fwd.mSequence.h.get(i,None)
            i1 = (pos + revCorr)
            if (not (((0 <= i1) and ((i1 < rev.mLength))))):
                raise haxe_Exception.thrown((((("Position " + Std.string(i1)) + " out of range [0,") + Std.string(rev.mLength)) + "("))
            b = rev.mSequence.h.get(i1,None)
            if (a.equals(b,False) and a.isNotPolymorphism()):
                fullMatches = (fullMatches + 1)
            else:
                code = (a.mCode & b.mCode)
                if (code != 0):
                    matches = (matches + 1)
                else:
                    mismatches = (mismatches + 1)
        return _hx_AnonObject({'matches': (matches + fullMatches), 'mismatches': mismatches, 'score': ((fullMatches + ((0.5 * matches))) - ((0.25 * overlap)))})



class champuru_score_GumbelDistribution:
    _hx_class_name = "champuru.score.GumbelDistribution"
    __slots__ = ("mMu", "mBeta")
    _hx_fields = ["mMu", "mBeta"]
    _hx_methods = ["getMu", "getBeta", "getProbabilityForScore", "getProbabilityForHigherScore"]
    _hx_statics = ["eulerMascheroniConst", "getEstimatedGumbelDistribution"]

    def __init__(self,mu,beta):
        self.mMu = mu
        self.mBeta = beta

    def getMu(self):
        return self.mMu

    def getBeta(self):
        return self.mBeta

    def getProbabilityForScore(self,score):
        z = (((score - self.mMu)) / self.mBeta)
        tmp = (1.0 / self.mBeta)
        v = -z
        v1 = -((z + ((0.0 if ((v == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v))))))
        return (tmp * ((0.0 if ((v1 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v1 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v1)))))

    def getProbabilityForHigherScore(self,score):
        s = (-((score - self.mMu)) / self.mBeta)
        v = -((0.0 if ((s == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((s == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(s))))
        return (1 - ((0.0 if ((v == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v)))))

    @staticmethod
    def getEstimatedGumbelDistribution(mean,deviation):
        beta = ((python_lib_Math.sqrt(6) * deviation) / Math.PI)
        mu = (mean - ((champuru_score_GumbelDistribution.eulerMascheroniConst * beta)))
        return champuru_score_GumbelDistribution(mu,beta)



class champuru_score_GumbelDistributionEstimator:
    _hx_class_name = "champuru.score.GumbelDistributionEstimator"
    __slots__ = ("mSeq1", "mSeq2")
    _hx_fields = ["mSeq1", "mSeq2"]
    _hx_methods = ["shuffleSequence", "calculateMean", "calculateVar", "randI", "calculate"]

    def __init__(self,seq1,seq2):
        self.mSeq1 = seq1
        self.mSeq2 = seq2

    def shuffleSequence(self,s):
        copySequence = haxe_ds_List()
        sLen = s.mLength
        _g = 0
        _g1 = sLen
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            randomPos = Math.floor((python_lib_Random.random() * sLen))
            if (not (((0 <= randomPos) and ((randomPos < s.mLength))))):
                raise haxe_Exception.thrown((((("Position " + Std.string(randomPos)) + " out of range [0,") + Std.string(s.mLength)) + "("))
            newNN = s.mSequence.h.get(randomPos,None)
            copySequence.add(newNN)
        result = champuru_base_NucleotideSequence(copySequence)
        return result

    def calculateMean(self,scores):
        summe = 0.0
        _g_head = scores.h
        while (_g_head is not None):
            val = _g_head.item
            _g_head = _g_head.next
            score = val
            summe = (summe + score)
        return (summe / scores.length)

    def calculateVar(self,scores,mean):
        summe = 0.0
        _g_head = scores.h
        while (_g_head is not None):
            val = _g_head.item
            _g_head = _g_head.next
            score = val
            diff = (score - mean)
            summe = (summe + ((diff * diff)))
        return (summe / ((scores.length - 1)))

    def randI(self,a,b):
        result = 0
        rand = python_lib_Random.random()
        if (rand > 0.5):
            result = Math.floor((a * python_lib_Random.random()))
        else:
            result = Math.floor((b * python_lib_Random.random()))
        return result

    def calculate(self,scoreCalculator):
        scores = haxe_ds_List()
        _g = 0
        while (_g < 20):
            i = _g
            _g = (_g + 1)
            _g1 = 0
            while (_g1 < 100):
                j = _g1
                _g1 = (_g1 + 1)
                s = self.mSeq1
                copySequence = haxe_ds_List()
                sLen = s.mLength
                _g2 = 0
                _g3 = sLen
                while (_g2 < _g3):
                    i1 = _g2
                    _g2 = (_g2 + 1)
                    randomPos = Math.floor((python_lib_Random.random() * sLen))
                    if (not (((0 <= randomPos) and ((randomPos < s.mLength))))):
                        raise haxe_Exception.thrown((((("Position " + Std.string(randomPos)) + " out of range [0,") + Std.string(s.mLength)) + "("))
                    newNN = s.mSequence.h.get(randomPos,None)
                    copySequence.add(newNN)
                result = champuru_base_NucleotideSequence(copySequence)
                randomFwd = result
                s1 = self.mSeq2
                copySequence1 = haxe_ds_List()
                sLen1 = s1.mLength
                _g4 = 0
                _g5 = sLen1
                while (_g4 < _g5):
                    i2 = _g4
                    _g4 = (_g4 + 1)
                    randomPos1 = Math.floor((python_lib_Random.random() * sLen1))
                    if (not (((0 <= randomPos1) and ((randomPos1 < s1.mLength))))):
                        raise haxe_Exception.thrown((((("Position " + Std.string(randomPos1)) + " out of range [0,") + Std.string(s1.mLength)) + "("))
                    newNN1 = s1.mSequence.h.get(randomPos1,None)
                    copySequence1.add(newNN1)
                result1 = champuru_base_NucleotideSequence(copySequence1)
                randomRev = result1
                a = -randomFwd.mLength
                b = randomRev.mLength
                result2 = 0
                rand = python_lib_Random.random()
                if (rand > 0.5):
                    result2 = Math.floor((a * python_lib_Random.random()))
                else:
                    result2 = Math.floor((b * python_lib_Random.random()))
                randPos = result2
                score = scoreCalculator.calcScore(randPos,randomFwd,randomRev)
                scores.add(score.score)
        summe = 0.0
        _g_head = scores.h
        while (_g_head is not None):
            val = _g_head.item
            _g_head = _g_head.next
            score = val
            summe = (summe + score)
        mean = (summe / scores.length)
        summe = 0.0
        _g_head = scores.h
        while (_g_head is not None):
            val = _g_head.item
            _g_head = _g_head.next
            score = val
            diff = (score - mean)
            summe = (summe + ((diff * diff)))
        v = (summe / ((scores.length - 1)))
        deviation = (Math.NaN if ((v < 0)) else python_lib_Math.sqrt(v))
        beta = ((python_lib_Math.sqrt(6) * deviation) / Math.PI)
        mu = (mean - ((champuru_score_GumbelDistribution.eulerMascheroniConst * beta)))
        return champuru_score_GumbelDistribution(mu,beta)



class champuru_score_LongestLengthScoreCalculator(champuru_score_AScoreCalculator):
    _hx_class_name = "champuru.score.LongestLengthScoreCalculator"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = ["getName", "getDescription", "calcScore"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = champuru_score_AScoreCalculator


    def __init__(self):
        super().__init__()

    def getName(self):
        return "Longest Length"

    def getDescription(self):
        return "Take the longest number of consecutive matching nucleotides as score."

    def calcScore(self,i,fwd,rev):
        matches = 0
        mismatches = 0
        fwdCorr = (-i if ((i < 0)) else 0)
        revCorr = (i if ((i > 0)) else 0)
        fwdL = (fwdCorr + rev.mLength)
        revL = (revCorr + fwd.mLength)
        overlap = (((fwdL if ((fwdL < revL)) else revL)) - ((fwdCorr + revCorr)))
        maxScore = 0
        cScore = 0
        _g = 0
        _g1 = overlap
        while (_g < _g1):
            pos = _g
            _g = (_g + 1)
            i = (pos + fwdCorr)
            if (not (((0 <= i) and ((i < fwd.mLength))))):
                raise haxe_Exception.thrown((((("Position " + Std.string(i)) + " out of range [0,") + Std.string(fwd.mLength)) + "("))
            a = fwd.mSequence.h.get(i,None)
            i1 = (pos + revCorr)
            if (not (((0 <= i1) and ((i1 < rev.mLength))))):
                raise haxe_Exception.thrown((((("Position " + Std.string(i1)) + " out of range [0,") + Std.string(rev.mLength)) + "("))
            b = rev.mSequence.h.get(i1,None)
            code = (a.mCode & b.mCode)
            if (code != 0):
                matches = (matches + 1)
                cScore = (cScore + 1)
            else:
                mismatches = (mismatches + 1)
                cScore = 0
            if (maxScore <= cScore):
                maxScore = cScore
        return _hx_AnonObject({'matches': matches, 'mismatches': mismatches, 'score': maxScore})



class champuru_score_PaperScoreCalculator(champuru_score_AScoreCalculator):
    _hx_class_name = "champuru.score.PaperScoreCalculator"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = ["getName", "getDescription", "calcScore"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = champuru_score_AScoreCalculator


    def __init__(self):
        super().__init__()

    def getName(self):
        return "Paper"

    def getDescription(self):
        return "The score correction method described in the Champuru 1.0 paper."

    def calcScore(self,i,fwd,rev):
        matches = 0
        mismatches = 0
        fwdCorr = (-i if ((i < 0)) else 0)
        revCorr = (i if ((i > 0)) else 0)
        fwdL = (fwdCorr + rev.mLength)
        revL = (revCorr + fwd.mLength)
        overlap = (((fwdL if ((fwdL < revL)) else revL)) - ((fwdCorr + revCorr)))
        _g = 0
        _g1 = overlap
        while (_g < _g1):
            pos = _g
            _g = (_g + 1)
            i = (pos + fwdCorr)
            if (not (((0 <= i) and ((i < fwd.mLength))))):
                raise haxe_Exception.thrown((((("Position " + Std.string(i)) + " out of range [0,") + Std.string(fwd.mLength)) + "("))
            a = fwd.mSequence.h.get(i,None)
            i1 = (pos + revCorr)
            if (not (((0 <= i1) and ((i1 < rev.mLength))))):
                raise haxe_Exception.thrown((((("Position " + Std.string(i1)) + " out of range [0,") + Std.string(rev.mLength)) + "("))
            b = rev.mSequence.h.get(i1,None)
            code = (a.mCode & b.mCode)
            if (code != 0):
                matches = (matches + 1)
            else:
                mismatches = (mismatches + 1)
        return _hx_AnonObject({'matches': matches, 'mismatches': mismatches, 'score': (matches - ((0.25 * overlap)))})



class champuru_score_ScoreCalculatorList:
    _hx_class_name = "champuru.score.ScoreCalculatorList"
    __slots__ = ("mLst",)
    _hx_fields = ["mLst"]
    _hx_methods = ["length", "getDefaultScoreCalculatorIndex", "getDefaultScoreCalculator", "getScoreCalculator"]
    _hx_statics = ["sInstance", "instance"]

    def __init__(self):
        this1 = [None]*3
        self.mLst = this1
        this1 = self.mLst
        val = champuru_score_PaperScoreCalculator()
        this1[0] = val
        this1 = self.mLst
        val = champuru_score_AmbiguityCorrectionScoreCalculator()
        this1[1] = val
        this1 = self.mLst
        val = champuru_score_LongestLengthScoreCalculator()
        this1[2] = val

    def length(self):
        return len(self.mLst)

    def getDefaultScoreCalculatorIndex(self):
        return 1

    def getDefaultScoreCalculator(self):
        idx = 1
        return self.mLst[idx]

    def getScoreCalculator(self,i):
        result = None
        if ((0 <= i) and ((i < len(self.mLst)))):
            result = self.mLst[i]
        return result
    sInstance = None

    @staticmethod
    def instance():
        if (champuru_score_ScoreCalculatorList.sInstance is None):
            champuru_score_ScoreCalculatorList.sInstance = champuru_score_ScoreCalculatorList()
        return champuru_score_ScoreCalculatorList.sInstance



class champuru_score_ScoreListVisualizer:
    _hx_class_name = "champuru.score.ScoreListVisualizer"
    __slots__ = ("scores", "sortedScores", "high", "low")
    _hx_fields = ["scores", "sortedScores", "high", "low"]
    _hx_methods = ["genScorePlot", "genScorePlotHist"]

    def __init__(self,scores,sortedScores):
        self.scores = scores
        self.sortedScores = sortedScores
        self.high = (sortedScores[0] if 0 < len(sortedScores) else None).score
        lowScore = (None if ((len(sortedScores) == 0)) else sortedScores.pop())
        sortedScores.append(lowScore)
        self.low = lowScore.score

    def genScorePlot(self):
        result = haxe_ds_List()
        result.add("<svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' id='scorePlot' class='plot middle' width='600' height='400'>")
        result.add("<rect width='600' height='400' style='fill:white' />")
        result.add("<text x='010' y='200' text-anchor='middle' style='font-family: monospace; text-size: 12.5px' transform='rotate(270 7.5 195)'>Score</text>")
        result.add("<text x='300' y='395' text-anchor='middle' style='font-family: monospace; text-size: 12.5px'>Offset</text>")
        d = (self.high - self.low)
        i = 0
        _g = 0
        _g1 = self.scores
        while (_g < len(_g1)):
            score = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
            _g = (_g + 1)
            x = (30 + ((560.0 * ((i / len(self.scores))))))
            y = (370 - ((350 * ((((score.score - self.low)) / d)))))
            alertMsg = ((((((("Offset: " + Std.string(score.index)) + "\\nScore: ") + Std.string(score.score)) + "\\nMatches: ") + Std.string(score.matches)) + "\\nMismatches: ") + Std.string(score.mismatches))
            result.add((((((((((("<circle id='c" + Std.string(score.index)) + "' cx='") + Std.string(x)) + "' cy='") + Std.string(y)) + "' r='2' fill='black' title='") + Std.string(1)) + "' onclick='alert(\"") + ("null" if alertMsg is None else alertMsg)) + "\")' />"))
            i = (i + 1)
        result.add("</svg>")
        return result.join("")

    def genScorePlotHist(self,distribution):
        d = (self.high - self.low)
        result = haxe_ds_List()
        result.add("<svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' id='scorePlotHist' class='plot middle' width='600' height='400'>")
        result.add("<rect width='600' height='400' style='fill:white' />")
        result.add("<text x='010' y='200' text-anchor='middle' style='font-family: monospace; text-size: 12.5px' transform='rotate(270 7.5 195)'>Frequency</text>")
        result.add("<text x='025' y='200' text-anchor='middle' style='font-family: monospace; text-size: 12.5px' transform='rotate(270 20.5 195)'>Probability</text>")
        result.add("<text x='380' y='020' text-anchor='start' style='font-family: monospace; text-size: 12.5px; fill: #0ff'>P (higher score)</text>")
        result.add("<text x='380' y='035' text-anchor='start' style='font-family: monospace; text-size: 12.5px; fill: #00f'>P (score)</text>")
        result.add("<text x='300' y='395' text-anchor='start' style='font-family: monospace; text-size: 12.5px'>Score</text>")
        result.add((("<text x='030' y='380' text-anchor='middle' style='font-family: monospace; text-size: 12.5px'>" + Std.string(Math.floor(self.low))) + "</text>"))
        result.add((("<text x='170' y='380' text-anchor='middle' style='font-family: monospace; text-size: 12.5px'>" + Std.string(Math.floor(((d / 4) + 0.5)))) + "</text>"))
        result.add((("<text x='310' y='380' text-anchor='middle' style='font-family: monospace; text-size: 12.5px'>" + Std.string(Math.floor(((d / 2) + 0.5)))) + "</text>"))
        result.add((("<text x='450' y='380' text-anchor='middle' style='font-family: monospace; text-size: 12.5px'>" + Std.string(Math.floor((((d / 4) * 3) + 0.5)))) + "</text>"))
        result.add((("<text x='590' y='380' text-anchor='end' style='font-family: monospace; text-size: 12.5px'>" + Std.string(Math.ceil(self.high))) + "</text>"))
        hd = (d / 28)
        i = 0
        this1 = [None]*28
        v = this1
        this1 = [None]*29
        _hx_from = this1
        _g = 0
        while (_g < 28):
            i = _g
            _g = (_g + 1)
            v[i] = 0
            val = (self.low + ((i * hd)))
            _hx_from[i] = val
        val = Math.ceil((self.high + 0.1))
        _hx_from[28] = val
        _g = 0
        _g1 = self.sortedScores
        while (_g < len(_g1)):
            score = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
            _g = (_g + 1)
            pointer = 0
            while (not (((_hx_from[pointer] <= score.score) and ((score.score < _hx_from[(pointer + 1)]))))):
                pointer = (pointer + 1)
            tmp = pointer
            val = (v[tmp] + 1)
            v[tmp] = val
        highest = 0
        _g = 0
        while (_g < len(v)):
            val = v[_g]
            _g = (_g + 1)
            if (highest <= val):
                highest = val
        result.add("<g style='stroke-width:1;stroke:#000;fill:#fff'>")
        _g = 0
        while (_g < 28):
            i = _g
            _g = (_g + 1)
            if (v[i] == 0):
                continue
            val = (v[i] / highest)
            x = (30 + ((i * 20)))
            h = (val * 350)
            y = (365 - h)
            fromX = _hx_from[i]
            to = _hx_from[(i + 1)]
            percentage = (Math.floor((((v[i] / len(self.sortedScores)) * 1000) + 0.5)) / 10.0)
            z = (((fromX - distribution.mMu)) / distribution.mBeta)
            v1 = (1.0 / distribution.mBeta)
            v2 = -z
            v3 = -((z + ((0.0 if ((v2 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v2 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v2))))))
            pval1 = (Math.floor((((v1 * ((0.0 if ((v3 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v3 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v3))))) * 1000) + 0.5)) / 1000)
            z1 = (((to - distribution.mMu)) / distribution.mBeta)
            v4 = (1.0 / distribution.mBeta)
            v5 = -z1
            v6 = -((z1 + ((0.0 if ((v5 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v5 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v5))))))
            pval2 = (Math.floor((((v4 * ((0.0 if ((v6 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v6 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v6))))) * 1000) + 0.5)) / 1000)
            s = (-((fromX - distribution.mMu)) / distribution.mBeta)
            v7 = -((0.0 if ((s == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((s == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(s))))
            v8 = (0.0 if ((v7 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v7 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v7)))
            s1 = (-((to - distribution.mMu)) / distribution.mBeta)
            v9 = -((0.0 if ((s1 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((s1 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(s1))))
            cdfVal = (Math.floor((((((1 - v8) - ((1 - ((0.0 if ((v9 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v9 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v9)))))))) * 1000) + 0.5)) / 1000)
            alertMsg = ((((((((((((("From: " + Std.string(fromX)) + "\\nTo: ") + Std.string(to)) + "\\nCount: ") + Std.string(v[i])) + " (") + Std.string(percentage)) + "%)\\nProbability from: ") + Std.string(pval1)) + "-") + Std.string(pval2)) + "\\nCDF: ") + Std.string(cdfVal))
            result.add((((((((((((((("<rect id='histBox" + Std.string(i)) + "' from='") + Std.string(fromX)) + "' to='") + Std.string(to)) + "' x='") + Std.string(x)) + "' y='") + Std.string(y)) + "' width='20' height='") + Std.string(h)) + "' onclick='alert(\"") + ("null" if alertMsg is None else alertMsg)) + "\");' />"))
        result.add("</g>")
        highestPVal = 0
        listOfPoints = haxe_ds_List()
        _g = 0
        while (_g < 28):
            i = _g
            _g = (_g + 1)
            val = ((i * hd) + self.low)
            z = (((val - distribution.mMu)) / distribution.mBeta)
            pval = (1.0 / distribution.mBeta)
            v = -z
            v1 = -((z + ((0.0 if ((v == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v))))))
            pval1 = (pval * ((0.0 if ((v1 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v1 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v1)))))
            s = (-((val - distribution.mMu)) / distribution.mBeta)
            v2 = -((0.0 if ((s == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((s == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(s))))
            d = (1 - ((0.0 if ((v2 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v2 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v2)))))
            listOfPoints.add(_hx_AnonObject({'x': val, 'y': pval1, 'i': i, 'd': d}))
            if (not ((highestPVal > pval1))):
                highestPVal = pval1
            val = ((((((i * hd) + self.low)) * 3) / 4) + (((((((i + 1)) * hd) + self.low)) / 4)))
            z1 = (((val - distribution.mMu)) / distribution.mBeta)
            pval2 = (1.0 / distribution.mBeta)
            v3 = -z1
            v4 = -((z1 + ((0.0 if ((v3 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v3 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v3))))))
            pval1 = (pval2 * ((0.0 if ((v4 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v4 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v4)))))
            s1 = (-((val - distribution.mMu)) / distribution.mBeta)
            v5 = -((0.0 if ((s1 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((s1 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(s1))))
            d = (1 - ((0.0 if ((v5 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v5 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v5)))))
            if (not ((highestPVal > pval1))):
                highestPVal = pval1
            listOfPoints.add(_hx_AnonObject({'x': val, 'y': pval1, 'i': (i + 0.25), 'd': d}))
            val = (((((i * hd) + self.low) + (((((i + 1)) * hd) + self.low)))) / 2)
            z2 = (((val - distribution.mMu)) / distribution.mBeta)
            pval3 = (1.0 / distribution.mBeta)
            v6 = -z2
            v7 = -((z2 + ((0.0 if ((v6 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v6 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v6))))))
            pval1 = (pval3 * ((0.0 if ((v7 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v7 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v7)))))
            s2 = (-((val - distribution.mMu)) / distribution.mBeta)
            v8 = -((0.0 if ((s2 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((s2 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(s2))))
            d = (1 - ((0.0 if ((v8 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v8 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v8)))))
            if (not ((highestPVal > pval1))):
                highestPVal = pval1
            listOfPoints.add(_hx_AnonObject({'x': val, 'y': pval1, 'i': (i + 0.5), 'd': d}))
            val = (((((i * hd) + self.low)) / 4) + ((((((((i + 1)) * hd) + self.low)) * 3) / 4)))
            z3 = (((val - distribution.mMu)) / distribution.mBeta)
            pval4 = (1.0 / distribution.mBeta)
            v9 = -z3
            v10 = -((z3 + ((0.0 if ((v9 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v9 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v9))))))
            pval1 = (pval4 * ((0.0 if ((v10 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v10 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v10)))))
            s3 = (-((val - distribution.mMu)) / distribution.mBeta)
            v11 = -((0.0 if ((s3 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((s3 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(s3))))
            d = (1 - ((0.0 if ((v11 == Math.NEGATIVE_INFINITY)) else (Math.POSITIVE_INFINITY if ((v11 == Math.POSITIVE_INFINITY)) else Reflect.field(Math,"exp")(v11)))))
            if (not ((highestPVal > pval1))):
                highestPVal = pval1
            listOfPoints.add(_hx_AnonObject({'x': val, 'y': pval1, 'i': (i + 0.75), 'd': d}))
        result.add("<g style='stroke-width:1;stroke:#00f;'>")
        lastX = -1
        lastY = -1
        lastY2 = -1
        _g6_head = listOfPoints.h
        while (_g6_head is not None):
            val = _g6_head.item
            _g6_head = _g6_head.next
            obj = val
            val1 = obj.x
            pval = obj.y
            x = (30 + ((obj.i * 20)))
            h = ((pval / highestPVal) * 350)
            y = (365 - h)
            y2 = (365 - ((obj.d * 350)))
            if ((lastX != -1) and ((lastY != -1))):
                result.add((((((((("<line x1='" + Std.string(lastX)) + "' y1='") + Std.string(lastY)) + "' x2='") + Std.string(x)) + "' y2='") + Std.string(y)) + "'/>"))
                result.add((((((((("<line x1='" + Std.string(lastX)) + "' y1='") + Std.string(lastY2)) + "' x2='") + Std.string(x)) + "' y2='") + Std.string(y2)) + "' style='stroke:#0ff'/>"))
            lastX = x
            lastY = y
            lastY2 = y2
        result.add("</g>")
        result.add("</svg>")
        return result.join("")



class champuru_score_ScoreSorter:
    _hx_class_name = "champuru.score.ScoreSorter"
    __slots__ = ()
    _hx_methods = ["sort"]

    def __init__(self):
        pass

    def sort(self,scores):
        result = list(scores)
        def _hx_local_0(a,b):
            result = (b.score - a.score)
            if (result == 0):
                return (a.mismatches - b.mismatches)
            elif (result > 0):
                return 1
            return -1
        result.sort(key= python_lib_Functools.cmp_to_key(_hx_local_0))
        return result



class haxe_IMap:
    _hx_class_name = "haxe.IMap"
    __slots__ = ()


class haxe_Exception(Exception):
    _hx_class_name = "haxe.Exception"
    __slots__ = ("_hx___nativeStack", "_hx___skipStack", "_hx___nativeException", "_hx___previousException")
    _hx_fields = ["__nativeStack", "__skipStack", "__nativeException", "__previousException"]
    _hx_methods = ["unwrap", "get_native"]
    _hx_statics = ["caught", "thrown"]
    _hx_interfaces = []
    _hx_super = Exception


    def __init__(self,message,previous = None,native = None):
        self._hx___previousException = None
        self._hx___nativeException = None
        self._hx___nativeStack = None
        self._hx___skipStack = 0
        super().__init__(message)
        self._hx___previousException = previous
        if ((native is not None) and Std.isOfType(native,BaseException)):
            self._hx___nativeException = native
            self._hx___nativeStack = haxe_NativeStackTrace.exceptionStack()
        else:
            self._hx___nativeException = self
            infos = python_lib_Traceback.extract_stack()
            if (len(infos) != 0):
                infos.pop()
            infos.reverse()
            self._hx___nativeStack = infos

    def unwrap(self):
        return self._hx___nativeException

    def get_native(self):
        return self._hx___nativeException

    @staticmethod
    def caught(value):
        if Std.isOfType(value,haxe_Exception):
            return value
        elif Std.isOfType(value,BaseException):
            return haxe_Exception(str(value),None,value)
        else:
            return haxe_ValueException(value,None,value)

    @staticmethod
    def thrown(value):
        if Std.isOfType(value,haxe_Exception):
            return value.get_native()
        elif Std.isOfType(value,BaseException):
            return value
        else:
            e = haxe_ValueException(value)
            e._hx___skipStack = (e._hx___skipStack + 1)
            return e



class haxe_NativeStackTrace:
    _hx_class_name = "haxe.NativeStackTrace"
    __slots__ = ()
    _hx_statics = ["saveStack", "exceptionStack"]

    @staticmethod
    def saveStack(exception):
        pass

    @staticmethod
    def exceptionStack():
        exc = python_lib_Sys.exc_info()
        if (exc[2] is not None):
            infos = python_lib_Traceback.extract_tb(exc[2])
            infos.reverse()
            return infos
        else:
            return []


class haxe_ValueException(haxe_Exception):
    _hx_class_name = "haxe.ValueException"
    __slots__ = ("value",)
    _hx_fields = ["value"]
    _hx_methods = ["unwrap"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = haxe_Exception


    def __init__(self,value,previous = None,native = None):
        self.value = None
        super().__init__(Std.string(value),previous,native)
        self.value = value

    def unwrap(self):
        return self.value



class haxe_io_Bytes:
    _hx_class_name = "haxe.io.Bytes"
    __slots__ = ("length", "b")
    _hx_fields = ["length", "b"]
    _hx_methods = ["getString", "toString"]
    _hx_statics = ["alloc", "ofString"]

    def __init__(self,length,b):
        self.length = length
        self.b = b

    def getString(self,pos,_hx_len,encoding = None):
        tmp = (encoding is None)
        if (((pos < 0) or ((_hx_len < 0))) or (((pos + _hx_len) > self.length))):
            raise haxe_Exception.thrown(haxe_io_Error.OutsideBounds)
        return self.b[pos:pos+_hx_len].decode('UTF-8','replace')

    def toString(self):
        return self.getString(0,self.length)

    @staticmethod
    def alloc(length):
        return haxe_io_Bytes(length,bytearray(length))

    @staticmethod
    def ofString(s,encoding = None):
        b = bytearray(s,"UTF-8")
        return haxe_io_Bytes(len(b),b)



class haxe_crypto_Base64:
    _hx_class_name = "haxe.crypto.Base64"
    __slots__ = ()
    _hx_statics = ["CHARS", "BYTES", "encode"]

    @staticmethod
    def encode(_hx_bytes,complement = None):
        if (complement is None):
            complement = True
        _hx_str = haxe_crypto_BaseCode(haxe_crypto_Base64.BYTES).encodeBytes(_hx_bytes).toString()
        if complement:
            _g = HxOverrides.mod(_hx_bytes.length, 3)
            if (_g == 1):
                _hx_str = (("null" if _hx_str is None else _hx_str) + "==")
            elif (_g == 2):
                _hx_str = (("null" if _hx_str is None else _hx_str) + "=")
            else:
                pass
        return _hx_str


class haxe_crypto_BaseCode:
    _hx_class_name = "haxe.crypto.BaseCode"
    __slots__ = ("base", "nbits")
    _hx_fields = ["base", "nbits"]
    _hx_methods = ["encodeBytes"]

    def __init__(self,base):
        _hx_len = base.length
        nbits = 1
        while (_hx_len > ((1 << nbits))):
            nbits = (nbits + 1)
        if ((nbits > 8) or ((_hx_len != ((1 << nbits))))):
            raise haxe_Exception.thrown("BaseCode : base length must be a power of two.")
        self.base = base
        self.nbits = nbits

    def encodeBytes(self,b):
        nbits = self.nbits
        base = self.base
        x = ((b.length * 8) / nbits)
        size = None
        try:
            size = int(x)
        except BaseException as _g:
            None
            size = None
        out = haxe_io_Bytes.alloc((size + ((0 if ((HxOverrides.mod((b.length * 8), nbits) == 0)) else 1))))
        buf = 0
        curbits = 0
        mask = (((1 << nbits)) - 1)
        pin = 0
        pout = 0
        while (pout < size):
            while (curbits < nbits):
                curbits = (curbits + 8)
                buf = (buf << 8)
                pos = pin
                pin = (pin + 1)
                buf = (buf | b.b[pos])
            curbits = (curbits - nbits)
            pos1 = pout
            pout = (pout + 1)
            v = base.b[((buf >> curbits) & mask)]
            out.b[pos1] = (v & 255)
        if (curbits > 0):
            pos = pout
            pout = (pout + 1)
            v = base.b[((buf << ((nbits - curbits))) & mask)]
            out.b[pos] = (v & 255)
        return out



class haxe_ds_IntMap:
    _hx_class_name = "haxe.ds.IntMap"
    __slots__ = ("h",)
    _hx_fields = ["h"]
    _hx_methods = ["set", "keys"]
    _hx_interfaces = [haxe_IMap]

    def __init__(self):
        self.h = dict()

    def set(self,key,value):
        self.h[key] = value

    def keys(self):
        return python_HaxeIterator(iter(self.h.keys()))



class haxe_ds__List_ListNode:
    _hx_class_name = "haxe.ds._List.ListNode"
    __slots__ = ("item", "next")
    _hx_fields = ["item", "next"]

    def __init__(self,item,next):
        self.item = item
        self.next = next



class haxe_ds__List_ListIterator:
    _hx_class_name = "haxe.ds._List.ListIterator"
    __slots__ = ("head",)
    _hx_fields = ["head"]
    _hx_methods = ["hasNext", "next"]

    def __init__(self,head):
        self.head = head

    def hasNext(self):
        return (self.head is not None)

    def next(self):
        val = self.head.item
        self.head = self.head.next
        return val



class haxe_ds_ObjectMap:
    _hx_class_name = "haxe.ds.ObjectMap"
    __slots__ = ("h",)
    _hx_fields = ["h"]
    _hx_methods = ["set"]
    _hx_interfaces = [haxe_IMap]

    def __init__(self):
        self.h = dict()

    def set(self,key,value):
        self.h[key] = value



class haxe_ds_StringMap:
    _hx_class_name = "haxe.ds.StringMap"
    __slots__ = ("h",)
    _hx_fields = ["h"]
    _hx_interfaces = [haxe_IMap]

    def __init__(self):
        self.h = dict()


class haxe_io_Encoding(Enum):
    __slots__ = ()
    _hx_class_name = "haxe.io.Encoding"
    _hx_constructs = ["UTF8", "RawNative"]
haxe_io_Encoding.UTF8 = haxe_io_Encoding("UTF8", 0, ())
haxe_io_Encoding.RawNative = haxe_io_Encoding("RawNative", 1, ())

class haxe_io_Error(Enum):
    __slots__ = ()
    _hx_class_name = "haxe.io.Error"
    _hx_constructs = ["Blocked", "Overflow", "OutsideBounds", "Custom"]

    @staticmethod
    def Custom(e):
        return haxe_io_Error("Custom", 3, (e,))
haxe_io_Error.Blocked = haxe_io_Error("Blocked", 0, ())
haxe_io_Error.Overflow = haxe_io_Error("Overflow", 1, ())
haxe_io_Error.OutsideBounds = haxe_io_Error("OutsideBounds", 2, ())


class haxe_iterators_ArrayIterator:
    _hx_class_name = "haxe.iterators.ArrayIterator"
    __slots__ = ("array", "current")
    _hx_fields = ["array", "current"]
    _hx_methods = ["hasNext", "next"]

    def __init__(self,array):
        self.current = 0
        self.array = array

    def hasNext(self):
        return (self.current < len(self.array))

    def next(self):
        def _hx_local_3():
            def _hx_local_2():
                _hx_local_0 = self
                _hx_local_1 = _hx_local_0.current
                _hx_local_0.current = (_hx_local_1 + 1)
                return _hx_local_1
            return python_internal_ArrayImpl._get(self.array, _hx_local_2())
        return _hx_local_3()



class haxe_iterators_ArrayKeyValueIterator:
    _hx_class_name = "haxe.iterators.ArrayKeyValueIterator"
    __slots__ = ("current", "array")
    _hx_fields = ["current", "array"]
    _hx_methods = ["hasNext", "next"]

    def __init__(self,array):
        self.current = 0
        self.array = array

    def hasNext(self):
        return (self.current < len(self.array))

    def next(self):
        def _hx_local_3():
            def _hx_local_2():
                _hx_local_0 = self
                _hx_local_1 = _hx_local_0.current
                _hx_local_0.current = (_hx_local_1 + 1)
                return _hx_local_1
            return _hx_AnonObject({'value': python_internal_ArrayImpl._get(self.array, self.current), 'key': _hx_local_2()})
        return _hx_local_3()



class python_Boot:
    _hx_class_name = "python.Boot"
    __slots__ = ()
    _hx_statics = ["keywords", "toString1", "fields", "simpleField", "field", "getInstanceFields", "getSuperClass", "getClassFields", "prefixLength", "unhandleKeywords"]

    @staticmethod
    def toString1(o,s):
        if (o is None):
            return "null"
        if isinstance(o,str):
            return o
        if (s is None):
            s = ""
        if (len(s) >= 5):
            return "<...>"
        if isinstance(o,bool):
            if o:
                return "true"
            else:
                return "false"
        if (isinstance(o,int) and (not isinstance(o,bool))):
            return str(o)
        if isinstance(o,float):
            try:
                if (o == int(o)):
                    return str(Math.floor((o + 0.5)))
                else:
                    return str(o)
            except BaseException as _g:
                None
                return str(o)
        if isinstance(o,list):
            o1 = o
            l = len(o1)
            st = "["
            s = (("null" if s is None else s) + "\t")
            _g = 0
            _g1 = l
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                prefix = ""
                if (i > 0):
                    prefix = ","
                st = (("null" if st is None else st) + HxOverrides.stringOrNull(((("null" if prefix is None else prefix) + HxOverrides.stringOrNull(python_Boot.toString1((o1[i] if i >= 0 and i < len(o1) else None),s))))))
            st = (("null" if st is None else st) + "]")
            return st
        try:
            if hasattr(o,"toString"):
                return o.toString()
        except BaseException as _g:
            None
        if hasattr(o,"__class__"):
            if isinstance(o,_hx_AnonObject):
                toStr = None
                try:
                    fields = python_Boot.fields(o)
                    _g = []
                    _g1 = 0
                    while (_g1 < len(fields)):
                        f = (fields[_g1] if _g1 >= 0 and _g1 < len(fields) else None)
                        _g1 = (_g1 + 1)
                        x = ((("" + ("null" if f is None else f)) + " : ") + HxOverrides.stringOrNull(python_Boot.toString1(python_Boot.simpleField(o,f),(("null" if s is None else s) + "\t"))))
                        _g.append(x)
                    fieldsStr = _g
                    toStr = (("{ " + HxOverrides.stringOrNull(", ".join([x1 for x1 in fieldsStr]))) + " }")
                except BaseException as _g:
                    None
                    return "{ ... }"
                if (toStr is None):
                    return "{ ... }"
                else:
                    return toStr
            if isinstance(o,Enum):
                o1 = o
                l = len(o1.params)
                hasParams = (l > 0)
                if hasParams:
                    paramsStr = ""
                    _g = 0
                    _g1 = l
                    while (_g < _g1):
                        i = _g
                        _g = (_g + 1)
                        prefix = ""
                        if (i > 0):
                            prefix = ","
                        paramsStr = (("null" if paramsStr is None else paramsStr) + HxOverrides.stringOrNull(((("null" if prefix is None else prefix) + HxOverrides.stringOrNull(python_Boot.toString1(o1.params[i],s))))))
                    return (((HxOverrides.stringOrNull(o1.tag) + "(") + ("null" if paramsStr is None else paramsStr)) + ")")
                else:
                    return o1.tag
            if hasattr(o,"_hx_class_name"):
                if (o.__class__.__name__ != "type"):
                    fields = python_Boot.getInstanceFields(o)
                    _g = []
                    _g1 = 0
                    while (_g1 < len(fields)):
                        f = (fields[_g1] if _g1 >= 0 and _g1 < len(fields) else None)
                        _g1 = (_g1 + 1)
                        x = ((("" + ("null" if f is None else f)) + " : ") + HxOverrides.stringOrNull(python_Boot.toString1(python_Boot.simpleField(o,f),(("null" if s is None else s) + "\t"))))
                        _g.append(x)
                    fieldsStr = _g
                    toStr = (((HxOverrides.stringOrNull(o._hx_class_name) + "( ") + HxOverrides.stringOrNull(", ".join([x1 for x1 in fieldsStr]))) + " )")
                    return toStr
                else:
                    fields = python_Boot.getClassFields(o)
                    _g = []
                    _g1 = 0
                    while (_g1 < len(fields)):
                        f = (fields[_g1] if _g1 >= 0 and _g1 < len(fields) else None)
                        _g1 = (_g1 + 1)
                        x = ((("" + ("null" if f is None else f)) + " : ") + HxOverrides.stringOrNull(python_Boot.toString1(python_Boot.simpleField(o,f),(("null" if s is None else s) + "\t"))))
                        _g.append(x)
                    fieldsStr = _g
                    toStr = (((("#" + HxOverrides.stringOrNull(o._hx_class_name)) + "( ") + HxOverrides.stringOrNull(", ".join([x1 for x1 in fieldsStr]))) + " )")
                    return toStr
            if ((type(o) == type) and (o == str)):
                return "#String"
            if ((type(o) == type) and (o == list)):
                return "#Array"
            if callable(o):
                return "function"
            try:
                if hasattr(o,"__repr__"):
                    return o.__repr__()
            except BaseException as _g:
                None
            if hasattr(o,"__str__"):
                return o.__str__([])
            if hasattr(o,"__name__"):
                return o.__name__
            return "???"
        else:
            return str(o)

    @staticmethod
    def fields(o):
        a = []
        if (o is not None):
            if hasattr(o,"_hx_fields"):
                fields = o._hx_fields
                if (fields is not None):
                    return list(fields)
            if isinstance(o,_hx_AnonObject):
                d = o.__dict__
                keys = d.keys()
                handler = python_Boot.unhandleKeywords
                for k in keys:
                    if (k != '_hx_disable_getattr'):
                        a.append(handler(k))
            elif hasattr(o,"__dict__"):
                d = o.__dict__
                keys1 = d.keys()
                for k in keys1:
                    a.append(k)
        return a

    @staticmethod
    def simpleField(o,field):
        if (field is None):
            return None
        field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
        if hasattr(o,field1):
            return getattr(o,field1)
        else:
            return None

    @staticmethod
    def field(o,field):
        if (field is None):
            return None
        if isinstance(o,str):
            field1 = field
            _hx_local_0 = len(field1)
            if (_hx_local_0 == 10):
                if (field1 == "charCodeAt"):
                    return python_internal_MethodClosure(o,HxString.charCodeAt)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_0 == 11):
                if (field1 == "lastIndexOf"):
                    return python_internal_MethodClosure(o,HxString.lastIndexOf)
                elif (field1 == "toLowerCase"):
                    return python_internal_MethodClosure(o,HxString.toLowerCase)
                elif (field1 == "toUpperCase"):
                    return python_internal_MethodClosure(o,HxString.toUpperCase)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_0 == 9):
                if (field1 == "substring"):
                    return python_internal_MethodClosure(o,HxString.substring)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_0 == 5):
                if (field1 == "split"):
                    return python_internal_MethodClosure(o,HxString.split)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_0 == 7):
                if (field1 == "indexOf"):
                    return python_internal_MethodClosure(o,HxString.indexOf)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_0 == 8):
                if (field1 == "toString"):
                    return python_internal_MethodClosure(o,HxString.toString)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_0 == 6):
                if (field1 == "charAt"):
                    return python_internal_MethodClosure(o,HxString.charAt)
                elif (field1 == "length"):
                    return len(o)
                elif (field1 == "substr"):
                    return python_internal_MethodClosure(o,HxString.substr)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            else:
                field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                if hasattr(o,field1):
                    return getattr(o,field1)
                else:
                    return None
        elif isinstance(o,list):
            field1 = field
            _hx_local_1 = len(field1)
            if (_hx_local_1 == 11):
                if (field1 == "lastIndexOf"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.lastIndexOf)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_1 == 4):
                if (field1 == "copy"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.copy)
                elif (field1 == "join"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.join)
                elif (field1 == "push"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.push)
                elif (field1 == "sort"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.sort)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_1 == 5):
                if (field1 == "shift"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.shift)
                elif (field1 == "slice"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.slice)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_1 == 7):
                if (field1 == "indexOf"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.indexOf)
                elif (field1 == "reverse"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.reverse)
                elif (field1 == "unshift"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.unshift)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_1 == 3):
                if (field1 == "map"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.map)
                elif (field1 == "pop"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.pop)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_1 == 8):
                if (field1 == "contains"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.contains)
                elif (field1 == "iterator"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.iterator)
                elif (field1 == "toString"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.toString)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_1 == 16):
                if (field1 == "keyValueIterator"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.keyValueIterator)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_1 == 6):
                if (field1 == "concat"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.concat)
                elif (field1 == "filter"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.filter)
                elif (field1 == "insert"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.insert)
                elif (field1 == "length"):
                    return len(o)
                elif (field1 == "remove"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.remove)
                elif (field1 == "splice"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.splice)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            else:
                field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                if hasattr(o,field1):
                    return getattr(o,field1)
                else:
                    return None
        else:
            field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
            if hasattr(o,field1):
                return getattr(o,field1)
            else:
                return None

    @staticmethod
    def getInstanceFields(c):
        f = (list(c._hx_fields) if (hasattr(c,"_hx_fields")) else [])
        if hasattr(c,"_hx_methods"):
            f = (f + c._hx_methods)
        sc = python_Boot.getSuperClass(c)
        if (sc is None):
            return f
        else:
            scArr = python_Boot.getInstanceFields(sc)
            scMap = set(scArr)
            _g = 0
            while (_g < len(f)):
                f1 = (f[_g] if _g >= 0 and _g < len(f) else None)
                _g = (_g + 1)
                if (not (f1 in scMap)):
                    scArr.append(f1)
            return scArr

    @staticmethod
    def getSuperClass(c):
        if (c is None):
            return None
        try:
            if hasattr(c,"_hx_super"):
                return c._hx_super
            return None
        except BaseException as _g:
            None
        return None

    @staticmethod
    def getClassFields(c):
        if hasattr(c,"_hx_statics"):
            x = c._hx_statics
            return list(x)
        else:
            return []

    @staticmethod
    def unhandleKeywords(name):
        if (HxString.substr(name,0,python_Boot.prefixLength) == "_hx_"):
            real = HxString.substr(name,python_Boot.prefixLength,None)
            if (real in python_Boot.keywords):
                return real
        return name


class python_HaxeIterator:
    _hx_class_name = "python.HaxeIterator"
    __slots__ = ("it", "x", "has", "checked")
    _hx_fields = ["it", "x", "has", "checked"]
    _hx_methods = ["next", "hasNext"]

    def __init__(self,it):
        self.checked = False
        self.has = False
        self.x = None
        self.it = it

    def next(self):
        if (not self.checked):
            self.hasNext()
        self.checked = False
        return self.x

    def hasNext(self):
        if (not self.checked):
            try:
                self.x = self.it.__next__()
                self.has = True
            except BaseException as _g:
                None
                if Std.isOfType(haxe_Exception.caught(_g).unwrap(),StopIteration):
                    self.has = False
                    self.x = None
                else:
                    raise _g
            self.checked = True
        return self.has



class python_Lib:
    _hx_class_name = "python.Lib"
    __slots__ = ()
    _hx_statics = ["lineEnd", "printString"]

    @staticmethod
    def printString(_hx_str):
        encoding = "utf-8"
        if (encoding is None):
            encoding = "utf-8"
        python_lib_Sys.stdout.buffer.write(_hx_str.encode(encoding, "strict"))
        python_lib_Sys.stdout.flush()


class python_internal_ArrayImpl:
    _hx_class_name = "python.internal.ArrayImpl"
    __slots__ = ()
    _hx_statics = ["concat", "copy", "iterator", "keyValueIterator", "indexOf", "lastIndexOf", "join", "toString", "pop", "push", "unshift", "remove", "contains", "shift", "slice", "sort", "splice", "map", "filter", "insert", "reverse", "_get", "_set"]

    @staticmethod
    def concat(a1,a2):
        return (a1 + a2)

    @staticmethod
    def copy(x):
        return list(x)

    @staticmethod
    def iterator(x):
        return python_HaxeIterator(x.__iter__())

    @staticmethod
    def keyValueIterator(x):
        return haxe_iterators_ArrayKeyValueIterator(x)

    @staticmethod
    def indexOf(a,x,fromIndex = None):
        _hx_len = len(a)
        l = (0 if ((fromIndex is None)) else ((_hx_len + fromIndex) if ((fromIndex < 0)) else fromIndex))
        if (l < 0):
            l = 0
        _g = l
        _g1 = _hx_len
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            if HxOverrides.eq(a[i],x):
                return i
        return -1

    @staticmethod
    def lastIndexOf(a,x,fromIndex = None):
        _hx_len = len(a)
        l = (_hx_len if ((fromIndex is None)) else (((_hx_len + fromIndex) + 1) if ((fromIndex < 0)) else (fromIndex + 1)))
        if (l > _hx_len):
            l = _hx_len
        while True:
            l = (l - 1)
            tmp = l
            if (not ((tmp > -1))):
                break
            if HxOverrides.eq(a[l],x):
                return l
        return -1

    @staticmethod
    def join(x,sep):
        return sep.join([python_Boot.toString1(x1,'') for x1 in x])

    @staticmethod
    def toString(x):
        return (("[" + HxOverrides.stringOrNull(",".join([python_Boot.toString1(x1,'') for x1 in x]))) + "]")

    @staticmethod
    def pop(x):
        if (len(x) == 0):
            return None
        else:
            return x.pop()

    @staticmethod
    def push(x,e):
        x.append(e)
        return len(x)

    @staticmethod
    def unshift(x,e):
        x.insert(0, e)

    @staticmethod
    def remove(x,e):
        try:
            x.remove(e)
            return True
        except BaseException as _g:
            None
            return False

    @staticmethod
    def contains(x,e):
        return (e in x)

    @staticmethod
    def shift(x):
        if (len(x) == 0):
            return None
        return x.pop(0)

    @staticmethod
    def slice(x,pos,end = None):
        return x[pos:end]

    @staticmethod
    def sort(x,f):
        x.sort(key= python_lib_Functools.cmp_to_key(f))

    @staticmethod
    def splice(x,pos,_hx_len):
        if (pos < 0):
            pos = (len(x) + pos)
        if (pos < 0):
            pos = 0
        res = x[pos:(pos + _hx_len)]
        del x[pos:(pos + _hx_len)]
        return res

    @staticmethod
    def map(x,f):
        return list(map(f,x))

    @staticmethod
    def filter(x,f):
        return list(filter(f,x))

    @staticmethod
    def insert(a,pos,x):
        a.insert(pos, x)

    @staticmethod
    def reverse(a):
        a.reverse()

    @staticmethod
    def _get(x,idx):
        if ((idx > -1) and ((idx < len(x)))):
            return x[idx]
        else:
            return None

    @staticmethod
    def _set(x,idx,v):
        l = len(x)
        while (l < idx):
            x.append(None)
            l = (l + 1)
        if (l == idx):
            x.append(v)
        else:
            x[idx] = v
        return v


class HxOverrides:
    _hx_class_name = "HxOverrides"
    __slots__ = ()
    _hx_statics = ["eq", "stringOrNull", "modf", "mod"]

    @staticmethod
    def eq(a,b):
        if (isinstance(a,list) or isinstance(b,list)):
            return a is b
        return (a == b)

    @staticmethod
    def stringOrNull(s):
        if (s is None):
            return "null"
        else:
            return s

    @staticmethod
    def modf(a,b):
        if (b == 0.0):
            return float('nan')
        elif (a < 0):
            if (b < 0):
                return -(-a % (-b))
            else:
                return -(-a % b)
        elif (b < 0):
            return a % (-b)
        else:
            return a % b

    @staticmethod
    def mod(a,b):
        if (a < 0):
            if (b < 0):
                return -(-a % (-b))
            else:
                return -(-a % b)
        elif (b < 0):
            return a % (-b)
        else:
            return a % b


class python_internal_MethodClosure:
    _hx_class_name = "python.internal.MethodClosure"
    __slots__ = ("obj", "func")
    _hx_fields = ["obj", "func"]
    _hx_methods = ["__call__"]

    def __init__(self,obj,func):
        self.obj = obj
        self.func = func

    def __call__(self,*args):
        return self.func(self.obj,*args)



class HxString:
    _hx_class_name = "HxString"
    __slots__ = ()
    _hx_statics = ["split", "charCodeAt", "charAt", "lastIndexOf", "toUpperCase", "toLowerCase", "indexOf", "indexOfImpl", "toString", "substring", "substr"]

    @staticmethod
    def split(s,d):
        if (d == ""):
            return list(s)
        else:
            return s.split(d)

    @staticmethod
    def charCodeAt(s,index):
        if ((((s is None) or ((len(s) == 0))) or ((index < 0))) or ((index >= len(s)))):
            return None
        else:
            return ord(s[index])

    @staticmethod
    def charAt(s,index):
        if ((index < 0) or ((index >= len(s)))):
            return ""
        else:
            return s[index]

    @staticmethod
    def lastIndexOf(s,_hx_str,startIndex = None):
        if (startIndex is None):
            return s.rfind(_hx_str, 0, len(s))
        elif (_hx_str == ""):
            length = len(s)
            if (startIndex < 0):
                startIndex = (length + startIndex)
                if (startIndex < 0):
                    startIndex = 0
            if (startIndex > length):
                return length
            else:
                return startIndex
        else:
            i = s.rfind(_hx_str, 0, (startIndex + 1))
            startLeft = (max(0,((startIndex + 1) - len(_hx_str))) if ((i == -1)) else (i + 1))
            check = s.find(_hx_str, startLeft, len(s))
            if ((check > i) and ((check <= startIndex))):
                return check
            else:
                return i

    @staticmethod
    def toUpperCase(s):
        return s.upper()

    @staticmethod
    def toLowerCase(s):
        return s.lower()

    @staticmethod
    def indexOf(s,_hx_str,startIndex = None):
        if (startIndex is None):
            return s.find(_hx_str)
        else:
            return HxString.indexOfImpl(s,_hx_str,startIndex)

    @staticmethod
    def indexOfImpl(s,_hx_str,startIndex):
        if (_hx_str == ""):
            length = len(s)
            if (startIndex < 0):
                startIndex = (length + startIndex)
                if (startIndex < 0):
                    startIndex = 0
            if (startIndex > length):
                return length
            else:
                return startIndex
        return s.find(_hx_str, startIndex)

    @staticmethod
    def toString(s):
        return s

    @staticmethod
    def substring(s,startIndex,endIndex = None):
        if (startIndex < 0):
            startIndex = 0
        if (endIndex is None):
            return s[startIndex:]
        else:
            if (endIndex < 0):
                endIndex = 0
            if (endIndex < startIndex):
                return s[endIndex:startIndex]
            else:
                return s[startIndex:endIndex]

    @staticmethod
    def substr(s,startIndex,_hx_len = None):
        if (_hx_len is None):
            return s[startIndex:]
        else:
            if (_hx_len == 0):
                return ""
            if (startIndex < 0):
                startIndex = (len(s) + startIndex)
                if (startIndex < 0):
                    startIndex = 0
            return s[startIndex:(startIndex + _hx_len)]


class sys_thread_EventLoop:
    _hx_class_name = "sys.thread.EventLoop"
    __slots__ = ("mutex", "oneTimeEvents", "oneTimeEventsIdx", "waitLock", "promisedEventsCount", "regularEvents")
    _hx_fields = ["mutex", "oneTimeEvents", "oneTimeEventsIdx", "waitLock", "promisedEventsCount", "regularEvents"]
    _hx_methods = ["loop"]

    def __init__(self):
        self.regularEvents = None
        self.promisedEventsCount = 0
        self.waitLock = sys_thread_Lock()
        self.oneTimeEventsIdx = 0
        self.oneTimeEvents = list()
        self.mutex = sys_thread_Mutex()

    def loop(self):
        recycleRegular = []
        recycleOneTimers = []
        while True:
            now = python_lib_Time.time()
            regularsToRun = recycleRegular
            eventsToRunIdx = 0
            nextEventAt = -1
            self.mutex.lock.acquire(True)
            while self.waitLock.semaphore.acquire(True,0.0):
                pass
            current = self.regularEvents
            while (current is not None):
                if (current.nextRunTime <= now):
                    tmp = eventsToRunIdx
                    eventsToRunIdx = (eventsToRunIdx + 1)
                    python_internal_ArrayImpl._set(regularsToRun, tmp, current)
                    current.nextRunTime = (current.nextRunTime + current.interval)
                    nextEventAt = -2
                elif ((nextEventAt == -1) or ((current.nextRunTime < nextEventAt))):
                    nextEventAt = current.nextRunTime
                current = current.next
            self.mutex.lock.release()
            _g = 0
            _g1 = eventsToRunIdx
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                if (not (regularsToRun[i] if i >= 0 and i < len(regularsToRun) else None).cancelled):
                    (regularsToRun[i] if i >= 0 and i < len(regularsToRun) else None).run()
                python_internal_ArrayImpl._set(regularsToRun, i, None)
            eventsToRunIdx = 0
            oneTimersToRun = recycleOneTimers
            self.mutex.lock.acquire(True)
            _g2_current = 0
            _g2_array = self.oneTimeEvents
            while (_g2_current < len(_g2_array)):
                _g3_value = (_g2_array[_g2_current] if _g2_current >= 0 and _g2_current < len(_g2_array) else None)
                _g3_key = _g2_current
                _g2_current = (_g2_current + 1)
                i1 = _g3_key
                event = _g3_value
                if (event is None):
                    break
                else:
                    tmp1 = eventsToRunIdx
                    eventsToRunIdx = (eventsToRunIdx + 1)
                    python_internal_ArrayImpl._set(oneTimersToRun, tmp1, event)
                    python_internal_ArrayImpl._set(self.oneTimeEvents, i1, None)
            self.oneTimeEventsIdx = 0
            hasPromisedEvents = (self.promisedEventsCount > 0)
            self.mutex.lock.release()
            _g2 = 0
            _g3 = eventsToRunIdx
            while (_g2 < _g3):
                i2 = _g2
                _g2 = (_g2 + 1)
                (oneTimersToRun[i2] if i2 >= 0 and i2 < len(oneTimersToRun) else None)()
                python_internal_ArrayImpl._set(oneTimersToRun, i2, None)
            if (eventsToRunIdx > 0):
                nextEventAt = -2
            r_nextEventAt = nextEventAt
            r_anyTime = hasPromisedEvents
            _g4 = r_anyTime
            _g5 = r_nextEventAt
            _g6 = _g5
            if (_g6 == -2):
                pass
            elif (_g6 == -1):
                if _g4:
                    self.waitLock.semaphore.acquire(True,None)
                else:
                    break
            else:
                time = _g5
                timeout = (time - python_lib_Time.time())
                _this = self.waitLock
                timeout1 = (0 if (python_lib_Math.isnan(0)) else (timeout if (python_lib_Math.isnan(timeout)) else max(0,timeout)))
                _this.semaphore.acquire(True,timeout1)



class sys_thread__EventLoop_RegularEvent:
    _hx_class_name = "sys.thread._EventLoop.RegularEvent"
    __slots__ = ("nextRunTime", "interval", "run", "next", "cancelled")
    _hx_fields = ["nextRunTime", "interval", "run", "next", "cancelled"]

    def __init__(self,run,nextRunTime,interval):
        self.next = None
        self.cancelled = False
        self.run = run
        self.nextRunTime = nextRunTime
        self.interval = interval



class sys_thread_Lock:
    _hx_class_name = "sys.thread.Lock"
    __slots__ = ("semaphore",)
    _hx_fields = ["semaphore"]

    def __init__(self):
        self.semaphore = Lock(0)



class sys_thread_Mutex:
    _hx_class_name = "sys.thread.Mutex"
    __slots__ = ("lock",)
    _hx_fields = ["lock"]

    def __init__(self):
        self.lock = sys_thread__Mutex_NativeRLock()



class sys_thread__Thread_Thread_Impl_:
    _hx_class_name = "sys.thread._Thread.Thread_Impl_"
    __slots__ = ()
    _hx_statics = ["processEvents"]

    @staticmethod
    def processEvents():
        sys_thread__Thread_HxThread.current().events.loop()


class sys_thread__Thread_HxThread:
    _hx_class_name = "sys.thread._Thread.HxThread"
    __slots__ = ("events", "nativeThread")
    _hx_fields = ["events", "nativeThread"]
    _hx_statics = ["threads", "threadsMutex", "mainThread", "current"]

    def __init__(self,t):
        self.events = None
        self.nativeThread = t
    threads = None
    threadsMutex = None
    mainThread = None

    @staticmethod
    def current():
        sys_thread__Thread_HxThread.threadsMutex.lock.acquire(True)
        ct = threading.current_thread()
        if (ct == threading.main_thread()):
            sys_thread__Thread_HxThread.threadsMutex.lock.release()
            return sys_thread__Thread_HxThread.mainThread
        if (not (ct in sys_thread__Thread_HxThread.threads.h)):
            sys_thread__Thread_HxThread.threads.set(ct,sys_thread__Thread_HxThread(ct))
        t = sys_thread__Thread_HxThread.threads.h.get(ct,None)
        sys_thread__Thread_HxThread.threadsMutex.lock.release()
        return t


Math.NEGATIVE_INFINITY = float("-inf")
Math.POSITIVE_INFINITY = float("inf")
Math.NaN = float("nan")
Math.PI = python_lib_Math.pi
sys_thread__Thread_HxThread.threads = haxe_ds_ObjectMap()
sys_thread__Thread_HxThread.threadsMutex = sys_thread_Mutex()
sys_thread__Thread_HxThread.mainThread = sys_thread__Thread_HxThread(threading.current_thread())
sys_thread__Thread_HxThread.mainThread.events = sys_thread_EventLoop()

champuru_Worker.mMsgs = haxe_ds_List()
champuru_base_SingleNucleotide.sAdenine = 1
champuru_base_SingleNucleotide.sCytosine = 2
champuru_base_SingleNucleotide.sThymine = 4
champuru_base_SingleNucleotide.sGuanine = 8
champuru_perl_PerlChampuruReimplementation.bases = ["A", "T", "G", "C", "R", "Y", "M", "K", "W", "S", "V", "B", "H", "D", "N"]
def _hx_init_champuru_perl_PerlChampuruReimplementation_complement():
    def _hx_local_0():
        _g = haxe_ds_StringMap()
        _g.h["A"] = "T"
        _g.h["T"] = "A"
        _g.h["G"] = "C"
        _g.h["C"] = "G"
        _g.h["R"] = "Y"
        _g.h["Y"] = "R"
        _g.h["M"] = "K"
        _g.h["K"] = "M"
        _g.h["W"] = "W"
        _g.h["S"] = "S"
        _g.h["V"] = "B"
        _g.h["B"] = "V"
        _g.h["H"] = "D"
        _g.h["D"] = "H"
        _g.h["N"] = "N"
        return _g
    return _hx_local_0()
champuru_perl_PerlChampuruReimplementation.complement = _hx_init_champuru_perl_PerlChampuruReimplementation_complement()
def _hx_init_champuru_perl_PerlChampuruReimplementation_code():
    def _hx_local_0():
        _g = haxe_ds_StringMap()
        _g.h["A"] = 1
        _g.h["T"] = 2
        _g.h["G"] = 4
        _g.h["C"] = 8
        _g.h["R"] = 5
        _g.h["Y"] = 10
        _g.h["M"] = 9
        _g.h["K"] = 6
        _g.h["W"] = 3
        _g.h["S"] = 12
        _g.h["V"] = 13
        _g.h["B"] = 14
        _g.h["H"] = 11
        _g.h["D"] = 7
        _g.h["N"] = 15
        return _g
    return _hx_local_0()
champuru_perl_PerlChampuruReimplementation.code = _hx_init_champuru_perl_PerlChampuruReimplementation_code()
def _hx_init_champuru_perl_PerlChampuruReimplementation_rev_code():
    def _hx_local_0():
        _g = haxe_ds_IntMap()
        _g.set(1,"A")
        _g.set(2,"T")
        _g.set(4,"G")
        _g.set(8,"C")
        _g.set(5,"R")
        _g.set(10,"Y")
        _g.set(9,"M")
        _g.set(3,"W")
        _g.set(12,"S")
        _g.set(6,"K")
        _g.set(13,"V")
        _g.set(14,"B")
        _g.set(11,"H")
        _g.set(7,"D")
        _g.set(15,"N")
        return _g
    return _hx_local_0()
champuru_perl_PerlChampuruReimplementation.rev_code = _hx_init_champuru_perl_PerlChampuruReimplementation_rev_code()
champuru_score_GumbelDistribution.eulerMascheroniConst = 0.5772156649015328606065120900824024310421593359399235988057672348
haxe_crypto_Base64.CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
haxe_crypto_Base64.BYTES = haxe_io_Bytes.ofString(haxe_crypto_Base64.CHARS)
python_Boot.keywords = set(["and", "del", "from", "not", "with", "as", "elif", "global", "or", "yield", "assert", "else", "if", "pass", "None", "break", "except", "import", "raise", "True", "class", "exec", "in", "return", "False", "continue", "finally", "is", "try", "def", "for", "lambda", "while"])
python_Boot.prefixLength = len("_hx_")
python_Lib.lineEnd = ("\r\n" if ((Sys.systemName() == "Windows")) else "\n")

champuru_Worker.main()
sys_thread__Thread_Thread_Impl_.processEvents()
