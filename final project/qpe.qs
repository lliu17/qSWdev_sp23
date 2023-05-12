// Final Project: QPE

namespace QPE {

    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;

    operation QPE(numCountingBits : Int, eigenVector : Qubit[], 
                  oracle : (Qubit[]) => Unit is Adj + Ctl) : Unit {
        // prepare input register
        use input = Qubit[numCountingBits];
        ApplyToEach(H, input);
        // apply U^(2^t-1), ..., U^(2^0)
        for i in 0 .. numCountingBits - 1 {
            let powered = 2 ^ (numCountingBits - 1 - i);
            for j in 0 .. powered - 1 {
                Controlled oracle([input[i]], eigenVector);
            }
        }
        Adjoint Lab8_QFT(BigEndian(input));
        Lab3_swap(input);
        let res = MultiM(input);
        // u|x> = e^2πiθ|x>, measuring θ
        mutable measure = ResultArrayAsInt(res);
        Message("============");
        // Message($"res is: {res}");
        Message($"measure is: {measure}");
        Message("============");
        ResetAll(input + eigenVector);
    }

    operation Lab3_swap(register : Qubit[]) : Unit is Adj + Ctl {
        let len = Length(register) - 1;
        if (len > 0) {
            let lenHalf = len / 2;
            for i in 0 .. lenHalf {
                if (i != len - i) {
                    SWAP(register[i], register[len - i]);
                }
            }
        }
    }

    operation Lab8_QFT (register : BigEndian) : Unit is Adj + Ctl {
        let len = Length(register!);
        for i in 0 .. len - 1 {
            H(register![i]);

            for j in i + 1 .. len - 1 {
                Controlled Microsoft.Quantum.Intrinsic.R1Frac([register![j]], 
                                                    (1, j - i, register![i]));
            }
        }
        Lab3_swap(register!);
    }
}
