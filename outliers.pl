use Math::Round qw(nearest_ceil nearest_floor nearest);

my @dataset = (7670.799999963492,7922.000000020489,6914.8999999742955,7931.300000054762,7654.8000001348555,6923.900000052527,6897.499999962747,6974.00000016205,6907.100000185892,6890.7999999355525,7023.899999912828,6971.0999999661,6984.700000146404,6948.899999959394,6949.299999978393,6989.399999845773,6974.200000055134,6998.299999861047,7006.899999920279,6955.100000137463,7100.099999923259,6959.199999924749,7013.399999821559,6988.099999958649,6993.100000079721,7015.200000023469,6991.600000066683,7021.7999999877065,7025.900000007823,7050.700000021607,7138.500000117347,6988.499999977648,7021.7999999877065,7002.600000007078,6982.199999969453,7092.50000002794,7081.900000106543,7195.500000147149,7005.7000000961125,7005.299999844283,7064.899999881163,7040.7000000122935,7043.400000082329,7007.100000046194,7098.699999973178,7040.199999930337,7017.400000011548,7021.7999999877065,7007.400000002235,6982.000000076368,7040.7000000122935,7123.000000137836,7032.200000016019,7006.300000008196,6990.299999946728,7057.500000111759,7014.399999985471,7040.900000138208,7023.899999912828,7008.399999933317,7055.900000035763,7015.600000042468,7023.100000107661,7006.799999857321,6990.999999921769,7165.599999949336,7140.3999999165535,7040.000000037253,7015.89999999851,7005.3000000771135,7042.000000132248,7015.7999999355525,7166.600000113249,7023.100000107661,6989.800000097603,7049.200000008568,7048.300000140443,7106.900000013411,7088.5000000707805,7017.499999841675,7141.200000187382,7174.099999945611,7048.799999989569,7030.899999896064,6998.600000049919,7055.799999972805,7039.700000081211,7174.600000027567,7031.300000147894,7016.399999847636,7048.200000077486,7007.499999832362,7048.699999926612,7023.4000000637025,7007.60000012815,7302.399999927729,7019.899999955669,7049.400000134483,7049.400000134483,7014.10000002943);

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

my @outliers = outliers(@dataset);
print "Outlier: $_\n" foreach @outliers;
print "Average: ".average(@dataset)."\n\n";

foreach $o (@outliers) {
	my ($index) = grep { $_ eq $o } (0 .. $#dataset);
	splice @dataset, $index, 1;
}

@outliers = outliers(@outliers);
print join(',', sort @dataset)."\n";
print "Outlier: $_\n" foreach @outliers;
print "Average: ".average(@dataset)."\n";