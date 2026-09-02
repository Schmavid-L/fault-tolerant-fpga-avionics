module majority_voter(
    input logic A,
    input logic B,
    input logic C,
    output logic Vote        // ports
);

assign Vote =  (A & B) | (A & C) | (B & C) ;


    endmodule