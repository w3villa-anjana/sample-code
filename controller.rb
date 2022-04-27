module Stats
  class BaseUserAttributesController < AdminController
    def index
      @attributes = BaseUserAttribute.order("name").page(params[:page]).per(params[:size] || 10)

      @attributes_with_counts = @attributes.reduce(Hash.new) do |h, attr|
        counts = UserAttribute.where(name: attr.name).group("value").count

        value_hash = attr.possible_values.reduce(Hash.new) do |h2, value|
          h2.merge({ value => counts.fetch(value, 0) })
        end

        h.merge({ attr => value_hash })
      end
    end

    def show_users
      @base_user_attribute = UserAttribute.where(["name = ? and value = ?", params[:name], params[:value]])
      @value_name = params[:value]
    end

    def new
      @base_user_attribute = BaseUserAttribute.new
      @values = Array.new
    end

    def edit
      @base_user_attribute = BaseUserAttribute.find(params[:id])
      @values = BaseUserAttribute.find(@base_user_attribute).possible_values
    end

    def create
      possible_values = array_from_values

      @new_base_user_attribute = BaseUserAttribute.new(name: params[:name], possible_values: possible_values)

      if @new_base_user_attribute.save
        redirect_to stats_base_user_attributes_path, notice: "Successfully saved new Base User Attribute"
      else
        redirect_to stats_base_user_attributes_path, alert: "Couldn't save new Base User Attribute"
      end
    end

    def update
      @base_user_attribute = BaseUserAttribute.find(params[:id])

      possible_values = array_from_values

      if @base_user_attribute.update!(possible_values: possible_values)
        redirect_to stats_base_user_attributes_path, notice: "Successfully updated Base User Attribute"
      else
        redirect_to stats_base_user_attributes_path, alert: "Couldn't update Base User Attribute"
      end
    end

    def destroy
      BaseUserAttribute.find(params[:id]).destroy!
      redirect_to stats_base_user_attributes_path, notice: "Successfully deleted Base User Attribute"
    end

    def array_from_values
      params[:values].select { |val| val[:value].present? }.map{ |val| val[:value] }
    end
    private :array_from_values

  end
end
