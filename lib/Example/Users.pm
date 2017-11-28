package Example::User;

use Dancer2 appname => 'Example';
use Validate::Tiny ':all';
use Dancer2::Plugin::DBIC;

set serializer => 'JSON';
my $rs = 'User';

my $validate_rules = {
    fields => [qw/id lastname firstname phone/],
    filters => [
        qr/.+/ => filter(qw/trim strip/),
    ],
    checks => [
        [qw/lastname phone/] => is_required(),
        phone => sub {
            my ( $value, $params ) = @_;
            return if $value =~ m/^\+(\d+)/;
            return 'Invalid phone';
        },
    ]
};


#####################################
########## Start routes #############

# GET /
get '/' => sub {

    return [rset($rs)->search(undef,{result_class => 'DBIx::Class::ResultClass::HashRefInflator'})->all];
};

# GET /view/{id} or /view/?id={id}
get '/view/:rec?' => sub {

    my $id = route_parameters->get('rec') || param('id');
    my $record = rset($rs)->find({id => $id}) or send_error("Record not found", 404);
    return {$record->get_columns()};
};


# GET or POST /update/{id}?lastname=&firstname=  or /update/?id=lastname=&firstname=&phone=
any ['get', 'post'] => '/update/:rec?' => sub {

    forward '/add' => {id => route_parameters->get('rec'), params};
};

# GET or POST /add?lastname=&firstname=&phone=
any ['get', 'post'] => '/add' => sub {

    my $params = {};
    foreach (keys %{rset($rs)->new({})->columns_info()} ) {
        $params->{$_} ||= param($_) if defined param($_);
    }

    my $validate_result = eval { validate( $params, $validate_rules ) };
    if ( $validate_result->{success} ) {
        $params = $validate_result->{data};
    } 
    else {
        send_error( join(', ', values %{$validate_result->{error}}), 400);
        return;
    }

    my $record = rset($rs)->update_or_create($params);
    return {result => 'success', $record->get_columns()};
};

# GET or POST /remove/{id} or /delete/?id=
any ['get', 'post'] => '/remove/:rec?' => sub {

    my $id = route_parameters->get('rec') || param('id');
    my $record = rset($rs)->find({id  => $id}) or send_error("Record not found", 404);
    $record->delete();
    return {result => 'success', 'id' => $id };
};


dance;