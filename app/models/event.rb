class Event < ActiveRecord::Base
	belongs_to :content_block
	accepts_nested_attributes_for :content_block

	validate :times_must_be_valid

	def name
		content_block.try(:title)
	end

	def title
		content_block.try(:title)
	end

	def tags
		content_block.try(:tags)
	end

	def image
		content_block.try(:image)
	end

	def summary
		content_block.try(:summary)
	end

	def bodytext
		content_block.try(:bodytext)
	end

	def start_time_parsed
		format_time(start_time)
	end

	def start_time_parsed=(value)
		self.start_time = parse_time(value)
	end

	def end_time_parsed
		format_time(end_time)
	end

	def end_time_parsed=(value)
		self.end_time = parse_time(value)
	end

	def self.publicly_viewable
		includes(:content_block).where.not(content_blocks: {published_at: nil}).where("end_time > ?", Time.now)
	end

private
	def parse_time(value)
		begin
			Time.strptime("#{value} +0800", "%Y-%m-%d %H:%M %Z")
		rescue ArgumentError
			false
		end
	end

	def format_time(time)
		return Time.now.strftime("%Y-%m-%d %H:%M") if time.blank?
		return nil unless time
		time.strftime("%Y-%m-%d %H:%M")
	end

	def times_must_be_valid
		errors.add(:start_time, "must be a valid date and time in yyyy-mm-dd HH:MM format") unless self.start_time
		errors.add(:end_time, "must be a valid date and time in yyyy-mm-dd HH:MM format") unless self.end_time
	end
end
