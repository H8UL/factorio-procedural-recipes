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

require("lib.cmwc")

describe("Complimentary-Multiply-With-Carry RNG", function()
    describe("RNG interface", function()
        it("should accept seed 0", function()
            local rng = Cmwc:withSeed(0)
            rng:randUint32()
        end)
        it("should accept seed 1", function()
            local rng = Cmwc:withSeed(1)
            rng:randUint32()
        end)
        pending("error when seed is nil")
        pending("various rand methods")
        pending("derived RNGs don't affect original RNG")
    end)
    describe("statistical tests of RNG", function()
        pending("implement some of the class RNG tests")
    end)
end)