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
// Project         : GPIO Example Project Bench
// Unit            : Typedefs
// File            : test_typedefs.svh
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This file contains defines and typedefs used by the
//      project test package.  
//
//----------------------------------------------------------------------
//
//
typedef gpio_example_configuration    #(TEST_GPIO_READ_PORT_WIDTH, TEST_GPIO_WRITE_PORT_WIDTH ) gpio_example_configuration_t;
typedef gpio_example_environment      #(TEST_GPIO_READ_PORT_WIDTH, TEST_GPIO_WRITE_PORT_WIDTH)  gpio_example_environment_t;
typedef gpio_example_sequence_base    #(TEST_GPIO_READ_PORT_WIDTH, TEST_GPIO_WRITE_PORT_WIDTH)  gpio_example_sequence_base_t;
typedef example_derived_test_sequence #(TEST_GPIO_READ_PORT_WIDTH, TEST_GPIO_WRITE_PORT_WIDTH)  example_derived_test_sequence_t;
