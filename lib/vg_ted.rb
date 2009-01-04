# ----------------------------------------------
#  Class for Ted Talks (www.ted.com/talks)
#  http://www.ted.com/index.php/talks/benjamin_wallace_on_the_price_of_happiness.html
# ----------------------------------------------


class VgTed
  
  def initialize(url=nil, options={})
    @url = url
    raise unless URI::parse(url).path.split("/").include? "talks"
    @page = Hpricot(open(url))
    emb = @page.search("//input[@id='embedCode']").first.attributes['value']
    tx = Hpricot(emb)
    @flashvars = tx.search('//embed').first.attributes['flashvars'].to_s
    @args = get_hash(@flashvars)
  end
  
  def title
    @page.search("//h1/span").first.inner_html.strip
  end
  
  def thumbnail
    @args['su']
  end
  
  def embed_url
      "http://video.ted.com/assets/player/swf/EmbedPlayer.swf?#{@flashvars}"
  end

  def embed_html(width=425, height=344, options={})
    "<object width='#{width}' height='#{height}'><param name='movie' value='#{embed_url}'></param><param name='allowFullScreen' value='true' /><param name='wmode' value='transparent'></param><param name='bgColor' value='#ffffff'></param><embed src='#{embed_url}' pluginspace='http://www.macromedia.com/go/getflashplayer' type='application/x-shockwave-flash' wmode='transparent' bgColor='#ffffff'  width='#{width}' height='#{height}' allowFullScreen='true'></embed></object>"
  end
  
  def flv
    @args['vu']
  end
  
  protected
  
  def get_hash(string)
    hash = Hash.new
    string.split("&").each do |elemement|
      pieces = elemement.split("=")
      hash[pieces[0]] = pieces[1]
    end
    hash.delete_if { |key, value| value.nil? }
  end

end