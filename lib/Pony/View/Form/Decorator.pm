package Pony::View::Form::Decorator;
use Pony::Object;
	
	# Default decorator.
	# Experimental.
	
	has form 	=> '<table class="pony-form">%s</table>';
	has element => '<tr>
						<td>%s</td>
						<td>%s
							<div class="error">%s</div>
						</td>
						<td>%s</td>
					</tr>';
	
	# "She's dead, wrapped in plastic."
	
	sub decorate
		{
			my ( $this, $formStr, @elements ) = @_;
			my $htmlCode = '';
			
			# Wrap all elements into decorators
			# and join them.
			
			for my $e ( @elements )
			{
				$htmlCode .= sprintf $this->element,
									 @$e{ qw/label value error require/ };
			}
			
			# Wrap elements into form.
			# Wrap form into from decorator.
			
			$htmlCode = sprintf $this->form, $htmlCode;
			$htmlCode = sprintf $formStr, $htmlCode;
			
			return $htmlCode;
		}
1;

__END__

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011, Georgy Bazhukov.

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut
