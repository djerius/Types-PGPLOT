package Types::PGPLOT;

# ABSTRACT: Type::Tiny compatible types for the PGPLOT library

use strict;
use warnings;

our $VERSION = '0.01';

use Type::Library
  -base,
  -declare => qw[
  Angle
  ArrowHeadFillStyle
  CharacterHeight
  Color
  FillAreaStyle
  Font
  LineStyle
  LineWidth
  PlotUnits
  Symbol
  XAxisOptions
  YAxisOptions
];

use Types::Common::Numeric qw[ IntRange NumRange PositiveNum ];
use Types::Standard qw[ Str Dict ScalarRef ];
use Type::Utils -all;

# Package scoped hashes are made readonly so that we can allow their
# use outside of this module (e.g. for testing). Note however, that
# the common usage of $Map{$key} // $key will throw an exception if $Map{$key}
# does not exist.  Therefore, in code using the restricted hashes,
# always for check for existence before retrieving values.

use Readonly::Tiny;

=type Angle

A real number in [-360,360].

=cut

declare Angle, as NumRange [ -360, 360 ];


=type ArrowHeadFillStyle

An integer in [1,2].

Coercions are provided for Str types with one of the following values:

  filled solid outline

=cut

our %Map_AHFS = (
    solid   => 1,
    filled  => 1,
    outline => 2,
);

declare ArrowHeadFillStyle, as IntRange [ 1, 2 ];
coerce ArrowHeadFillStyle, from Str, via {
    $Map_AHFS{ lc $_ } // $_
};

readonly \%Map_AHFS;

=type CharacterHeight

A positive real number.

=cut

declare CharacterHeight, as PositiveNum;


=type Color

An integer in [0,255].

Coercions are provided for Str types with one of the following values:

    background foreground
    black      magenta         blue-magenta
    white      yellow          red-magenta
    red        orange          dark-gray
    green      green-yellow    light-gray
    blue       green-cyan      darkgray
    cyan       blue-cyan       lightgray

=cut

our %Map_Color = (
    background     => 0,
    black          => 0,
    foreground     => 1,
    white          => 1,
    red            => 2,
    green          => 3,
    blue           => 4,
    cyan           => 5,
    magenta        => 6,
    yellow         => 7,
    orange         => 8,
    'green-yellow' => 9,
    'green-cyan'   => 10,
    'blue-cyan'    => 11,
    'blue-magenta' => 12,
    'red-magenta'  => 13,
    'dark-gray'    => 14,
    'light-gray'   => 15,
    darkgray       => 14,
    lightgray      => 15,
);

readonly \%Map_Color;

declare Color, as IntRange [ 0, 255 ];

coerce Color, from Str,
  via { exists $Map_Color{ lc $_ } ? $Map_Color{ lc $_ } : $_ };



=type FillAreaStyle

An integer in [1,4].

Coercions are provided for Str types with one of the following values:

  solid filled outline hatched cross-hatched

=cut

our %Map_FillAreaStyle = (
    solid           => 1,
    filled          => 1,
    outline         => 2,
    hatched         => 3,
    'cross-hatched' => 4,
);

readonly \%Map_FillAreaStyle;

declare FillAreaStyle, as IntRange [ 1, 4 ];
coerce FillAreaStyle, from Str,
  via { exists $Map_FillAreaStyle{ lc $_ } ? $Map_FillAreaStyle{ lc $_ } : $_ };


=type Font

An integer in [1,4].

Coercions are provided for Str types with one of the following values:

  normal roman italic script

=cut

our %Map_Font = (
    normal => 1,
    roman  => 2,
    italic => 3,
    script => 4,
);

readonly \%Map_Font;

declare Font, as IntRange [ 1, 4 ];
coerce Font, from Str,
  via { exists $Map_Font{ lc $_ } ? $Map_Font{ lc $_ } : $_ };


=type LineStyle

An integer in [1,5].

Coercions are provided for Str types with one of the following values:

  full dashed dot-dash-dot-dash dotted dash-dot-dot-dot

=cut

our %Map_LineStyle = (
    full                => 1,
    dashed              => 2,
    'dot-dash-dot-dash' => 3,
    dotted              => 4,
    'dash-dot-dot-dot'  => 5,
);

readonly \%Map_LineStyle;

declare LineStyle, as IntRange [ 1, 5 ];
coerce LineStyle, from Str,
  via { exists $Map_LineStyle{ lc $_ } ? $Map_LineStyle{ lc $_ } : $_ };


=type LineWidth

An integer in [1,201].

=cut

declare LineWidth, as IntRange [ 1, 201 ];



=type PlotUnits

An integer in [0,4].

Coercions are provided for Str types with one of the following values:

  ndc normalized-device-coordinates
  in inches
  mm millimeters
  pixels
  wc world-coordinates

=cut


our %Map_PlotUnits = (
    'normalized-device-coordinates' => 0,
    ndc                             => 0,
    inches                          => 1,
    in                              => 1,
    millimeters                     => 2,
    mm                              => 2,
    pixels                          => 3,
    'world-coordinates'             => 4,
    wc                              => 4,
);

