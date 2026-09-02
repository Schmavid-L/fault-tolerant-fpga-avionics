module majority_voter_tb;

    logic A;
    logic B;
    logic C;
    logic Vote;

    // DUT
    majority_voter dut (
        .A(A),
        .B(B),
        .C(C),
        .Vote(Vote)
    );

    initial begin

        A = 0; B = 0; C = 0;
        #10;
        if (Vote !== 0)
            $fatal("Failed: 000");

        A = 0; B = 0; C = 1;
        #10;
        if (Vote !== 0)
            $fatal("Failed: 001");

        A = 0; B = 1; C = 0;
        #10;
        if (Vote !== 0)
            $fatal("Failed: 010");

        A = 0; B = 1; C = 1;
        #10;
        if (Vote !== 1)
            $fatal("Failed: 011");

        A = 1; B = 0; C = 0;
        #10;
        if (Vote !== 0)
            $fatal("Failed: 100");

        A = 1; B = 0; C = 1;
        #10;
        if (Vote !== 1)
            $fatal("Failed: 101");

        A = 1; B = 1; C = 0;
        #10;
        if (Vote !== 1)
            $fatal("Failed: 110");

        A = 1; B = 1; C = 1;
        #10;
        if (Vote !== 1)
            $fatal("Failed: 111");  // fatal kills program if the right majority vote shows

        $display("PASS: All majority voter tests passed.");
        $finish;

    end

endmodule