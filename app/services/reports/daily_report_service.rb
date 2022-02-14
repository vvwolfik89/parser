module Reports
  class DailyReportService
    attr_reader :date_range

    def initialize(date_range)
      @date_range = date_range
    end

    def build_data
      parts = Part.includes(:data_ratings).where(data_ratings: {created_at: date_range})
      parts.map do |part|
        part.data_ratings.map do |data_rating|
          data_rating.data.map do |data|
            OpenStruct.new(
              brand: part.brand,
              detail_num: part.detail_num,
              o_e: part.o_e,
              own_id: part.own_id,
              code: data['code'],
              name: data['name'],
              supCode: data['supCode'],
              counts: data['count'],
              sums: data['sum'],
              hours: (data['hours']/24 if data['hours'].present?),
              rating: count_rating(data),
              countOrders: data['countOrders'],
              countRefused: data['countRefused'],
              countLate: data['countLate'],
              countReturn: data['countReturn'],
              created_at: data_rating.created_at.to_date
              )
          end
        end
      end
    end


    protected

    def count_rating(data)
      if data['countOrders'].to_i != 0
        (data['countOrders'].to_i-data['countRefused'].to_i-data['countLate'].to_i/2-data['countReturn'].to_i/2)*5/data['countOrders'].to_i
      else
        0
      end
    end
  end
end