# Light-Hash-Algorithm-DES-S-box
This is a project of the Hardware Embedded Security course of the master's degree program in Cybersecurity in Pisa. The assignment details are defined in the related pdf in the Doc folder.


## Directories:

### **Doc**
1. **light_hash_algorithm-DES-S-box.pdf**: this file contains the necessary details for the assignment.
2. **project_report.pdf**: this file is the final report.

### **Db**
This folder contains the files used to implement the requirements:
1. **Sbox**: is the implementation of the required Sbox.
2. **Round**: implementation of a single round of the light hash algorithm.
3. **HashIteration**: implementation of the hash function that exploits Round.
4. **lightHashDES**: this module performs a light hash function based on DES s-box.

### **Model**
This folder contains the model of the circuit for the implementation of the light hash algorithm.

### **Modelsim**
The folder contains all the files useful for simulating the project in modelsim. It is also provided with the scripts “build.py” and “clean.py” so as to help in building operations and removing files at the end of the simulation.

### **Tb**
The folder contains all the tests that were used to prove the correctness of the design by exploiting simulations with modelsim.

### **Quartus**
This folder contains the design of the digital circuit made with Quartus.
