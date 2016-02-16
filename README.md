## Modular SNUSPInterpreter
Interpreter for the Modular SNUSP language written in Perl<br>
V0.8

### Disclaimer
Fractalwizz is not the author of any of the example programs.<br>
They are only provided to test the interpreter's functionality

### Module Dependencies
Modern::Perl

### Usage
perl snusp.pl inputFile<br>
  inputFile: path of file<br>
  
ie:<br>
perl snusp.pl ./Examples/ackermann.snusp<br>
perl snusp.pl multiply.snusp

### Features
SNUSP Esoteric Programming Language<br>
Supports any text file with valid SNUSP code<br>
Modular capabilites (subroutines)<br>

### TODO
Optimization / Restructure of subroutine code<br>
Cmd parameter for memory cell storage (overflow 255->0 or unlimited)<br>
Cmd parameter for memory tape length (default: unlimited)<br>
Cmd parameter for trace information of each step<br>
Cmd parameter for advanced trace (diagram + pointer visualization)

### License
MIT License<br>
(c) 2016 Fractalwizz<br>
http://github.com/fractalwizz/ModularSNUSPInterpreter