// Quantum Software Development
// Lab 3: Multi-Qubit Gates
// Copyright 2023 The MITRE Corporation. All Rights Reserved.
//
// Due 2/15 at 6:00PM ET:
//  - Completed exercises and evidence of unit tests passing uploaded to GitHub.
//
// Note this assignment contains extra credit problems.

namespace Lab3 {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Diagnostics;

    /// # Summary
    /// In this exercise, you are given two qubits. Both qubits are in
    /// arbitrary, unknown states:
    ///
    ///     |qubitA> = a|0> + b|1>
    ///     |qubitB> = c|0> + d|1>
    ///
    /// Use the two-qubit gates in Q# to switch their amplitudes, so
    /// this is the end result:
    ///
    ///     |qubitA> = c|0> + d|1>
    ///     |qubitB> = a|0> + b|1>
    ///
    /// # Input
    /// ## qubitA
    /// The first qubit, which starts in the state a|0> + b|1>.
    ///
    /// ## qubitB
    /// The second qubit, which starts in the state c|0> + d|1>.
    ///
    /// # Remarks
    /// This investigates how to apply quantum gates that take more than one
    /// qubit.
    operation Exercise1 (qubitA : Qubit, qubitB : Qubit) : Unit {
        // Hint: you can do this with a single statement, using one gate.
        SWAP(qubitA, qubitB);
    }


    /// # Summary
    /// In this exercise, you're given a register of qubits with unknown
    /// length. Each qubit is in an arbitrary, unknown state. Your goal
    /// is to reverse the register, so the order of qubits is reversed.
    ///
    /// For example, if the register had 3 qubits where:
    ///
    ///     |register[0]> = a|0> + b|1>
    ///     |register[1]> = c|0> + d|1>
    ///     |register[2]> = e|0> + f|1>
    ///
    /// Your goal would be to modify the qubits in the register so that
    /// the qubit's states are reversed:
    ///
    ///     |register[0]> = e|0> + f|1>
    ///     |register[1]> = c|0> + d|1>
    ///     |register[2]> = a|0> + b|1>
    ///
    /// Note that the register itself is immutable, so you can't just reorder
    /// the elements like you would in a classical array. For instance, you
    /// can't change the contents of register[0], you can only modify the state
    /// of the qubit at register[0] using quantum gates. In other words, you
    /// must reverse the register by reversing the states of the qubits
    /// themselves, without changing the actual order of the qubits in the
    /// register.
    ///
    /// # Input
    /// ## register
    /// The qubit register that you need to reverse.
    ///
    /// # Remarks
    /// This investigates the combination of arrays and multi-qubit gates.
    operation Exercise2 (register : Qubit[]) : Unit {
        let len = Length(register) - 1;
        if (len > 0) {
            let lenHalf = len / 2;
            // Message($"len (last idx) = {len}, lenhalf = {lenHalf}");
            for i in 0 .. lenHalf {
                if (i != len - i) {
                    // Message($"i = {i}, lenhalf = {lenHalf}");
                    SWAP(register[i], register[len - i]);
                }
            }
        }
    }


    /// # Summary
    /// In this exercise, you are given an array of qubit registers. There are
    /// four registers in the array, and each register contains two qubits. All
    /// eight qubits will be in the |0> state, so each register is in the state
    /// |00>.
    ///
    /// Your goal is to put the four registers into these four states:
    ///
    ///     |registers[0]> = 1/√2(|00> + |11>)
    ///     |registers[1]> = 1/√2(|00> - |11>)
    ///     |registers[2]> = 1/√2(|01> + |10>)
    ///     |registers[3]> = 1/√2(|01> - |10>)
    ///
    /// These four states are known as the Bell States. They are the simplest
    /// examples of full entanglement between two qubits.
    ///
    /// # Input
    /// ## registers
    /// An array of four two-qubit registers. All of the qubits are in the |0>
    /// state.
    ///
    /// # Remarks
    /// This investigates how to prepare the Bell states.
    operation Exercise3 (registers : Qubit[][]) : Unit {
        // Hint: you can start by putting all four registers into the state
        // 1/√2(|00> + |11>), then build the final state for each register 
        // from there.

        for reg in registers {
            H(reg[0]); // 00 + 10
            CNOT(reg[0], reg[1]); // 00 + 11
        }

        Z(registers[1][0]);     // 00 - 11

        X(registers[2][1]);     // 01 + 10

        X(registers[3][1]);     // 01 + 10
        Z(registers[3][0]);     // 01 - 10
    }


