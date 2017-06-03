-- Copyright 2017 H8UL

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

--
-- class Cmwc
--
-- A pure lua Complimentary-Multiply-With-Carry random number generator
-- This is used in place of Lua's builtin math.random, which is platform-specific
--
-- A lag of 4 is used. While minimal by CMWC standards, the amount of random numbers
-- required is relatively small, so the periodicity is still excellent for our purposes.
--
-- Based on "Random Number Generators", by George Marsaglia
-- Journal of Modern Applied Statistical Methods May 2003, Vol. 2, No.1, 2-13
Cmwc = {
}

function Cmwc:withSeed(seed)
    -- uses one numerical seed, for ease of input
    -- this doesn't give access to the entire seed space of the CMWC, but is acceptable

    -- uses a simple LCG to populate the four seeds from one number
    local lcg = function(s)
        return bit32.band(1664525*s+1013904223, 0xffffffff)
    end

    -- discard a few of the initial LCG results, as a precaution
    local seed0 = seed
    for d=0,10 do
        seed0 = lcg(seed0)
    end

    local seed1 = lcg(seed0)
    local seed2 = lcg(seed1)
    local seed3 = lcg(seed2)
    local seed4 = lcg(seed3)

    local o = {
        Q = {seed1, seed2, seed3, seed4},
        c = 123,
        i = 3,
    }
    setmetatable(o, Cmwc)
    Cmwc.__index = Cmwc
    return o
end

-- Derive a new RNG seeded by this RNG
function Cmwc:deriveNew()
    local o = {
        Q = {self:randUint32(), self:randUint32(), self:randUint32(), self:randUint32()},
        c = 123,
        i = 3,
    }
    setmetatable(o, Cmwc)
    Cmwc.__index = Cmwc
    return o
end

function Cmwc:randUint32()
    self.i = bit32.band(self.i + 1, 3)
    local t = (987654978 * self.Q[self.i+1]) + self.c
    self.c = bit32.rshift(t, 32)
    local x = bit32.band(t + self.c, 0xffffffff)
    if x < self.c then
        x = bit32.band(x + 1, 0xffffffff)
        self.c = bit32.band(self.c + 1, 0xffffffff)
    end
    local q = bit32.band(0xfffffffe - x, 0xffffffff)
    self.Q[self.i+1] = q
    return q
end

function Cmwc:randFraction()
    return self:randUint32() / 0xffffffff
end

function Cmwc:randPercentage()
    return 100.0 * self:randUint32() / 0xffffffff
end

function Cmwc:randRange(low, high)
    return math.floor(self:randFraction() * (1+high-low)) + low
end