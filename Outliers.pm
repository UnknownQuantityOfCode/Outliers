package Outliers;

use Math::Round qw(nearest_ceil nearest_floor nearest);

sub outliers {
	my @data = @_;
	# Arrange all data points from lowest to highest
	@data = sort(@data);
	# Calculate the median of the data set	
	my ($median, $mid_point) = _median(@data);
	# Calculate the lower quartile
	my $lower = _median(@data[0..nearest_ceil(1, $mid_point)]);
	# Calculate the upper quartile
	my $upper = _median(@data[nearest_floor(1, $mid_point)..$#data]);
	# Find the interquartile range
	my $range = $upper-$lower;
	# Find the "inner fences" for the data set
	my $inner_upper_boundary = ((1.5 * $range) + $upper);
	my $inner_lower_boundary = ((1.5 * $range) - $lower);
	# Find the "outer fences" for the data set
	my $outer_upper_boundary = ((3 * $range) + $upper);
	my $outer_lower_boundary = ((3 * $range) - $lower);
	# Find possible outliers
	my @tests;
	foreach my $d (@data){
		if($d < $inner_lower_boundary || $d > $inner_upper_boundary || $d < $outer_lower_boundary || $d > $outer_upper_boundary){
			push @tests, $d;
		}
	}
	return @tests;
}

sub _median {
	my @data = @_;
	my $mid_point = ((scalar @data) / 2);
	if($mid_point % 2 == 0){
		$median = $data[$mid_point];
	}else{
		$median = (($data[nearest_floor(1, $mid_point)] + $data[nearest_ceil(1, $mid_point)])/2);
	}
	return (wantarray) ? ($median, $mid_point) : $median;
}

sub average {
	my @data = @_;
	my $total = 0;
	$total += $_ foreach @data;
	return ($total / (scalar @data));
}

1;