    /// # Summary
    /// In this exercise, you are given a qubit register of unknown length. All
    /// of the qubits in it are in the |0> state, so the whole register is in
    /// the state |0...0>.
    ///
    /// Your task is to transform this register into this state:
    ///
    ///     |register> = 1/√2(|0...0> + |1...1>)
    ///
    /// For example, if the register had 5 qubits, you would need to put it in
    /// the state 1/√2(|00000> + |11111>). These states are called the GHZ
    /// states.
    ///
    /// # Input
    /// ## register
    /// The qubit register. It is in the state |0...0>.
    ///
    /// # Remarks
    /// This will investigate how to prepare maximally entangled states for an
    /// arbitrary number of qubits.
    operation Exercise4 (register : Qubit[]) : Unit {
        for i in 0 .. Length(register) - 1 {
            if (i == 0) {
                H(register[i]);
            } else {
                Controlled X(register[0..i - 1], register[i]);
            }
        }
    }


    /// # Summary
    /// In this exercise, you are given a qubit register of length four. All of
    /// its qubits are in the |0> state initially, so the whole register is in
    /// the state |0000>.
    /// Your goal is to put it into the following state:
    ///
    ///     |register> = 1/√2(|0101> - |0110>)
    ///
    /// # Input
    /// ## register
    /// The qubit register. It is in the state |0000>.
    ///
    /// # Remarks
    /// You will need to use the H, X, Z, and CNOT gates to achieve this.
    operation Exercise5 (register : Qubit[]) : Unit {
        X(register[1]);                 // 0100
        H(register[3]);                 // 0100 + 0101
        CNOT(register[3], register[2]); // 0100 + 0111
        X(register[3]);                 // 0101 + 0110
        Z(register[2]);                 // 0101 - 0110
    }


    /// # Summary
    /// In this exercise, you are given a register with two qubits in the |00>
    /// state. Your goal is to put it in this non-uniform superposition:
    ///
    ///     |register> = 1/√2*|00> + 1/2(|10> + |11>)
    ///
    /// Note that this state will have a 50% chance of being measured as |00>,
    /// a 25% chance of being measured as |10>, and a 25% chance of being
    /// measured as |11>.
    ///
    /// # Input
    /// ## register
    /// A register with two qubits in the |00> state.
    ///
    /// # Remarks
    /// This investigates applying controlled operations besides CNOT.
    operation Exercise6 (register : Qubit[]) : Unit {
        // Hint: Think about what happens to register[1] based on the value of
        // register[0].
        H(register[0]);
        Controlled H(register[0..0], register[1]);
    }


    /// # Summary
    /// In this exercise, you are given a three-qubit register and an extra
    /// "target" qubit. All of the qubits are in the |0> state. Your goal is to
    /// put the register into a uniform superposition and then entangle it with
    /// the target qubit such that the target is a |1> when the register is
    /// |001>. To be more specific, you must prepare this state:
    ///
    ///     |register,target> = 1/√8(|000,0> + |001,1> + |010,0> + |011,0>
    ///                            + |100,0> + |101,0> + |110,0> + |111,0>)
    ///
    /// # Input
    /// ## register
    /// A register of three qubits, in the |000> state.
    ///
    /// ## target
    /// A qubit in the |0> state. It should be |1> when the register is |001>.
    ///
    /// # Remarks
    /// This investigates how to implement zero-controlled (a.k.a. anti-
    /// controlled) gates in Q#.
    operation Exercise7 (register : Qubit[], target: Qubit) : Unit {
        // Hint: The "Controlled" syntax does not provide an interface for
        // specifying zero-controls; it assumes all one-controls. You need to
        // find a way to associate the target being |1> with the controls being
        // |001> rather than |111>.

        ApplyToEach(H, register);
        X(register[0]);
        X(register[1]);
        Controlled X(register[0 .. 2], target);
        X(register[0]);
        X(register[1]);
    }


    /// # Summary
    /// In this exercise, you are given a three-qubit register in the |000>
    /// state. Your goal is to transform it into this uneven superposition:
    ///
    ///     |register> = 1/√2*|000> + 1/2(|111> - |100>)
    ///
    /// # Input
    /// ## register
    /// A register with three qubits in the |000> state.
    ///
    /// # Remarks
    /// This is a challenging problem that combines all the concepts covered
    /// so far:
    ///  - Quantum superposition
    ///  - Quantum entanglement
    ///  - Qubit registers
    ///  - Single- and multi-qubit gates
    ///  - Phase
    operation Exercise8 (register : Qubit[]) : Unit {
        // Hint: Allocating one or more "scratch" qubits may make the problem
        // more approachable. It is possible to prepare this state without
        // using any extra qubits, but this is not necessary.
        H(register[0]);                             // 1/√2*|000> + 1/√2*|100>
        CNOT(register[0], register[1]);             // 1/√2*|000> + 1/√2*|110>
        Controlled H(register[0..0], register[1]);  
                                            // 1/√2*|000> + 1/2(|100> - |110>)
        CCNOT(register[0], register[1], register[2]);
                                            // 1/√2*|000> + 1/2(|100> - |111>)
        Z(register[0]);
        
    }


    //////////////////////////////////
    /// === CHALLENGE PROBLEMS === ///
    //////////////////////////////////

    // The problems below are especially challening. 5% extra credit is awarded
    // for each problem attempted, and 10% for each implemented correctly.


    /// # Summary
    /// In this problem, you are given a two-qubit register in the |00> state.
    /// Your goal is to put it into this superposition:
    ///
    ///     |register> = 1/√3(|00> + |01> + |10>)
    ///
    /// Note that all three states have equal amplitude.
    ///
    /// # Input
    /// ## register
    /// A two-qubit register in the |00> state.
    operation Challenge1 (register : Qubit[]) : Unit {
        // H(register[0]);
        // // X(register[1]);
        // // CNOT(register[0], register[1]);
        // // H(register[0]);
        // H(register[0]);
        // H(register[0]);                             // 1/√2*|00> + 1/√2*|10>
        // Controlled H(register[0..0], register[1]);  // 1/√2*|00> + 1/2*|10> + 1/2*|11>
        // CNOT(register[1], register[0]);             // 1/√2*|00> + 1/2*|10> + 1/2*|01>
        // // Rz(PI() / 6.0, register[0]);
        // H(register[0]);


        // Ry(ArcSin(Sqrt(3.0)/2.0), register[0]);
        Ry(2.0 * ArcSin(Sqrt(1.0/3.0)), register[0]);
        X(register[0]);
        Controlled H(register[0..0], register[1]);
        X(register[0]);
        DumpRegister($"dump", register);
    }


    /// # Summary
    /// In this problem, you are given a three-qubit register in the |000>
    /// state. Your goal is to put it into this superposition:
    ///
    ///     |register> = 1/√3(|100> + |010> + |001>)
    ///
    /// Note that all states have equal amplitude. This is known as the
    /// three-qubit "W State".
    ///
    /// # Input
    /// ## register
    /// A three-qubit register in the |000> state.
    operation Challenge2 (register : Qubit[]) : Unit {
        Ry(2.0 * ArcSin(Sqrt(1.0/3.0)), register[0]);
        X(register[0]);
        Controlled H(register[0..0], register[1]);
        X(register[0]);
        // Challenge2(register);
        
        SWAP(register[0], register[2]);
        X(register[1]);
        X(register[2]);
        CCNOT(register[1], register[2], register[0]);
        X(register[1]);
        X(register[2]);
    }


