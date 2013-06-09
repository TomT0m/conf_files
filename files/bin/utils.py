#encoding: utf-8

""" utils : 
	small scripts utilities

	"""

import os

def get_console_size():
	""" returns current text geometry of terminal"""
	rows, columns = os.popen('stty size', 'r').read().split()
	return int(rows), int(columns)


def print_columns(col_size, liste):
	""" prints ''liste'' elements 
	arranged in columns of size ''col_size'' """
	line = ""
	for name in liste :
		rest = col_size - len(name[0])
		line = line + name[1] + (" " * rest)
	print(line)

def calc_columns(max_len):
	""" get num & size of columns """
	( _ , columns) = get_console_size()
	num_cols = int(columns) // max_len
	col_size = int(columns) // num_cols

	return (num_cols, col_size)

def column_lister(names):
	""" lists by columns growing in same columns """
	max_size = max([len(nom) for nom in names ])
	
	(num_cols, col_size) = calc_columns(max_size)

	names_1 = names[0:num_cols-1]
	name_iterator = 0
	while name_iterator <= len(names):
		num = min(name_iterator + num_cols, len(names))
		names_1 = names[name_iterator:num]
		name_iterator = name_iterator + num_cols

		print_columns(col_size, names_1)

def order_column_lister(names, to_draw = None):
	""" list by columns, growing left -> right then up -> down """
	total = len(names)

	max_size = max([len(nom) for nom in names ])
	"♪"
	if not to_draw:
	 	to_draw = names

	names = list(zip(names, to_draw))

	(num_cols, col_size) = calc_columns(max_size)

	by_col = total // num_cols
	if ( by_col * num_cols < total) : 
		by_col = by_col + 1

	assert(by_col * num_cols >= total)

	slices = [list(range(x, min(x + by_col, total) )) for x in range(0, total, by_col) ]
	
	assert(max(slices[num_cols-1]) ==  total-1)
	for line_num in slices[0]:
		names_in_line = [ 
			names[tranche[line_num]] 
			   for tranche in slices 
			   if line_num < len(tranche)
		]
		print_columns(col_size, names_in_line)

def paged_printer(line):
	""" printer with paged output : 
		* prints a line
		* pauses when printed ''heigth of terminal'' lines"""
	num_line = 0
	(rows, _ ) = get_console_size()
	cont = True
	while cont:
		print(line)
		num_line = num_line + 1
		if(num_line == rows):
			print("pause. Continue or quit")
		# num_line = num_line + 1

