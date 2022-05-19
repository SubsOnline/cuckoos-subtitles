#!/bin/bash


csplit -s -f part ./ts  '/^./' {1}
