## Modular SNUSPInterpreter
Interpreter for the Modular SNUSP language written in Perl<br>
V0.9

### Disclaimer
Fractalwizz is not the author of any of the example programs.<br>
They are only provided to test the interpreter's functionality

### Module Dependencies
Modern::Perl

### Usage
perl snusp.pl [options] inputFile<br>
  -s:        Tape Cell Storage (255 overflow) (default: unlimited)<br>
  -l [int]:  Tape Length (default: unlimited)<br>
  inputFile: path of file
  
ie:<br>
perl snusp.pl ./Examples/ackermann.snusp<br>
perl snusp.pl -s multiply.snusp

### Features
SNUSP Esoteric Programming Language<br>
Supports any text file with valid SNUSP code<br>
Modular capabilites (subroutines)<br>
Define Memory Tape Length Constraint (Cmd parameter)<br>
Define Memory Tape Cell Storage Constraint (Cmd parameter)

### TODO
Cmd parameter for trace information of each step<br>
Cmd parameter for advanced trace (diagram + pointer visualization)

### License
MIT License<br>
(c) 2016 Fractalwizz<br>
http://github.com/fractalwizz/ModularSNUSPInterpreter