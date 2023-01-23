////////////////////////////////////////////////////////////////////////////////
// NOTE: rst was unused in original design
module alu #(OP_WIDTH = 8, RESULT_WIDTH = OP_WIDTH+1) ( 
input bit                     clk,      // acknowledment from wishbone slave
input bit                     rst,      // acknowledment from wishbone slave
input bit                     valid,    // acknowledment from wishbone slave
input bit  [2:0]              op,
input bit  [OP_WIDTH-1:0]     a,
input bit  [OP_WIDTH-1:0]     b,
output bit                    done,     // acknowledment from wishbone slave
output bit                    ready,    // acknowledment from wishbone slave
output bit [RESULT_WIDTH-1:0] result   // data input from wishbone slave
);

int res_pipe [4:0];
bit [2:0] done_count;

typedef enum bit [1:0] {
  IDLE,
  COUNTING,
  DONE,
  AFTER_DONE
  } fsm_state_e;
fsm_state_e fsm_state;
//
// done is a single-bit pulse
//

parameter DONE_RESET = 5;
always @ (posedge clk )
  if ( ! rst )
    begin : reset_asserted
    done <= 1'b0;
    ready <= 1'b1;
    result <= 'b0;
    res_pipe[0] <= 'b0;
    res_pipe[1] <= 'b0;
    res_pipe[2] <= 'b0;
    res_pipe[3] <= 'b0;
    res_pipe[4] <= 'b0;
    done_count <= DONE_RESET;
    fsm_state <= IDLE;
    end : reset_asserted
  else
    begin : reset_released
    if ( valid )
      begin : valid_true
        if ( (op == 3'b001) || 
             (op == 3'b010) || 
             (op == 3'b011) || 
             (op == 3'b100) ) 
          begin : valid_opcode
          // no_op  = 3'b000,
          // add_op = 3'b001, 
          // and_op = 3'b010,
          // xor_op = 3'b011,
          // mul_op = 3'b100,
          // rst_op = 3'b111
          case (op)
            3'b001: res_pipe[0] <= a + b;
            3'b010: res_pipe[0] <= a & b;
            3'b011: res_pipe[0] <= a ^ b;
            3'b100: res_pipe[0] <= a * b;
            endcase
    done_count <= DONE_RESET;
    // ready <= 1'b0;
          end : valid_opcode
        end   : valid_true
      else
        begin : valid_false
  if (done_count > 0)
    begin : decrement_done
    done_count <= done_count -1;
    end : decrement_done
  if (done_count == 1)
    begin
    done <= 1'b1;
    end
  else
    done <= 1'b0;
    end : valid_false
    case (fsm_state )
      IDLE:
        if ( valid)
          begin
          fsm_state <= COUNTING;
          ready <= 1'b0;
          end
        else
          ready <= 1'b1;
      COUNTING:
        if ( done )
          fsm_state <= AFTER_DONE;
      AFTER_DONE:
        begin
        fsm_state <= IDLE;
        ready <= 1'b1;
        end
      endcase

    res_pipe[1] <= res_pipe[0];
    res_pipe[2] <= res_pipe[1];
    res_pipe[3] <= res_pipe[2];
    res_pipe[4] <= res_pipe[3];
    result <= res_pipe[4];
    end : reset_released

endmodule