readonly \%Map_PlotUnits;

declare PlotUnits, as IntRange [ 0, 4 ];
coerce PlotUnits, from Str,
  via { exists $Map_PlotUnits{ lc $_ } ? $Map_PlotUnits{ lc $_ } : $_ };


=type Symbol

An integer in [-31,255]

Coercions are provided for string or references to strings with one of
the following values:

    doicosagon              dodecagon               triangle
    henicosagon             hendecagon              dot0
    icosagon                decagon                 dot1
    enneadecagon            nonagon                 opensquare
    octadecagon             enneagon                dot
    heptadecagon            octagon                 plus
    hexadecagon             heptagon                asterisk
    pentaadecagon           hexagon                 opencircle
    tetradecagon            pentagon                cross
    tridecagon              diamond                 x
    opensquare1             stardavid               opencirc4
    opentriangle            square                  opencirc5
    earth                   circle                  opencirc6
    sun                     star                    opencirc7
    curvesquare             bigosquare              backarrow
    opendiamond             opencirc0               fwdarrow
    openstar                opencirc1               uparrow
    triangle1               opencirc2               downarrow
    openplus                opencirc3

as well as characters with unicode/ascii codes in [32, 127].

Because Perl well treat digits stored as strings as numbers rather than
strings, the characters C<0>, C<1>, C<2>, C<3>, C<4>, C<5>, C<6>, C<7>, C<8>, C<9>
will get treated as integers, not characters, so the resultant symbols
will not be the expected characters.  To ensure that a character is
treated as a character, pass a reference to it.  This will bypass the
automatic conversion to integer.

=cut

our %Map_SymbolName = (
    doicosagon    => -22,
    henicosagon   => -21,
    icosagon      => -20,
    enneadecagon  => -19,
    octadecagon   => -18,
    heptadecagon  => -17,
    hexadecagon   => -16,
    pentaadecagon => -15,
    tetradecagon  => -14,
    tridecagon    => -13,
    dodecagon     => -12,
    hendecagon    => -11,
    decagon       => -10,
    nonagon       => -9,
    enneagon      => -9,
    octagon       => -8,
    heptagon      => -7,
    hexagon       => -6,
    pentagon      => -5,
    diamond       => -4,
    triangle      => -3,
    dot0          => -2,
    dot1          => -1,
    opensquare    => 0,
    dot           => 1,
    plus          => 2,
    asterisk      => 3,
    opencircle    => 4,
    cross         => 5,
    opensquare1   => 6,
    opentriangle  => 7,
    earth         => 8,
    sun           => 9,
    curvesquare   => 10,
    opendiamond   => 11,
    openstar      => 12,
    triangle1     => 13,
    openplus      => 14,
    stardavid     => 15,
    square        => 16,
    circle        => 17,
    star          => 18,
    bigosquare    => 19,
    opencirc0     => 20,
    opencirc1     => 21,
    opencirc2     => 22,
    opencirc3     => 23,
    opencirc4     => 24,
    opencirc5     => 25,
    opencirc6     => 26,
    opencirc7     => 27,
    backarrow     => 28,
    fwdarrow      => 29,
    uparrow       => 30,
    downarrow     => 31
);

readonly \%Map_SymbolName;

declare Symbol, as IntRange [ -31, 255 ];

coerce Symbol, from ScalarRef, via {
    return $_ unless 'SCALAR' eq ref $_;
    my $str = "$$_";

    my $name = lc $str;
    return $Map_SymbolName{ $name } if exists $Map_SymbolName{ $name };

    my $ord = ord( $str );
    return $ord > 31 && $ord < 128 ? $ord : $_;

};

coerce Symbol, from Str, via {

    my $name = lc $_;
    return $Map_SymbolName{ $name } if exists $Map_SymbolName{ $name };

    my $ord = ord( $_ );

    return $ord > 31 && $ord < 128 ? $ord : $_;
};


=type XAxisOptions

A string containing any of the characters in C<< ABCGILNPMTS12 >>, where no character repeats.

=cut

declare XAxisOptions, as Str, where {
    $_ =~ /^(?:
                ( [ABCGILNPMTS12] )
                 (?!.*\g{-1})
             )+$
            /x;
};

=type YAxisOptions

A string containing any of the characters in C<< ABCGILNPMTSV12 >>, where no character repeats.

=cut

declare YAxisOptions, as Str, where {
    $_ =~ /^(?:
                ( [ABCGILNPMTSV12] )
                 (?!.*\g{-1})
             )+$
            /x;
};

1;

# COPYRIGHT

__END__

=begin stopwords

 ArrowHeadFillStyle
 CharacterHeight
 FillAreaStyle
 LineStyle
 LineWidth
 PlotUnits
 XAxisOptions
 YAxisOptions
 Str

=end stopwords


=head1 SYNOPSIS


=head1 SEE ALSO
