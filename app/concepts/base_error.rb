class BaseError < StandardError
  def initialize(msg, **args)
    super(
      { msg: msg }.merge(args).inspect
    )
  end
end
