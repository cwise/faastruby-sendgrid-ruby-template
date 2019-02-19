require 'spec_helper'
require 'send_grid_inbound'

describe 'SendGridInbound' do
  let(:raw_body) { File.read('spec/fixtures/body.txt') }
  let(:raw_headers) { File.read('spec/fixtures/headers.txt').chomp }
  let(:event) {Event.new(
    body: raw_body,
    query_params: {},
    headers: { 'Content-Type' => 'multipart/form-data; boundary=xYzZY', 'Content-Length' => raw_body.size.to_s },
    context: '{ "from": "chriswise71@gmail.com" }'
  )}
    
  before do
    @inbound = SendGridInbound.new(event)
  end

  it 'should parse content type' do
    expect(@inbound.content_type).to eq('multipart/form-data; boundary=xYzZY')
  end

  it 'should parse content length' do
    expect(@inbound.content_length).to eq('4369')
  end

  it 'should parse boundary' do
    expect(@inbound.boundary).to eq('xYzZY')
  end  

  describe 'headers' do
    it 'should find 13 headers' do
      expect(@inbound.sendgrid_headers.size).to eq(13)
    end

    it 'should extract subject' do
      expect(@inbound.subject).to eq('This is a the subject line')
    end

    it 'should extract body' do
      expect(@inbound.body).to eq('This is the body')
    end      

    it 'should extract attachments' do
      expect(@inbound.attachments).to eq('0')
    end

    it 'should extract sender_ip' do
      expect(@inbound.sender_ip).to eq('209.85.160.174')
    end

    it 'should extract sender' do
      expect(@inbound.sender).to eq('Chris Wise <chriswise71@gmail.com>')
    end

    it 'should extract receiver' do
      expect(@inbound.receiver).to eq('test@hutzbot-development.rangefindr.ca')
    end

    it 'should extract raw_headers' do
      expect(@inbound.raw_headers.size).to eq(raw_headers.size)
      expect(@inbound.raw_headers).to eq(raw_headers)
    end      
  end

  describe 'mail_headers' do
    it 'should find 16 headers' do
      expect(@inbound.mail_headers.size).to eq(15)
    end

    it 'should handle multiple headers as an array result' do
      expect(@inbound.mail_headers['Received'].is_a?(Array)).to be true
      expect(@inbound.mail_headers['Received'].size).to eq(4)
    end

    it 'should extract In-Reply-To' do
      expect(@inbound.mail_headers['In-Reply-To']).to be_nil
      expect(@inbound.in_reply_to).to eq('')        
    end

    it 'should extract Message-Id' do
      expect(@inbound.mail_headers['Message-Id']).to eq('<3B0F3105-1E39-4C70-B185-8571D6790BE8@gmail.com>')
      expect(@inbound.message_id).to eq('3B0F3105-1E39-4C70-B185-8571D6790BE8')        
    end
  end
end