
module fault_detector(

    input logic active_a,
    input logic active_b,
    input logic active_c,
    
    input logic voted_active,
    
    
    
    
    output logic fault_detect_a,
    output logic fault_detect_b,
    output logic fault_detect_c
    
    
    
    );
    
   
    assign fault_detect_a= active_a ^ voted_active;
    assign fault_detect_b= active_b ^ voted_active;
    assign fault_detect_c= active_c ^ voted_active;
 
    
    
    
    
    
    
    
endmodule
