# Light-Hash-Algorithm-DES-S-box

## Directories:

### Doc
1. **light_hash_algorithm-DES-S-box**: contains the requirements of the project.

### Db
This folder contains the files used to implement the requirements:
1. **Sbox**: is the implementation of the required Sbox.
2. **Round**: implementation of a single round of the light hash algorithm.
3. **HashIteration**: implementation of the hash function that exploits Round.
4. **lightHashDES**: this module performs a light hash function based on DES s-box.

### Model
This folder contains the model of the circuit for the implementation of the light hash algorithm.

### Modelsim
The folder contains all the files useful for simulating the project in modelsim. It is also provided with the scripts “build.py” and “clean.py” so as to help in building operations and removing files at the end of the simulation.