    /// # Summary
    /// In this problem, you are given a three-qubit register in the |000>
    /// state. Your goal is to encode 8 samples of a sine wave into its
    /// amplitude. The samples should be evenly spaced in π/4 increments,
    /// starting with 0 and ending with 7π/4. The sine wave samples are laid
    /// out in the table below:
    ///
    ///  Index  |  Value
    /// ------- | -------
    ///    0    |    0
    ///    1    |   1/√2
    ///    2    |    1
    ///    3    |   1/√2
    ///    4    |    0
    ///    5    |  -1/√2
    ///    6    |   -1
    ///    7    |  -1/√2
    ///
    /// Note that these samples are not normalized; if they were used as state
    /// amplitudes, they would result in a total probability greater than 1.
    ///
    /// Your first task is to normalize the sine wave samples so they can be
    /// used as state amplitudes. Your second task is to encode these 8
    /// normalized values as the amplitudes of the three-qubit register.
    ///
    /// # Input
    /// ## register
    /// A three-qubit register in the |000> state.
    ///
    /// # Remarks
    /// This kind of challenge is common in quantum computing. Essentially, you
    /// need to construct an efficient circuit that will take real data and
    /// encode it into the superposition of a qubit register. Normally, it
    /// would take 8 doubles to store these values in conventional memory - a
    /// total of 512 classical bits. You're going to encode the exact same data
    /// in 3 qubits. We'll talk more about how quantum computers do things
    /// faster than classical computers once we get to quantum algorithms, but
    /// this is a good first hint.
    operation Challenge3 (register : Qubit[]) : Unit {
        H(register[0]);
        H(register[1]);
        H(register[2]);
        
        use helper1 = Qubit[2];

        // tangle helper bit 0 with 000
        ApplyToEach(X, register);
        Controlled X(register, helper1[0]);
        ApplyToEach(X, register);

        // tangle helper bit 1 with 100
        ApplyToEach(X, register[1 .. 2]);
        Controlled X(register, helper1[1]);
        ApplyToEach(X, register[1 .. 2]);

        CNOT(helper1[0], register[1]);   // 000 -> 010
        CNOT(helper1[1], register[1]);   // 100 -> 110

        DumpMachine($"dump", register);

        // reset helper bits to 0
        X(register[0]);     // 010 10 -> 010 00
        X(register[2]);
        Controlled H(register, helper1[0]);
        X(register[0]);
        X(register[2]);

        X(register[2]);     // 110 01 -> 110 00
        DumpMachine($"dump", register);
        Controlled H(register, helper1[1]);
        X(register[2]);

        DumpMachine($"dump2", register);

        X(register[1]); // 100 -> 110, 101 -> 111
        Controlled Z(register[0..1], register[2]);
        X(register[1]);
        Controlled Z(register[1..1], register[0]);
    }

    // operation learn (register : Qubit[]) : Unit {
    //     H(register[0]);
    //     use helper = Qubit();
    //     CNOT(register[0], helper);
    //     CNOT(helper, register[0]);
    //     // DumpMachine($"Learning", register);
    //     H(helper);
    // }

    /// # Summary
    /// This problem is the same as Challenge 3, but now you must construct a
    /// superposition using 8 samples of a cosine wave instead of a sine wave.
    /// For your convenience, the cosine samples are listed in this table:
    ///
    ///  Index  |  Value
    /// ------- | -------
    ///    0    |    1
    ///    1    |   1/√2
    ///    2    |    0
    ///    3    |  -1/√2
    ///    4    |   -1
    ///    5    |  -1/√2
    ///    6    |    0
    ///    7    |   1/√2
    ///
    /// Once again, these values aren't normalized, so you will have to
    /// normalize them before using them as state amplitudes.
    ///
    /// # Input
    /// ## register
    /// A three-qubit register in the |000> state.
    operation Challenge4 (register : Qubit[]) : Unit {
        Challenge3(register);

        X(register[0]);     // 010 -> 000
        X(register[2]);
        CCNOT(register[0], register[2], register[1]);
        X(register[0]);
        X(register[2]);

        X(register[2]);     // 110 -> 100
        CCNOT(register[0], register[2], register[1]);
        X(register[2]);

        Z(register[1]);     // flipping signs
    }
}
