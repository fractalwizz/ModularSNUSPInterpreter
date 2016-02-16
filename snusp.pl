#!/usr/bin/perl
use Modern::Perl;
use Data::Dumper;

my @prog;
my @tape;
my @stack;
my @proptr = (0,0);

my $buffer = "";
my $bail = 1;
my $dir = 0;
my $memptr = 0;

my $file = shift;
my $width = calcwidth($file);

@prog = process($file, $width);
@proptr = startpos();

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
    }
    
    moveptr($dir, @proptr);
    
    if ($proptr[0] < 0 || $proptr[0] > $width ||
        $proptr[1] < 0 || $proptr[1] > $width  )
    {
        print "Program Termination: Boundary\n";
        last;
    }
}

#==================SUBROUTINES==========================

#----------------------------
#--------Instructions--------
#----------------------------

##\
 # Shifts memptr right
 #/
sub shiftright { $memptr++; }

##\
 # Shifts memptr left unless at the left end of tape
 #/
sub shiftleft { unless ($memptr == 0) { $memptr--; } }

##\
 # Increments value of cell at memptr
 #/
sub increment { $tape[$memptr]++; }

##\
 # Decrements value of cell at memptr
 #/
sub decrement { $tape[$memptr]--; }

sub input {
    my $val;
    
    print "?";
    chomp($val = <>);
    $tape[$memptr] = ord $val;
}

sub inputa {
    my $val;
    
    if ($buffer) {
        $val = ord substr($buffer, 0, 1);
        $tape[$memptr] = $val;
        $buffer = substr($buffer, 1);
    } else {
        print "?";
        $val = <>;

        if (not defined $val) {
            print "ERROR: input not found";
        } else {
            $buffer = $val . chr(0);
            $val = ord substr($buffer, 0, 1);
            $buffer = substr($buffer, 1);

            $tape[$memptr] = $val;
        }
    }
}

sub output { print chr $tape[$memptr]; }

sub lurd {
    my ($ptr) = @_;
    my $out;
    
    for ($ptr) {
        when (0) { $out = 1; }
        when (1) { $out = 0; }
        when (2) { $out = 3; }
        when (3) { $out = 2; }
    }
    
    return $out;
}

sub ruld {
    my ($ptr) = @_;
    my $out;
    
    for ($ptr) {
        when (0) { $out = 3; }
        when (1) { $out = 2; }
        when (2) { $out = 1; }
        when (3) { $out = 0; }
    }
    
    return $out;
}

sub moveptr {
    my ($dir) = @_;
    
    for ($dir) {
        when (0) { $proptr[1]++; }
        when (1) { $proptr[0]++; }
        when (2) { $proptr[1]--; }
        when (3) { $proptr[0]--; }
    }
}

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