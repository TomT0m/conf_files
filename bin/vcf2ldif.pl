#! /usr/bin/perl

use Text::vCard::Addressbook;

# here are the perl modules you need to run this
#	http://search.cpan.org/author/JLAWRENC/Text-vFile-0.5/
#	http://search.cpan.org/author/LLAP/Text-vCard-1.0/


foreach $file (@ARGV) {
    print STDERR "\n$file\n";
    my $cards = Text::vCard::Addressbook->new( { 'source_file' => $file, } );

    foreach my $vcard ($cards->vcards()) {
#	print "Got card for " . $vcard->fn() . "\n";

	$name = $vcard->fullname();
	print($vcard->as_string());
	print('plop');
	$lastname = $name->family();
	$firstname = $name->given();
	print STDERR "Got card for " . $firstname ." ".$lastname . "\n";
	$cn = $lastname.", ".$firstname;

	@emails = $vcard->emails();
	$primary_email = "";
	$secondary_email = "";
	if ($emails[0] != "") {
	    $primary_email = $emails[0]->value();
	    print STDERR "\tprimary email = $primary_email\n";

	    if ($#emails > 0) {
		$secondary_email = $emails[1]->value();
		#print STDERR "secondary email = $secondary_email\n";
	    }
	    $dn = $cn.",mail=".$primary_email;
	} else {
	    $dn = $cn;
	}

	print "dn: $dn\n";
	print "objectclass: top\n";
	print "objectclass: person\n";
	print "objectclass: organizationalPerson\n";
	print "objectclass: inetOrgPerson\n";
	print "objectclass: mozillaAbPersonObsolete\n";
	print "givenName: $firstname\n";
	print "sn: $lastname\n";
	print "cn: $cn\n";


# Write email addresses

	if ($primary_email ne "") {
	    print "mail: $primary_email\n";
	    if ($secondary_email ne "") {
		print "mozillaSecondEmail: $secondary_email\n";
	    }
	}
	print "modifytimestamp: 0z\n";


# Write phone numbers

	@tels = $vcard->tels();

	$homephone = "";
	$workphone = "";
	$cellphone = "";
	$homefax = "";
	$workfax = "";
	foreach $tel (@tels) {
	    $typehash = $tel->{type};
	    if ($typehash->{fax} == 1) {
		if ($typehash->{work} == 1) {
		    $workfax = $tel->{value};
		}
		if ($typehash->{home} == 1) {
		    $homefax = $tel->{value};
		}
	    } else {
		if ($typehash->{work} == 1) {
		    $workphone = $tel->{value};
		}
		if ($typehash->{home} == 1) {
		    $homephone = $tel->{value};
		}
		if ($typehash->{cell} == 1) {
		    $cellphone = $tel->{value};
		}
	    }
	}

	if ($workphone ne "") {
	    print "telephoneNumber: $workphone\n";
	} else {
	    if ($homephone ne "") {
		print "telephoneNumber: $homephone\n";
	    } else {
		if ($cellphone ne "") {
		    print "telephoneNumber: $cellphone\n";
		}
	    }
	}
	if ($homephone ne "") {
	    print "homePhone: $homephone\n";
	}
	if ($cellphone ne "") {
	    print "mobile: $cellphone\n";
	}



# Write addresses

	@addresses = $vcard->addresses();

	foreach $addr (@addresses) {
	    $addrtype = $addr->{type};

	    $street = $addr->{street};
	    $street2 = "";
	    $street =~ s/\\,/\,/g;
	    if ($street =~ m/\\n/) {
		$x = pos($street);
		$street =~ s/\\n/\n/;
		@s = split('\n', $street, 10);
		$street = $s[0];
		$street2 = $s[1];
	    }
	    if ($addrtype->{work} == 1) {
		print "postalAddress: $street\n";
		if ($street2 ne "") {
		    print "mozillaPostalAddress2: $street2\n";
		}
		print "l: ", $addr->{city}, "\n";
		print "st: ", $addr->{region}, "\n";
		print "postalCode: ", $addr->{post_code}, "\n";
		if ($addr->{country} ne "") {
		    print "c: ", $addr->{country}, "\n";
		}
	    }
	    if ($addrtype->{home} == 1) {
		print "homePostalAddress: $street\n";
		if ($street2 ne "") {
		    print "mozillaHomePostalAddress2: $street2\n";
		}
		print "mozillaHomeLocalityName: ", $addr->{city}, "\n";
		print "mozillaHomeState: ", $addr->{region}, "\n";
		print "mozillaHomePostalCode: ", $addr->{post_code}, "\n";
		if ($addr->{country} ne "") {
		    print "mozillaHomeCountryName: ", $addr->{country}, "\n";
		}
	    }
	}

# web address
	if ($vcard->{URL} ne "") {
	    if ($vcard->{URL}->{value} ne "") {
		print "homeurl: ", $vcard->{URL}->{value}, "\n";
	    }
	}

# fin
	print "\n";


# add card to categories
	if ($vcard->{CATEGORY} ne "") {
	    $cat = $vcard->{CATEGORY}->{value};
	    @cats = split(',', $cat, 20);

	    foreach $x (@cats) {
		push @{ $categories{$x} } , $dn;
	    }
	}
    }
}

# print out categories

foreach $cat (keys %categories) {
    print STDERR "Writing category $cat\n";
    print "dn: cn=$cat\n";
    print "objectclass: top\n";
    print "objectclass: groupOfNames\n";
    print "cn: $cat\n";
    print "xmozillanickname: $cat\n";

    foreach $i ( 0 .. $#{ $categories{$cat} } ) {
	print "member: cn=$categories{$cat}[$i]\n";
    }

    print "\n";
}


print STDERR "Done!\n";
