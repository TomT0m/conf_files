#!/usr/bin/python3
"""
#Description : Voir le programme télé du soir
#Group: TV
"""

URL = "http://www.programme-tv.net/programme/programme-tnt.html"

import urllib.request
import xml.etree.ElementTree as etree 
import lxml.html

def pretraitement(text):
	res = ""
	for line in text.readlines():
		line = str(line)
		res += line.replace("&icirc;", "î")
	return res


from fabulous.color import *
from fabulous import xterm256


def parse_data(fic):
	""" Parses & extracts TV informations """
		
	# content div class : contenu grille grilleprimes
	
	page = lxml.html.parse(fic)
	# res = tree.find('//div@.contenu.grille.grilleprimes')
	plop  = [ elem for res in page.xpath('//div[@class="contenu grille grilleprimes"]') for elem in res.xpath("ul/li")]
	
	def print_(chaine):
		"plop"
		noms = chaine.xpath('p/a[1]/@title')
			
		for prog in range(len(noms)):
			titre = noms[prog]
			print("Titre : {}".format(highlight256('cyan',noms[prog])))
			
			info_sup = chaine.xpath('p[{}+1]/em/text()'.format(prog))
			
			heure = chaine.xpath('p[{}+1]/span/text()'.format(prog))[0]
			print(highlight256('orangered', heure))
			duree, sous_titre = None, None
			if len(info_sup) == 2:
				sous_titre = info_sup[0]
				duree = info_sup[1]
			elif len(info_sup) == 1:
				sous_titre = info_sup[0]
			print ("Sous titre : {}, durée : {}".format(sous_titre, duree) )


	for chaine in plop : # plop:
		print_(chaine)

def main():
	""" Main function"""
	content = urllib.request.urlopen(URL)
	parse_data(content)



if __name__ == "__main__":
	main()
	


