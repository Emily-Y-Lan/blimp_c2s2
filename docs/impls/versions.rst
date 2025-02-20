Blimp Versions
==========================================================================

Blimp takes an iterative design approach, enabled through its modularity.
Different levels of Blimp's microarchitectural units can be composed to
form different versions of Blimp processors. This enabled the design of
these components to occur iteratively, adding on functionality as the
complexity of the processor progressed.

Blimp outlines the following units as first-class microarchitectural
blocks in the processor:

* **Fetch Unit** *(FU)*
* **Decode Issue Unit** *(DIU)*
* **Execute Unit(s)** *(XU)*
* **Writeback Commit Unit** *(WCU)*
* **Sequencing Unit** *(SQU)*
* **Squash Unit** *(SU)*

Currently, 1 version of the processor is implemented. The table below
details the level of each unit that each processor version requires:

.. list-table::
   :header-rows: 1
   :stub-columns: 1

   * - Proc. Version
     - FU Level
     - DIU Level
     - XU Levels
     - WCU Level
     - SQU Level
     - SU Level
   
   * - V1
     - 1
     - 1
     - 1
     - 1
     -
     -