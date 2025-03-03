class ApplicationService
  private_class_method :new

  def self.call(...)
    instance = nil

    outcome = ActiveRecord::Base.transaction do
      instance = new(...)

      instance.validate!

      instance.call
    end

    instance.send(:after)
    outcome
  end

  def validate!; end
  def after; end
end