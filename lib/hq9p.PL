#!/usr/bin/env perl

use Config;
use File::Basename qw[basename dirname];
use Cwd;

my $origdir = cwd;
chdir dirname $0;
my $file = basename( $0, '.PL' );
$file .= '.com' if $^O eq 'VMS';

open OUT, "> $file" or die "Can't create $file: $!";

print OUT <<HEADER, do{ local $/ = undef; <DATA> };
#!$Config{perlpath}

use strict;
\$|  = 1;
\$^W = 1;

HEADER

close OUT;

chmod 0755, $file;

chdir $origdir;

__END__

use vars qw[$VERSION %COMMANDS $PROGRAM];
$VERSION = (qw$Revision 0.2$)[1];

%COMMANDS = (
  'h' => sub { print "Hello, world!\n" },
  'q' => sub {
               open FILE, "< $PROGRAM"
                 or die "Can't open $PROGRAM: $!\n";
               print while <FILE>;
               close FILE
                 or die "Can't close $PROGRAM: $!\n";
             },
  '9' => sub {
               foreach ( reverse 1 .. 99 ) {
                 my $b = ( $_ == 1 ? 'bottle' : 'bottles' );
                 print "$_ $b of beer on the wall.\n\n" if $_ != 99;
                 print "$_ $b of beer on the wall,\n",
                       "$_ $b of beer,\n",
                       "Take one down and pass it around,\n";
               }
               print "No more bottles of beer on the wall.\n";
             },
  '+' => sub { },
);

die "Usage: $0 program\n" unless @ARGV == 1;

$PROGRAM = shift;

open PROG, "< $PROGRAM" or die "Can't open $PROGRAM: $!\n";
while ( <PROG> ) {
  chomp;
  s/\s+//g;
  foreach ( split // ) {
    $_ = lc;
    if ( exists $COMMANDS{$_} ) {
      $COMMANDS{$_}->();
    } else {
      warn "Unknown command: $_\n";
    }
  }
}
close PROG or die "Can't close $PROGRAM: $!";

exit;

1;

__END__

=pod

=head1 NAME

hq9p - An HQ9+ Interpreter

=head1 SYNOPSIS

 hq9p program_file

=head1 ABSTRACT

The HQ9+ programming language has a simple syntax, and solves several
very common problems that plague programmers.

=head1 DESCRIPTION

There are four commands.  While this is a very simple language, it
allows you to easily do some things that would be very difficult in
other programming languages.

All commands may appear more than once in your program, but it could
produce some nasty output.  All commands are case-insensitive.

=head2 Commands

=head3 h

Prints "Hello, world!" to the screen, sans the quotes.  It will be
trailed by a new-line character.

=head3 q

This makes your program a quine.  It will print copies of itself.

=head3 9

Prints out the entire lyrics of the "99 bottles of beer on the wall"
song.

=head3 +

Increments the accumulator.

=head1 EXAMPLES

Print "Hello, world!".

 h

Print a quine.

 q

Print four copies of your program.

 qqqq

Increment the accumulator.

 +

Do it a lot.

 ++++++++++++++

=head1 DIAGNOSTICS

=head2 Unknown command: %s

All unknown commands will produce this warning.  It's not wholy useful
to quit execution, so a warning to STDERR will suffice.  Unknown commands
are any characters not included in the set case-insensitive set:
'h', 'q', '9', '+', and white-space characters.

=head2 Can't open %s: %s

The program will stop execution in the case of being unable to open
a file.  This may happen for the program file when passed to the
interpreter, or when the command 'q' executes.

=head2 Can't close %s: %s

The program will stop execution in the rare case of being unable to
close a file.  This may happen for the program file when passed to the
interpreter, or when the command 'q' executes.

=head1 AUTHOR

Casey West <F<casey@geeknest.com>>

=head1 COPYRIGHT

Copyright (c) Casey West, all rights reserved.
This software is governed by the Artistic License found within
the source distribution.

=head1 SEE ALSO

HQ9+ Language Specification
  http://www.cliff.biffle.org/esoterica/hq9plus.html

=cut
