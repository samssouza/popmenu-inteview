class RestaurantImportService
  def initialize(json_data)
    @json_data = json_data
    @result = { success: true, logs: [] }
    @import_job = nil
  end

  def call
    create_import_job
      parse_json
      return complete_import_job if @parsed_json.nil?

    @parsed_json['restaurants'].each do |restaurant_data|
      import_restaurant(restaurant_data)
    end

    complete_import_job

  end

  private

  def create_import_job
    @import_job = ImportJob.create!(
      start_time: Time.current,
      status: :started,
      raw_json: @json_data
    )
  end

  def complete_import_job
    @import_job.update!(
      end_time: Time.current,
      status: @result[:success] ? :completed : :failed
    )
    @import_job
  end

  def fail_import_job(error_message)
    @import_job.update!(
      end_time: Time.current,
      status: :error
    )
    create_import_log('import_job', 'Overall Import', :fail, error_message)
    @import_job
  end

  def parse_json
    @parsed_json = JSON.parse(@json_data)
  rescue JSON::ParserError => e
    @result[:success] = false
    create_import_log('json', 'JSON Parsing', :fail, "Invalid JSON: #{e.message}")
    @parsed_json = nil
  end

  def import_restaurant(restaurant_data)
    restaurant = Restaurant.find_or_create_by(name: restaurant_data['name'])
    if restaurant.persisted?
      create_import_log('restaurant', restaurant.name, :success, 'Restaurant created successfully')
      restaurant_data['menus'].each do |menu_data|
        import_menu(restaurant, menu_data)
      end
    else
      @result[:success] = false
      create_import_log('restaurant', restaurant_data['name'], :fail, restaurant.errors.full_messages.join(', '))
    end
  end

  def import_menu(restaurant, menu_data)
     menu = restaurant.menus.find_or_create_by(name: menu_data['name'], restaurant: restaurant)
    if menu.persisted?
      create_import_log('menu', menu.name, :success, 'Menu created successfully')
      menu_data['menu_items'].each do |item_data|
        import_menu_item(menu, item_data)
      end
    else
      @result[:success] = false
      create_import_log('menu', menu_data['name'], :fail, menu.errors.full_messages.join(', '))
    end
  end

  def import_menu_item(menu, item_data)

    item = Item.find_or_create_by(name: item_data['name'])
    if item.persisted?
      create_import_log('item', item.name, :success, 'Item created successfully')
      menu_item = menu.menus_items.find_or_create_by(item: item)
      menu_item.assign_attributes(price: item_data['price'])
      if menu_item.save
        create_import_log('menu_item', item.name, :success, 'Menu item created successfully')
      else
        @result[:success] = false
        create_import_log('menu_item', item.name, :fail, menu_item.errors.full_messages.join(', '))
      end
    else
      @result[:success] = false
      create_import_log('item', item_data['name'], :fail, item.errors.full_messages.join(', '))
    end
  end

  def create_import_log(entity, name, status, message)
    @import_job.import_logs.create!(
      entity: entity,
      name: name,
      status: status,
      message: message
    )
    @result[:logs] << { entity: entity, name: name, status: status, message: message }
  end
end