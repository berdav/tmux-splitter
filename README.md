# Tmux splitter

Parallelize your workflow.

![Demo gif](resources/demo.gif)

## What is it?
This script will help your workflow by parallelizing tasks and
visualizing it.

When you start multiple tasks you can monitor them using `tmux`.

## How can I use it?

First of all select a command you want to execute on multiple arguments.

In these examples we will use a simple `ping`, we use it mainly for
`ansible` workflows on multiple roles and machines.

Export a variable with the command you want to execute on the multiple
arguments.
```bash
$ export TMUX_SPLITTER_CMD="ping"
```

Execute `tmux-splitter` specifing the arguments:
```bash
$ ./tmux-splitter.sh "1.1.1.1" "8.8.8.8" "0.0.0.0" "127.0.0.1"
```

You can specify the variable just for the single `tmux-splitter` run
using a command like:

```bash
$ TMUX_SPLITTER_CMD="ping" ./tmux-splitter.sh "1.1.1.1" "8.8.8.8" "0.0.0.0" "127.0.0.1"
```

The script will wait for you to hit return if the program in the local
tmux pane will exit incorrectly, otherwise it will automatically kill
the pane if the program exit correctly.
