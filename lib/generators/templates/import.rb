ActiveAdmin.register Import do
  permit_params :asset, :delimiter, :name_of_model

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

  form multipart: true do |f|
    if params[:id].blank?
      f.inputs 'Details' do
        f.input :asset, as: :file, input_html: {required: true}
        f.input :name_of_model, as: :select2, collection: ActiveRecord::Base.connection.tables.collect {|c| [c.capitalize.camelize]}, input_html: {required: true}
      end

      f.submit 'Next >>'
    elsif !params[:id].blank? && params[:delimiter].blank?
      f.input :id, as: :hidden, input_html: {value: params[:id]}

      f.inputs 'Delimited' do
        f.input :delimiter, as: :select2, collection: %w[semicolon comma tab space], input_html: {required: true}
      end
      inputs 'Data samples' do
        textarea rows: 10, style: 'margin: auto 5em;' do
          params[:data].gsub(/\r?\n/, "\n")
        end
      end

      span do
        button('<< Back', action: 'new')
        f.submit 'Next >>'
      end
    elsif !params[:id].blank? && !params[:delimiter].blank?
      f.input :id, as: :hidden, input_html: {value: params[:id]}
    end
  end


  controller do

    def index
      redirect_to action: 'new' and return
    end

    def view
      redirect_to action: 'new' and return
    end
    def new
      if !params[:id].blank?
        import = Import.find(params[:id])
        data = ''
        i = 0
        Paperclip.io_adapters.for(import.asset).read.each_line do |line|
          data += line
          i += 1
          break if i == 5
        end
        params[:data] = data
      end
      super
    end

    def create
      if !params[:import][:id].blank?
        import = Import.find(params[:import][:id])
        import.update_attributes!(delimiter: params[:import][:delimiter])
        redirect_to action: 'assign_fields', id: import.id, delimiter: import.delimiter and return
      end
      super do |format|
        if @import.valid?
          @import.save!
          redirect_to action: 'new', id: @import.id and return
        end
      end
    end

    def assign_fields
      return if params[:id].blank?() || !%w[semicolon comma tab space].include?(params[:delimiter])
      delimiter = ';'
      case params[:delimiter]
        when 'semicolon' then delimiter = ';'
        when 'comma'     then delimiter = ','
        when 'tab'       then delimiter = "\t"
        when 'space'     then delimiter = ' '
      end
      @import = Import.find(params[:id])
      Paperclip.io_adapters.for(@import.asset).read.each_line do |line|
        @fields = line.split(delimiter).map {|c| c.gsub(/\r?\n/, '')} and break
      end
      @fields_model = @import.name_of_model.classify.constantize.column_names
    end

    def file_report
      import = Import.find(params[:id])
      delimiter = ';'
      case import.delimiter
        when 'semicolon' then delimiter = ';'
        when 'comma'     then delimiter = ','
        when 'tab'       then delimiter = "\t"
        when 'space'     then delimiter = ' '
      end
      i = 0
      @report = ''
      Paperclip.io_adapters.for(import.asset).read.each_line do |line|
        line = line.split(delimiter).map {|c| c.gsub(/\r?\n/, '')}
        i += 1
        next if i == 1
        new_elem = import.name_of_model.classify.constantize.new
        params[:assign_fields].each do |key, value|
          new_elem.send(value.to_s+'=', line[key.gsub('_', '').to_i])
        end
        if new_elem.valid?
          new_elem.save!
          @report += 'Succesfully add element from line '+i.to_s+'<br/>'
        else
          @report += 'Invalid fields on line '+i.to_s+'<br/>'
        end
      end
    end

  end

end
