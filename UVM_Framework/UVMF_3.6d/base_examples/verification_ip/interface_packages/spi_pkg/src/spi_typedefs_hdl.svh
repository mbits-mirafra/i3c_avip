//----------------------------------------------------------------------
//   Copyright 2013 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : spi interface agent
// Unit            : Typedefs
// File            : spi_typedefs_hdl.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: 
// This file contains defines and typedefs to be compiled and synthesized
// for use in Veloce.  It is also used by the interface package that is 
// used by the host server performing transaction level simulation 
// activities.
//
//----------------------------------------------------------------------
//
parameter int SPI_XFER_WIDTH = 8;

typedef enum {SPI_SLAVE_READ, SPI_SLAVE_WRITE} spi_op_t;
typedef enum {MOSI,MISO, TO_SPI, FROM_SPI} spi_dir_t;

typedef struct packed {
  spi_dir_t                dir;
  bit [SPI_XFER_WIDTH-1:0] spi_data;
} spi_transaction_s;

typedef struct packed {
  spi_transaction_s spi_txn;

  spi_op_t  op;
  bit [2:0] addr;
  bit [3:0] data;
  bit       status;
  bit       command;
} spi_mem_slave_transaction_s;

typedef bit[$bits(spi_mem_slave_transaction_s)-1:0] spi_transaction_bits_t;

typedef struct packed {
  uvmf_parameterized_agent_configuration_base_s uvmf_cfg;

  bit       SPCR_SPIE;
  bit       SPCR_SPE;
//bit       SPCR_RESERVED;
  bit       SPCR_MSTR;
  bit       SPCR_CPOL;
  bit       SPCR_CPHA;
  bit [1:0] SPCR_SPR;
//bit [1:0] SPER_ICNT;
//bit [3:0] SPER_RESERVED;
  bit [1:0] SPER_ESPR;
} spi_configuration_s;

