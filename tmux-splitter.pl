#!/usr/bin/env perl

# Tmux splitter helper script.
# It will split the command provided in an environment variable evenly
# trough the screen and run them in parallel.
#
# Copyright (C) 2020  Davide Berardi <berardi.dav@gmail.com>
# Contributors:
#   Roberto Scolaro <roberto.scolaro21@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


use Getopt::Long;

# Print help and how to use the program
sub usage {
    print STDERR "$0 [--help | -h] [--verbose | -v] <arguments>\n";
    print STDERR "options:\n";
    print STDERR "    -h --help     Show this help\n";
    print STDERR "    -v --verbose  Print more information\n";
    print STDERR "    arguments     Arguments to launch tmux with\n";
    print STDERR "    The command is read from the environment variable TMUX_SPLITTER_CMD\n";
    exit 1
}

# Add a program to the starting queue
sub tmux_send_key_command {
    my $out = "send-keys ";
    my ($command, $args) = @_;
    $out .= "' ";
    $out .= "$command \"$ARGV[$_]\" ";
    # Error line
    $out .= "|| ( echo \"Failed! Press Enter to exit\"; read _ );";
    # Exit tmux pane
    $out .= "exit";
    $out .= "' ";
    # Send Return and prepare for next command
    $out .= "C-m ';' ";

    return $out;
}

# Split screen, it will be arranged by select layout function.
sub tmux_splitw {
    return "splitw -h ';' ";
}

# Select the layout, with tiled it will rearrange the panes and split
# accordingly.
sub tmux_select_layout {
    my ($layout) = @_;
    return "select-layout $layout ';' ";
}

# The command to execute.
my $command   = "";
# Verbose mode.
my $verbose   = 0;
# Help mode, just print the usage.
my $help      = 0;
# Tmux running command.
my $runcmd    = "tmux new-session -d ';' ";


GetOptions ("help|h"      => \$help,
            "verbose|v"   => \$verbose
)
or die("Error in command line arguments\n");
my $command=$ENV{'TMUX_SPLITTER_CMD'};

usage() if $help or $command eq "" or $#ARGV < 0;

print "[$command]\n" if $verbose;

# Run the first command
$runcmd .= tmux_send_key_command($command, $ARGV[$_]);
# Run the other commands and split the screen
for (1..$#ARGV) {
    $runcmd .= tmux_splitw();
    $runcmd .= tmux_send_key_command($command, $ARGV[$_]);
    $runcmd .= tmux_select_layout("tiled");
}

print "[ ] command:\n" if $verbose;
print "    $runcmd\n" if $verbose;

# Actual run.
`$runcmd`;
`tmux attach`;
