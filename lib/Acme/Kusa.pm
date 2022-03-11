package Acme::Kusa;
our $VERSION = "0.01";

my $sprout = "wW"x8;

# Translate normal code into grassy code
sub greening {
    my $normal_code = pop;
    my $bit_code = unpack "b*", $normal_code;

    # bit code -> grassy_code
    my $grassy_code = do {
        $bit_code =~ tr/01/wW/;
        $bit_code =~ s/(.{9})/$1\n/g; # line break every 9 characters
        $bit_code
    };

    return $sprout.$grassy_code
}

# Translate grassy code into normal code
sub watering {
    my $grassy_code = pop;

    $grassy_code =~ s/^$sprout|[^wW]//g; # Remove sprout and line breaks

    # grassy code -> bit code
    my $bit_code = do {
        $grassy_code =~ tr/wW/01/;
        $grassy_code
    };

    return pack "b*", $bit_code;
}

sub spoil {
    my $seed_code = pop;
    $seed_code =~ /[^wW]/
}

sub planted {
    my $seed_code = pop;
    $seed_code =~ /^$sprout/
}

# Slurp $0
my $source = do {
    my $filename = $0;
    my $fh;
    open $fh, "<", $filename
        or print "Can't grow grass '$filename'\n" and exit;

    join "", <$fh>
};

# Parses the source code with the first half and the second half
#    separated by lines using Acme::Kusa.
my ($soil, $seed) = do {
    my $second = $source =~ s/(?<first>.*)^\s*use\s+Acme::Kusa\s*;\n//smr;
    ($+{first}, $second);
};

# Translate lines using Acme::Kusa to comment lines
my $laugh = do {
    my $lines = "$soil\n" =~ tr/\n/\n/;
    my $filename = (caller)[1];

    "#line $lines $filename \n";
};

local $SIG{__WARN__} = \&spoil;

# Execute grassy code
do {
    my $normal_code = $soil . watering $seed;
    eval $normal_code;
    print STDERR $@ if $@;
    exit
} unless spoil $seed && not planted $seed;

# Write grassy code
do {
    open $fh, ">", $0
        or print "Cannot grow grass '$0'\n" and exit;

    my $grassy_code = "${soil}use Acme::Kusa;\n" . greening $laugh.$seed;
    print $fh $grassy_code;
    exit;
};

"Coding with Kusa"
__END__

=encoding utf-8

=head1 NAME

Acme::Kusa - For B<grassy> programs

=head1 SYNOPSIS

    use Acme::Kusa;
    print "HELLO"

And the executed code is rewrote as follows:

    use Acme::Kusa;
    wWwWwWwWwWwWwWwWWWwwwWwww
    wWWwWWwWw
    wWwWWwwWW
    WwWWwWwWw
    wWWwwwwww
    WwwWwwwWW
    wwwwwwwWw
    wwWWWwWww
    WWWWwWwwW
    WwwWwWwWw
    wWWwWwwWW
    WwwWwWWWW
    wwWwwwwwW
    wWwWWwwWw
    WwWwwWwwW
    wWWwwWwWw
    wWWWwWwww
    wwwWWWwww
    WWwWWwwWw
    Wwwwwwwww
    WWWwwWwwW
    WWwWwwWwW
    WwwWWWwWW
    wwwWwWWWw
    wwwwwWwww
    WwwwWwwww
    wWwwWwWwW
    wwwWwwwWW
    wwWwwwWWw
    wWwWWWWww
    WwwWwwwWw
    wwWwWwwww

Then, if you run this B<grassy> code, you will see "HELLO".

=head1 DESCRIPTION

B<草 (kusa)> means grass in Japanese.

B<草(kusa)> is Japanese internet slang. The word B<笑(warai)> is used to describe laughing in communication. The initial letter B<w> looks like grass.
In summary, B<草(kusa)> is sometimes used to describe a laughing response.

=head1 SEE ALSO

L<Acme::W>, L<Acme::Bleach>

=head1 LICENSE

Copyright (C) kobaken.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

kobaken E<lt>kfly@cpan.orgE<gt>

=cut

