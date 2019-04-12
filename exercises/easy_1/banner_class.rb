class Banner
  def initialize(message, width=80)
    @message = message
    @width = width - 4
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    "+-#{('-' * @width)}-+"
  end

  def empty_line
    "| #{' ' * (@width)} |"
  end

  def message_line
    if @message.size > @width
      "| #{@message[0, @width]} |"
    else
      "| #{@message.center(@width)} |"
    end
  end
end

banner = Banner.new("To boldly go where no one has gone before.", 40)
puts banner

banner = Banner.new('')
puts banner

