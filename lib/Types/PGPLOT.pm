package Types::PGPLOT;

# ABSTRACT: Type::Tiny compatible types for the PGPLOT library

use strict;
use warnings;
use Readonly::Tiny;

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
  XAxisOptions
  YAxisOptions
];

use Types::Common::Numeric qw[ IntRange NumRange PositiveNum ];
use Types::Standard qw[ Str Dict ];
use Type::Utils -all;


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
coerce Color, from Str, via { $Map_Color{ lc $_ } // $_ };



=type FillAreaStyle

An integer in [1,4].

Coercions are provided for Str types with one of the following values:

  solid outline hatched cross-hatched

=cut

our %Map_FillAreaStyle = (
    solid           => 1,
    outline         => 2,
    hatched         => 3,
    'cross-hatched' => 4,
);

readonly \%Map_FillAreaStyle;

declare FillAreaStyle, as IntRange [ 1, 4 ];
coerce FillAreaStyle, from Str, via { $Map_FillAreaStyle{ lc $_ } // $_ };


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
coerce Font, from Str, via { $Map_Font{ lc $_ } // $_ };


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
coerce LineStyle, from Str, via { $Map_LineStyle{ lc $_ } // $_ };


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
coerce PlotUnits, from Str, via { $Map_PlotUnits{ lc $_ } // $_ };



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

 ArrowHeadFilltyle
 CharacterHeight
 FillAreaStyle
 LineStyle
 LineWidth
 PlotUnits
 XAxisOptions
 YAxisOptions

=end stopwords


=head1 SYNOPSIS


=head1 SEE ALSO
