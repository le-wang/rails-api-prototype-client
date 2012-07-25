class Post < Base
  validates_presence_of :title, :content

  def save(attributes)
    begin
      Connection.post("/posts.json", attributes)
    rescue RestClient::UnprocessableEntity => e
      Oj.load(e.http_body).each do |key, values|
        values.each do |value|
          errors.add(key, value)
        end
      end
      false
    end
  end

  def update_attributes(attributes)
    @attributes.merge!(attributes[:post])
    begin
      Connection.put("/posts/#{attributes[:id]}.json", attributes)
    rescue RestClient::UnprocessableEntity => e
      Oj.load(e.http_body).each do |key, values|
        values.each do |value|
          errors.add(key, value)
        end
      end
      false
    end
  end

  def destroy(attributes)
    Connection.delete("/posts/#{attributes[:id]}.json")
  end
end
