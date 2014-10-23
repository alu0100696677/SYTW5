class ShortenedUrl
  include DataMapper::Resource

  property :id, Serial
  property :url, Text
<<<<<<< HEAD
=======
  property :to, Text
  property :id_usu, Text
>>>>>>> belen
end

