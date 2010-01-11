#line 1
package Class::Data::Inheritable;

use strict qw(vars subs);
use vars qw($VERSION);
$VERSION = '0.08';

sub mk_classdata {
    my ($declaredclass, $attribute, $data) = @_;

    if( ref $declaredclass ) {
        require Carp;
        Carp::croak("mk_classdata() is a class method, not an object method");
    }

    my $accessor = sub {
        my $wantclass = ref($_[0]) || $_[0];

        return $wantclass->mk_classdata($attribute)->(@_)
          if @_>1 && $wantclass ne $declaredclass;

        $data = $_[1] if @_>1;
        return $data;
    };

    my $alias = "_${attribute}_accessor";
    *{$declaredclass.'::'.$attribute} = $accessor;
    *{$declaredclass.'::'.$alias}     = $accessor;
}

1;

__END__

