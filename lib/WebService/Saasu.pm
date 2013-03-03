package WebService::Saasu;

use 5.10.0;
use Mouse;
use XML::Simple;
with 'Web::API';

=head1 NAME

WebService::Saasu - an interface to saasu.com's RESTful accounting API using Web::API

=head1 VERSION

Version 0.2

=cut

our $VERSION = '0.2';

has 'commands' => (
    is      => 'rw',
    default => sub {
        {
            # invoices
            list_invoices => {
                path      => 'InvoiceList',
                mandatory => ['transactionType'],
            },
            get_invoice => {
                path      => 'Invoice',
                mandatory => ['id'],
            },
            create_invoice => {
                path    => 'Tasks',
                method  => 'POST',
                wrapper => [ 'tasks', 'insertInvoice', 'invoice' ],
                mandatory =>
                    [ 'transactionType', 'date', 'layout', 'invoiceItems' ],
            },
            update_invoice => {
                path      => 'Tasks',
                method    => 'POST',
                wrapper   => [ 'tasks', 'updateInvoice', 'invoice' ],
                mandatory => [
                    'id',              'lastUpdatedUid',
                    'transactionType', 'date',
                    'layout',          'invoiceItems'
                ],
            },
            delete_invoice => {
                path      => 'Invoice',
                method    => 'DELETE',
                mandatory => ['id'],
            },

            # payments
            list_payments => {
                path      => 'InvoicePaymentList',
                mandatory => ['transactionType'],
            },
            get_payment => {
                path      => 'InvoicePayment',
                mandatory => ['id'],
            },
            create_payment => {
                path   => 'Tasks',
                method => 'POST',
                wrapper =>
                    [ 'tasks', 'insertInvoicePayment', 'invoicePayment' ],
                mandatory =>
                    [ 'transactionType', 'date', 'invoicePaymentItems' ],
            },
            update_payment => {
                path   => 'Tasks',
                method => 'POST',
                wrapper =>
                    [ 'tasks', 'updateInvoicePayment', 'invoicePayment' ],
                mandatory => [
                    'id',              'lastUpdatedUid',
                    'transactionType', 'date',
                    'invoicePaymentItems'
                ],
            },
            delete_payment => {
                path      => 'InvoicePayment',
                method    => 'DELETE',
                mandatory => ['id'],
            },

            # contacts
            list_contacts => { path => 'ContactList' },
            get_contact   => {
                path      => 'Contact',
                mandatory => ['id'],
            },
            create_contact => {
                path    => 'Tasks',
                method  => 'POST',
                wrapper => [ 'tasks', 'insertContact', 'contact' ],
            },
            update_contact => {
                path    => 'Tasks',
                method  => 'POST',
                wrapper => [ 'tasks', 'updateContact', 'contact' ],
                mandatory => [ 'id', 'lastUpdatedUid' ],
            },
            delete_contact => {
                path      => 'Contact',
                method    => 'DELETE',
                mandatory => ['id'],
            },

            # chart of accounts
            list_accounts => { path => 'TransactionCategoryList' },
            get_account   => {
                path      => 'TransactionCategory',
                mandatory => ['id'],
            },
            create_account => {
                path    => 'Tasks',
                method  => 'POST',
                wrapper => [
                    'tasks', 'insertTransactionCategory',
                    'transactionCategory'
                ],
                mandatory => [ 'type', 'name' ],
            },
            update_account => {
                path    => 'Tasks',
                method  => 'POST',
                wrapper => [
                    'tasks', 'updateTransactionCategory',
                    'transactionCategory'
                ],
                mandatory => [ 'id', 'lastUpdatedUid', 'type', 'name' ],
            },
            delete_account => {
                path      => 'TransactionCategory',
                method    => 'DELETE',
                mandatory => ['id'],
            },

            # bank accounts
            list_bank_accounts => { path => 'BankAccountList' },
            get_bank_account   => {
                path      => 'BankAccount',
                mandatory => ['id'],
            },
            create_bank_account => {
                path    => 'Tasks',
                method  => 'POST',
                wrapper => [ 'tasks', 'insertBankAccount', 'bankAccount' ],
                mandatory => [ 'type', 'displayName' ],
            },
            update_bank_account => {
                path      => 'Tasks',
                method    => 'POST',
                wrapper   => [ 'tasks', 'updateBankAccount', 'bankAccount' ],
                mandatory => [ 'id', 'lastUpdatedUid', 'type', 'displayName' ],
            },
            delete_bank_account => {
                path      => 'BankAccount',
                method    => 'DELETE',
                mandatory => ['id'],
            },

            # inventory items
            list_items => { path => 'FullInventoryItemList' },
            get_item  => {
                path      => 'InventoryItem',
                mandatory => ['id'],
            },
            create_item => {
                path    => 'Tasks',
                method  => 'POST',
                wrapper => [ 'tasks', 'insertInventoryItem', 'inventoryItem' ],
                mandatory => [ 'code', 'description' ],
            },
            update_item => {
                path    => 'Tasks',
                method  => 'POST',
                wrapper => [ 'tasks', 'updateInventoryItem', 'inventoryItem' ],
                mandatory => [ 'id', 'lastUpdatedUid', 'code', 'description' ],
            },
            delete_item => {
                path      => 'InventoryItem',
                method    => 'DELETE',
                mandatory => ['id'],
            },

            # inventory adjustments
            list_adjustments => { path => 'InventoryAdjustmentList' },
            get_adjustment   => {
                path      => 'InventoryAdjustment',
                mandatory => ['id'],
            },
            create_adjustment => {
                path    => 'Tasks',
                method  => 'POST',
                wrapper => [
                    'tasks', 'insertInventoryAdjustment',
                    'inventoryAdjustment'
                ],
                mandatory => ['items'],
            },
            update_adjustment => {
                path    => 'Tasks',
                method  => 'POST',
                wrapper => [
                    'tasks', 'updateInventoryAdjustment',
                    'InventoryAdjustment'
                ],
                mandatory => [ 'id', 'lastUpdatedUid', 'items' ],
            },
            delete_adjustment => {
                path      => 'InventoryAdjustment',
                method    => 'DELETE',
                mandatory => ['id'],
            },

            # combo items
            list_comboitems => { path => 'FullComboItemList' },
            get_comboitem   => {
                path      => 'ComboItem',
                mandatory => ['id'],
            },
            create_comboitem => {
                path      => 'Tasks',
                method    => 'POST',
                wrapper   => [ 'tasks', 'insertComboItem', 'comboItem' ],
                mandatory => [ 'code', 'description', 'items' ],
            },
            update_comboitem => {
                path    => 'Tasks',
                method  => 'POST',
                wrapper => [ 'tasks', 'updateComboItem', 'comboItem' ],
                mandatory =>
                    [ 'id', 'lastUpdatedUid', 'code', 'description', 'items' ],
            },
            delete_comboitem => {
                path      => 'ComboItem',
                method    => 'DELETE',
                mandatory => ['id'],
            },

            # inventory transfers
            list_transfers => { path => 'InventoryTransferList' },
            get_transfer   => {
                path      => 'InventoryTransfer',
                mandatory => ['id'],
            },
            create_transfer => {
                path   => 'Tasks',
                method => 'POST',
                wrapper =>
                    [ 'tasks', 'insertInventoryTransfer', 'inventoryTransfer' ],
                mandatory => ['items'],
            },
            update_transfer => {
                path   => 'Tasks',
                method => 'POST',
                wrapper =>
                    [ 'tasks', 'updateInventoryTransfer', 'inventoryTransfer' ],
                mandatory => [ 'id', 'lastUpdatedUid', 'items' ],
            },
            delete_transfer => {
                path      => 'InventoryTransfer',
                method    => 'DELETE',
                mandatory => ['id'],
            },

            # journal
            list_journals => { path => 'JournalList' },
            get_journal   => {
                path      => 'Journal',
                mandatory => ['id'],
            },
            create_journal => {
                path      => 'Tasks',
                method    => 'POST',
                wrapper   => [ 'tasks', 'insertJournal', 'journal' ],
                mandatory => ['journalItems'],
            },
            update_journal => {
                path      => 'Tasks',
                method    => 'POST',
                wrapper   => [ 'tasks', 'updateJournal', 'journal' ],
                mandatory => [ 'id', 'lastUpdatedUid', 'journalItems' ],
            },
            delete_journal => {
                path      => 'Journal',
                method    => 'DELETE',
                mandatory => ['id'],
            },

            # tax codes
            list_tax_codes => { path => 'TaxCodeList' },

            # tags
            list_tags => { path => 'TagList' },

            list_deleted => { path => 'DeletedEntityList' }, };
    },
);

