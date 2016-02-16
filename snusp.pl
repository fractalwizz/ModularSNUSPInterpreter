#!/usr/bin/perl
use Modern::Perl;
use Data::Dumper;

my @prog;
my @tape;
my @stack;
my @proptr = (0,0);

my $bail = 1;
my $dir = 0;
my $memptr = 0;

# initialization
my $file = shift;
my $width = calcwidth($file);

@prog = process($file, $width);
@proptr = startpos();

# program execution
while ($bail) {
    my $char = $prog[$proptr[0]][$proptr[1]];
    
    for ($char) {
        when ('>') { shiftright();                                }
        when ('<') { shiftleft();                                 }
        when ('+') { increment();                                 }
        when ('-') { decrement();                                 }
        when (',') { input();                                     }
        when ('.') { output();                                    }
        when ('\\'){ $dir = lurd($dir);                           }
        when ('/') { $dir = ruld($dir);                           }
        when ('!') { moveptr($dir, @proptr);                      }
        when ('?') { moveptr($dir, @proptr) if (!$tape[$memptr]); }
        when ('@') { push(@stack, [$dir, @proptr]);               }
        when ('#') { if (@stack) {
                         ($dir, @proptr) = @{pop @stack};
                         moveptr($dir, @proptr);
                     } else {
                         $bail--;
                     }
                                                                  }
        when ('\n'){ $bail--;                                     }
    }
    
    moveptr($dir, @proptr);
    
    # out-of-bounds detection
    if ($proptr[0] < 0 || $proptr[0] > $width ||
        $proptr[1] < 0 || $proptr[1] > $width  )
    {
        print "\nProgram Termination: Boundary\n";
        last;
    }
}

print "\nProgram Termination: # on empty stack\n";
exit(0);

#==================SUBROUTINES==========================

#----------------------------
#--------Instructions--------
#----------------------------

##\
 # Shifts memptr right
 #/
sub shiftright { $memptr++; }

##\
 # Shifts memptr left (if it can)
 #/
sub shiftleft { unless ($memptr == 0) { $memptr--; } }

##\
 # Increments value in cell at memptr
 #/
sub increment { $tape[$memptr]++; }

##\
 # Decrements value in cell at memptr
 #/
sub decrement { $tape[$memptr]--; }

##\
 # Requests input from User
 # Saves input as dec to cell at memptr 
 #/
sub input {
    my $val;
    
    print "?";
    chomp($val = <>);
    $tape[$memptr] = ord $val;
}

##\
 # Prints ASCII value of cell at memptr
 #/
sub output { print chr $tape[$memptr]; }

##\
 # Mirrors direction for '\'
 # r->d, d->r, l->u, u->l
 #
 # param: $dir: current execution direction
 #
 # return: $out: new execution direction
 #/
sub lurd {
    my ($dir) = @_;
    my $out;
    
    for ($dir) {
        when (0) { $out = 1; }
        when (1) { $out = 0; }
        when (2) { $out = 3; }
        when (3) { $out = 2; }
    }
    
    return $out;
}

##\
 # Mirrors direction for '/'
 # r->u, d->l, l->d, u->r
 #
 # param: $dir: current execution direction
 #
 # return: $out: new execution direction
 #/
sub ruld {
    my ($dir) = @_;
    my $out;
    
    for ($dir) {
        when (0) { $out = 3; }
        when (1) { $out = 2; }
        when (2) { $out = 1; }
        when (3) { $out = 0; }
    }
    
    return $out;
}

#----------------------------
#-----------Util-------------
#----------------------------

##\
 # Given direction, gets position of next instruction
 #
 # param: $dir: current execution direction
 #/
sub moveptr {
    my ($dir) = @_;
    
    for ($dir) {
        when (0) { $proptr[1]++; }
        when (1) { $proptr[0]++; }
        when (2) { $proptr[1]--; }
        when (3) { $proptr[0]--; }
    }
}

##\
 # Determines the starting position for execution
 #
 # return: @out:  position of '$' (if '$' exists)
 # return: @left: position of upper left instruction (if '$' doesn't exist)
 #/
sub startpos {
    my @left;
    my @out;

    for my $a(0 .. @prog - 1) {
        for my $b(0 .. @{$prog[0]} - 1) {
            if (!@left && $prog[$a][$b] =~ m/[\>\<\+\-\.\,\\\/\!\?\@\#\=\|\$\n]/) {
                @left = ($a, $b);
            }
            
            if ($prog[$a][$b] ~~ '$') { @out = ($a, $b); }
        }
    }
    
    return (@out) ? @out : @left;
}

##\
 # File converted to 2D array of characters (program instructions)
 # all lines spaced to same width (avoids array index bugs)
 #
 # return: @out: 2D array of characters in the program
 #/
sub process {
    my ($file, $width) = @_;
    my @out;
    my $i = 0;
    
    open(FILE, '<', $file) or die("Can't open $file: $!\n");
    
    while (<FILE>) {
        chomp(my $str = $_);
        
        $str .= ' ' x ($width - length($str)) . "\n";
        my $tmp = $str;
        
        for (0 .. length($tmp) - 1) {
            my $char = substr($str, 0, 1);
            $str = substr($str, 1);
            push(@{$out[$i]}, $char);
        }
        
        $i++;
    }
    
    return @out;
}

##\
 # Calculates the width of input program file
 #
 # param: $file: name of input program file
 #
 # return: $out: width of input program file
 #/
sub calcwidth {
    my ($file) = @_;
    my $out = 0;
    
    open(FILE, '<', $file) or die("Can't open $file: $!\n");
    
    while (<FILE>) {
        chomp(my $str = $_);
        
        if (length $str > $out) { $out = length $str; }
    }
    
    close (FILE);
    return $out;
}