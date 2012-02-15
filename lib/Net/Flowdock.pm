package Net::Flowdock;
use Moose;

# ABSTRACT: Flowdock API

use Net::HTTP::Spore;

=head1 DESCRIPTION

Net::Flowdock is a simple client for using the L<Flowdock API|https://www.flowdock.com/help/api_documentation>.

=head1 SYNOPSIS

    use Net::Flowdock;

    my $client = Net::Flowdock->new(key => 'find-your-own');

    $client->push_team_inbox({
        source => 'CPAN',
        from_address => 'gphat@cpan.org',
        from_name => 'Cory Watson',
        subject => 'Uploaded Net::Flowdock',
        content => "Sho' nuff",
        project => 'Open Source',
        tags => 'wow,yeah,poop',
        link => 'http://search.cpan.org'
    });

=cut

has '_client' => (
    is => 'rw',
    lazy => 1,
    default => sub {
        my $self = shift;
        
        my $client = Net::HTTP::Spore->new_from_string(
            '{
                "name": "Flowdock",
                "authority": "GITHUB:gphat",
                "version": "1.0",
                "methods": {
                    "push_team_inbox": {
                        "path": "/v2/messages/team_inbox/:key",
                        "required_params": [
                            "source", "from_address", "subject", "content"
                        ],
                        "optional_params": [
                            "from_name", "project", "format", "tags", "link"
                        ],
                        "method": "POST"
                    },
                    "push_chat": {
                        "path": "/v2/messages/chat/:key",
                        "required_params": [
                            "content", "external_user_name"
                        ],
                        "optional_params": [
                            "tags"
                        ],
                        "method": "POST"
                    }
                }
            }',
            base_url => $self->url,
            trace => $self->debug
        );
        return $client
    }
);

=attr debug

Set/Get the debug flag.

=cut

has 'debug' => (
    is => 'rw',
    isa => 'Bool',
    default => 0,
);

=attr key

Set/Get the key to use when connecting to Flowdock.

To obtain the API Token go to Settings -> Team Inbox inside a flow. 

=cut

has 'key' => (
    is => 'rw',
    isa => 'Str',
    required => 1
);

=attr password

Set/Get the password for authenticated request.

=cut

has 'password' => (
    is => 'rw',
    isa => 'Str'
);

=attr url

Set/Get the URL for Flowdock. Defaults to https://api.flowdock.com.

=cut

has 'url' => (
    is => 'rw',
    isa => 'Str',
    default => 'https://api.flowdock.com'
);

=attr username

Set/Get the username for authenticated request.

=cut

has 'username' => (
    is => 'rw',
    isa => 'Str'
);

=method push_team_inbox ({ source => $source, from_address => $email })

Required fields:

=over 4

=item source

Human readable identifier of the application that uses the Flowdock API. Only alphanumeric characters, underscores and whitespace can be used. This identifier will be used as the primary method of categorization for the messages. 

Example value: Awesome Issue Management App

=item from_address

Email address of the message sender. The email address is used to show a avatar of the sender. You can customize the avatar by registering the address in

Example value: john.doe@yourdomain.com

=item subject

Subject line of the message, will be displayed as the title of Team Inbox message.

=item content

Content of the message, will be displayed as the body of Team Inbox message. 

Following HTML tags can be used: a abbr acronym address article aside b big blockquote br caption cite code dd del details dfn div dl dt em figcaption figure footer h1 h2 h3 h4 h5 h6 header hgroup hr i img ins kbd li nav ol p pre samp section small span strong sub summary sup table tbody td tfoot th thead tr tt ul var wb

=back

Optional fields:

=over 4

=item from_name

Name of the message sender.

Example value: John Doe

=item project

Human readable identifier for more detailed message categorization. Only alphanumeric characters, underscores and whitespace can be used. This identifier will be used as the secondary method of categorization for the messages.

Example value: My Project

=item format

Format of the message content, default value is "html". Only HTML is currently supported. 

Example value: html

=item tags

Tags of the message, separated by commas.

Example value: cool,stuff

=item link

Link associated with the message. This will be used to link the message subject in Team Inbox.

Example value: http://www.flowdock.com/

=back

=cut

sub push_team_inbox {
    my $self = shift;
    my $args = shift;
    
    return $self->_client->push_team_inbox(
        key => $self->key,
        source => $args->{source},
        from_address => $args->{from_address},
        from_name => $args->{from_name},
        subject => $args->{subject},
        content => $args->{content},
        project => $args->{project},
        format => $args->{format},
        tags => $args->{tags},
        link => $args->{link}
    );
}

=method push_chat ({ content => $content, external_user_name => $username })

=over 4

=item content

Content of the message. Tags will be automatically parsed from the message content. Required.

=item external_user_name

Name of the "user" sending the message. Required.

=item tags

Tags of the message, separated by commas. Optional.

Example value: cool,stuff

=back

=cut

sub push_chat {
    my $self = shift;
    my $args = shift;

    return $self->_client->push_chat(
        key => $self->key,
        content => $args->{content},
        external_user_name => $args->{external_user_name},
        tags => $args->{tags}
    );
}

1;
