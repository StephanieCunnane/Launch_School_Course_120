# As originally written, this code raises an ArgumentError because the comparison of 2 Length objects fails inside our call to Array#sort. The comparison fails because we haven't defined Length#<=>, which is what Array#sort relies on to carry out comparisons in order to sort elements. Once we define Length#<=>, then sort knows how to do its job.

# Additionally, if we just include Comparable, we will get access to several comparison methods -> we can delete all of our custom comparison methods except for #<=>.


class Length
  include Comparable

  attr_reader :value, :unit

  def initialize(value, unit)
    @value = value
    @unit = unit
  end

  def as_kilometers
    convert_to(:km, { km: 1, mi: 1.609344, nmi: 1.8519993 })
  end

  def as_miles
    convert_to(:mi, { km: 0.62137119, mi: 1, nmi: 0.8689762419 })
  end

  def as_nautical_miles
    convert_to(:nmi, { km: 0.539957, mi: 1.15078, nmi: 1 })
  end

  def <=>(other)
    case unit
    when :km  then value <=> other.as_kilometers.value
    when :mi  then value <=> other.as_miles.value
    when :nmi then value <=> other.as_nautical_miles.value
    end
  end

  def to_s
    "#{value} #{unit}"
  end

  private

  def convert_to(target_unit, conversion_factors)
    Length.new((value * conversion_factors[unit]).round(4), target_unit)
  end
end

puts [Length.new(1, :mi), Length.new(1, :nmi), Length.new(1, :km)].sort
len1 = Length.new(1, :mi)
len2 = Length.new(2, :mi)
