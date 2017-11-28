use utf8;
package Foo::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Foo::Schema::Result::User

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 firstname

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 0

=head2 lastname

  data_type: 'text'
  is_nullable: 0

=head2 phone

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "firstname",
  { data_type => "text", default_value => "", is_nullable => 0 },
  "lastname",
  { data_type => "text", is_nullable => 0 },
  "phone",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07047 @ 2017-11-28 17:26:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:u/RGhELhScq6Cc+h8DlR3w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
