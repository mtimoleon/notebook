---
created: 2026-02-01
---

```

//@version=6
strategy("Logistic Direction Model (Price/Volume) - Horizon Scoring", overlay=true,
     initial_capital=1000,
     commission_type=strategy.commission.percent, commission_value=0.05,
     slippage=1)

// =========================
// Inputs
// =========================
horizonBars      = input.int(5, "Horizon (bars)", minval=1) // e.g. 5 for ~1 week on Daily
useVolume        = input.bool(true, "Use volume features")
useRegimeFilter  = input.bool(true, "Use regime filter (trend vs chop)")

probThreshold    = input.float(0.60, "Entry threshold P(up)", minval=0.0, maxval=1.0, step=0.01)
probExit         = input.float(0.45, "Exit threshold P(up)", minval=0.0, maxval=1.0, step=0.01)

riskMode         = input.string("Fixed %", "Exit mode", options=["Fixed %", "ATR"])
tpPct            = input.float(6.0, "Take profit %", minval=0.1, step=0.1)
slPct            = input.float(3.0, "Stop loss %", minval=0.1, step=0.1)
atrLen           = input.int(14, "ATR length", minval=2)
tpAtrMult        = input.float(2.0, "TP ATR mult", minval=0.1, step=0.1)
slAtrMult        = input.float(1.5, "SL ATR mult", minval=0.1, step=0.1)

tradeLongOnly    = input.bool(true, "Long only")
allowShort       = input.bool(false, "Allow short (if not long-only)")
maxOneTrade      = input.bool(true, "One position at a time")

// =========================
// Model weights (tune these)
// =========================
bias             = input.float(0.00, "w0 Bias", step=0.01)

wMom1            = input.float(0.90, "w1 Momentum(ROC) 1", step=0.01)
wMom2            = input.float(0.60, "w2 Momentum(ROC) 2", step=0.01)
wEmaDist         = input.float(0.70, "w3 EMA distance", step=0.01)
wVol             = input.float(-0.50, "w4 Volatility penalty", step=0.01)
wRsi             = input.float(0.30, "w5 RSI tilt", step=0.01)

wVolZ            = input.float(0.35, "w6 Volume z-score", step=0.01)
wVolPrice        = input.float(0.25, "w7 Volume*Return interaction", step=0.01)

wRegime          = input.float(0.60, "w8 Regime boost (trend)", step=0.01)

// =========================
// Feature engineering
// =========================
// All features are scaled-ish to be roughly comparable.
// You MUST keep scaling stable across symbols/timeframes.

roc1Len = input.int(5,  "ROC1 length", minval=1)
roc2Len = input.int(20, "ROC2 length", minval=2)
emaLen  = input.int(50, "EMA length",  minval=2)
volLen  = input.int(20, "Volatility length", minval=5)
rsiLen  = input.int(14, "RSI length", minval=2)

ret1 = math.log(close / close[1])
roc1 = ta.roc(close, roc1Len) / 100.0
roc2 = ta.roc(close, roc2Len) / 100.0

ema  = ta.ema(close, emaLen)
emaDist = (close - ema) / ema // relative distance

// Realized vol proxy: stdev of log returns
vol = ta.stdev(ret1, volLen)

// RSI normalized around 0
rsi = ta.rsi(close, rsiLen)
rsiTilt = (rsi - 50.0) / 50.0

// Volume features
float volZ = na
float volPriceInteraction = na
if useVolume
    vSma = ta.sma(volume, 20)
    vStd = ta.stdev(volume, 20)
    volZ := vStd \> 0 ? (volume - vSma) / vStd : 0.0
    volPriceInteraction := volZ * ret1

// Regime filter: trend vs chop using ADX + slope
diLen = input.int(14, "DI length", minval=2)
adxSmoothing = input.int(14, "ADX smoothing", minval=2)
[plusDI, minusDI, adx] = ta.dmi(diLen, adxSmoothing)
emaSlope = (ema - ema[5]) / ema[5]
isTrend = (adx \> 18) and (math.abs(emaSlope) \> 0.001)

regime = useRegimeFilter ? (isTrend ? 1.0 : 0.0) : 0.0

// =========================
// Logistic probability
// =========================
x = bias + wMom1 * roc1 + wMom2 * roc2 + wEmaDist * emaDist + wVol  * vol + wRsi  * rsiTilt + (useVolume ? (wVolZ * nz(volZ) + wVolPrice * nz(volPriceInteraction)) : 0.0) + wRegime * regime

// Sigmoid with numeric safety
sigmoid(z) =\>
    // clamp to avoid overflow
    zz = math.max(math.min(z, 20.0), -20.0)
    1.0 / (1.0 + math.exp(-zz))

pUp = sigmoid(x)

// =========================
// Optional label approximation (for on-chart sanity check)
// =========================
// Forward return sign after horizonBars (not usable in realtime; for visual audit only).
float fwdRet = na
fwdRet := bar_index \> horizonBars ? (close[horizonBars] != 0 ? (close - close[horizonBars]) / close[horizonBars] : na) : na
// Note: fwdRet here references past/future depending on indexing; keep it only for offline inspection.

// =========================
// Trading rules
// =========================
canEnter = maxOneTrade ? (strategy.position_size == 0) : true

longSignal  = canEnter and (pUp \>= probThreshold)
exitLong    = (pUp \<= probExit)

shortSignal = canEnter and (pUp \<= (1.0 - probThreshold)) and allowShort and (not tradeLongOnly)
exitShort   = (pUp \>= (1.0 - probExit)) and allowShort and (not tradeLongOnly)

// Entries
if longSignal and (tradeLongOnly or allowShort)
    strategy.entry("L", strategy.long)

if shortSignal
    strategy.entry("S", strategy.short)

// Exits: probability-based + risk-based
atr = ta.atr(atrLen)

if strategy.position_size \> 0
    if exitLong
        strategy.close("L", comment="PExit")
    if riskMode == "Fixed %"
        longStop = strategy.position_avg_price * (1.0 - slPct / 100.0)
        longTake = strategy.position_avg_price * (1.0 + tpPct / 100.0)
        strategy.exit("L-Exit", from_entry="L", stop=longStop, limit=longTake)
    else
        longStop = strategy.position_avg_price - slAtrMult * atr
        longTake = strategy.position_avg_price + tpAtrMult * atr
        strategy.exit("L-Exit", from_entry="L", stop=longStop, limit=longTake)

if strategy.position_size \< 0
    if exitShort
        strategy.close("S", comment="PExit")
    if riskMode == "Fixed %"
        shortStop = strategy.position_avg_price * (1.0 + slPct / 100.0)
        shortTake = strategy.position_avg_price * (1.0 - tpPct / 100.0)
        strategy.exit("S-Exit", from_entry="S", stop=shortStop, limit=shortTake)
    else
        shortStop = strategy.position_avg_price + slAtrMult * atr
        shortTake = strategy.position_avg_price - tpAtrMult * atr
        strategy.exit("S-Exit", from_entry="S", stop=shortStop, limit=shortTake)

// =========================
// Plots
// =========================
plot(pUp, "P(up)", linewidth=2)
hline(probThreshold, "Entry Th", linestyle=hline.style_dotted)
hline(probExit, "Exit Th", linestyle=hline.style_dotted)

plot(useRegimeFilter ? regime : na, "Regime(Trend=1)", style=plot.style_stepline)
.

```