=head1 SYNOPSIS

Please refer to the API documentation at L<http://mandrillapp.com/api/docs/index.html>

    use WebService::Saasu;

    my $foo = WebService::Saasu->new();
    ...

=head1 SUBROUTINES/METHODS

=cut

sub commands {
    my ($self) = @_;
    return $self->commands;
}

=head2 BUILD

basic configuration for the client API happens usually in the BUILD method when using Web::API

=cut

sub BUILD {
    my ($self) = @_;

    $self->user_agent(__PACKAGE__ . ' ' . $VERSION);
    $self->content_type('application/xml');
    $self->base_url('https://secure.saasu.com/webservices/rest/r1');
    $self->auth_type('get_params');
    $self->mapping({
            user    => 'FileUid',
            api_key => 'wsaccesskey',
            id      => 'uid',
    });
    $self->xml(
        XML::Simple->new(
            ContentKey => '-content',
            NoAttr     => 1,
            KeepRoot   => 1,
            KeyAttr    => ['layout'],
        ),
    );

    return $self;
}

=head1 AUTHOR

Tobias Kirschstein, C<< <lev at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-webservice-saasu at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WebService-Saasu>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WebService::Saasu


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WebService-Saasu>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WebService-Saasu>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WebService-Saasu>

=item * Search CPAN

L<http://search.cpan.org/dist/WebService-Saasu/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2013 Tobias Kirschstein.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1;    # End of WebService::Saasu
