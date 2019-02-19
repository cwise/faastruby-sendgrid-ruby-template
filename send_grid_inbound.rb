class SendGridInbound
  attr_reader :content_type
  attr_reader :content_length
  attr_reader :boundary
  attr_reader :parts
  attr_reader :raw_headers
  attr_reader :sendgrid_headers
  attr_reader :mail_headers

  MSG_ID_REGEX = /<([a-z\-\d_]+)@[a-z\d.]+>/i

  def initialize event
    @content_type = event.headers['Content-Type']
    @content_length = event.headers['Content-Length']

    # ensure this is multi-part/form-data from Sendgrid
    @boundary = ""
    matches = /%r|\A(multipart\/.*)boundary=\"?([^\";,]+)\"?|ni/.match(content_type)
    if matches
      @content_type_detail = matches[1].strip
      @boundary = matches[2]
    end

    body = event.body

    # parse SendGrid headers
    @parts = body.split("--"+@boundary)
    @sendgrid_headers = {}
    @parts.each do |part|
      matches = /Content-Disposition: form-data; name="([a-zA-z]+)"\r\n\r\n(.+)/m.match(part)
      if matches
        key = matches[1]
        value = matches[2].strip
        @sendgrid_headers[key] = value
      end
    end

    # parse mail_headers
    @raw_headers = @sendgrid_headers['headers']
    @mail_headers = {}
    unless @raw_headers.nil?
      @raw_headers.split("\n").each do |header| 
        matches = /([a-zA-Z-]+):\s(.+)/.match(header)

        unless matches.nil?
          key = matches[1]
          value = matches[2].strip

          # see if there is a value otherwise add
          unless @mail_headers.keys.include?(key)
            @mail_headers[key] = value
          else
            current = @mail_headers[key]
            if current.is_a?(String)
              # convert to an array
              @mail_headers[key] = [] << current << value
            else
              @mail_headers[key] << value
            end
          end
        end
      end
    end
  end

  def sender
    @sendgrid_headers['from']
  end

  def sender_ip
    @sendgrid_headers['sender_ip']
  end

  def receiver
    @sendgrid_headers['to']
  end

  def subject
    @sendgrid_headers['subject']
  end

  def attachments
    @sendgrid_headers['attachments']
  end

  def body
    @sendgrid_headers['text']
  end

  def message_id
    matches = MSG_ID_REGEX.match(@mail_headers['Message-Id'])
    matches ? matches[1] : ""
  end

  def in_reply_to
    matches = MSG_ID_REGEX.match(@mail_headers['In-Reply-To'])
    matches ? matches[1] : ""
  end
end
