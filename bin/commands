#! /usr/bin/python3
#encoding: utf-8

"""
#Description : a script listing & showing description of other scripts

scripts listed must follow the following convention : a line beginning with # and matching 'Description( )?:(.*)'

Other meta information includes : 
	"Group" if command is a meta command, used as a simily path
"""

import os, sys
import os.path as path

import glob
from optparse import OptionParser


def matches_spec(scriptname):
	""" Returns wether or not @scriptname 
	matches our scripts managemement conventions
	"""
	try:
		with open(scriptname) as f:
			for line in f:
				if '#Description' in line:
					return True
				# if '#Group' in line:
				#	return True
	except Exception:
		return False
import re

def extract_pair(line):
	res = re.search('^#(\w+) *:(.*)$', line)
	if res:
		return [(res.group(1).strip(), res.group(2))]
	return []

def read_datas(scriptname):
	datas = {}
	with open(scriptname) as f:
		datas = {key: val for line in f 
	   			for (key, val) in 
	   				extract_pair(line) }
	   			

	return datas

DIRECTORY = path.expanduser("~/bin")

class Script(object):
	""" Storing infos about a script"""
	def __init__(self, script, infos):
		self.infos = infos
		self.script = script
	
	@property
	def path(self):
		return path.dirname(self.script)
	@property
	def name(self):
		return path.basename(self.script)
	
	@property
	def description(self):
		return self.infos["Description"]
	@property
	def is_meta(self):
		return "Meta" in self.infos

def analyse_directory(bin_path):
	os.chdir(bin_path)
	script_names = [path for path in glob.glob(path.join(bin_path, "*"))
		if matches_spec(path) ]
	scripts = []

	for script in script_names:
		script = Script(script, read_datas(script))
		scripts.append(script)

	return scripts

def create_cl_parser():
	parser = OptionParser()
	
	parser.add_option("-c", "--complete", action = "store_true", default=False,
		   help = "to be used by bash autocomplete", dest = "complete")
	parser.add_option("-m", "--list-meta", action = "store_true", default=False,
		   help = "list meta commands", dest = "complete_meta")
	parser.add_option("-t", "--test", action = "store_true", default=False,
		   help = "Launches unit tests", dest = "tests")
	parser.add_option("-f", "--forward", metavar="DIR", default=False,
		   help = "to set command directory to an arbitrary directory", dest = "forward")
	return parser

import argparse
def create_argument_parser(description = None):
	""" New version with argparse """
	parser = argparse.ArgumentParser(description = description)

	parser.add_argument("-c", "--complete", action = "store_true", default=False,
		   help = "to be used by bash autocomplete", dest = "complete")
	
	parser.add_argument("-t", "--test", action = "store_true", default=False,
		   help = "Launches unit tests", dest = "tests")

import subprocess
def try_exec(directory, script_name, args):
	command = [os.path.join(directory, script_name)]
	command.extend(args)
	cmd = subprocess.Popen(command, shell = False)
	cmd.wait()

def command_in(command_str, command_list):
	return command_str in [ command.name for command in command_list]

def main():
	scripts = None
	
	
	directory = DIRECTORY
	scripts = analyse_directory(directory)
	
	# do we get a real command ?
	if len(sys.argv) >= 4 and command_in(sys.argv[3], analyse_directory(sys.argv[2])):
		try_exec(sys.argv[2], sys.argv[3], sys.argv[4:])
		exit(0)

	parser = create_cl_parser()
	(options, args) = parser.parse_args()


	if options.forward :
		directory = options.forward
	
	
	scripts = analyse_directory(directory)
	
	if options.complete :
		print(" ".join( [script.name for script in scripts] ))
	elif options.complete_meta:
		print(" ".join( [script.name for script in scripts 
		   if script.is_meta]))
	elif len(scripts) > 0:
		taille = max ( [len(script.name) for script in scripts])
		for script in scripts:
			
			print(" {}: {} ".format(script.name.ljust(taille), script.description))

if __name__ == "__main__":
	main()
