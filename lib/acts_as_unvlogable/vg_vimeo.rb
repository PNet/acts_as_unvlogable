# -*- encoding : utf-8 -*-
# ----------------------------------------------
# Class for Vimeo (vimeo.com)
# http://vimeo.com/5362441
# ----------------------------------------------


class VgVimeo

  def initialize(url=nil, options={})
    # general settings
    @url = url
    @video_id = parse_url(url)
    res = Net::HTTP.get(URI.parse("http://vimeo.com/api/v2/video/#{@video_id}.json"))
    @feed = JSON.parse(res)
  end

  def video_id
    @video_id
  end

  def title
    @feed[0]["title"]
  end

  def description
    @feed[0]["description"]
  end

  def thumbnail
    @feed[0]['thumbnail_large']
  end

  def duration
    @feed[0]["duration"]
  end

  def embed_url
    "http://vimeo.com/moogaloop.swf?clip_id=#{@video_id}&server=vimeo.com&fullscreen=1&show_title=1&show_byline=1&show_portrait=1"
  end

  def embed_html(width=425, height=344, options={})
    "<object width='#{width}' height='#{height}'><param name='movie' value='#{embed_url}'></param><param name='allowFullScreen' value='true'></param><param name='allowscriptaccess' value='always'></param><embed src='#{embed_url}' type='application/x-shockwave-flash' allowscriptaccess='always' allowfullscreen='true' width='#{width}' height='#{height}'></embed></object>"
  end

  def flv
    # deprecated
    #request_signature = @feed[0]["request"]["signature"]
    #request_signature_expires = @feed[0]["request"]["expires"]
    #"http://www.vimeo.com/moogaloop/play/clip:#{@video_id}/#{request_signature}/#{request_signature_expires}/?q=hd"
  end

  def download_url
    #deprecated
    #request_signature = @feed[0]["request"]["signature"]
    #request_signature_expires = @feed[0]["request"]["expires"]
    #"http://www.vimeo.com/moogaloop/play/clip:#{@video_id}/#{request_signature}/#{request_signature_expires}/?q=hd"
  end

  def service
    "Vimeo"
  end

  #protected

  # formats: http://vimeo.com/<video_id> or http://vimeo.com/channels/hd#<video_id>
  def parse_url(url)
      uri = URI.parse(url)
      path = uri.path
      videoargs = ''

      return uri.fragment if uri.fragment

      if uri.path and path.split("/").size > 0
        videoargs = path.split("/")
        raise unless videoargs.size > 0
      else
        raise
      end
      videoargs[1]
    #rescue
    #  nil
  end

end
