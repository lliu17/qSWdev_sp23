// QPE Test

namespace QPE {
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Preparation;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Random;


    @Test("QuantumSimulator")
    operation testQPE_T() : Unit {
        use target = Qubit();
        X(target); // prepare the eigenvector |1>
        // T-gate: e^2πi/8 phase rotation
        QPE(4, [target], T_wrapper);
    }

    // wrapper for T gate, in order to match type
    operation T_wrapper(target : Qubit[]) : Unit is Adj + Ctl {
        T(target[0]);
    }
}
