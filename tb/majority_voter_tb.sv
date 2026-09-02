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

    A=0 ; B=0; C=0;
    #10

    A = 0; B = 0; C = 1;
        #10;

        A = 0; B = 1; C = 0;
        #10;


        A = 0; B = 1; C = 1;
        #10;

        A = 1; B = 0; C = 0;
        #10;
        A = 1; B = 0; C = 1;
        #10;

        A = 1; B = 1; C = 0;
        #10;
        A = 1; B = 1; C = 1;
        #10;

      end


    endmodule