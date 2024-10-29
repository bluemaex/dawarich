# frozen_string_literal: true

class AppVersionCheckingJob < ApplicationJob
  queue_as :default

  def perform
    Rails.cache.delete(CheckAppVersion::VERSION_CACHE_KEY)

    CheckAppVersion.new.call
  end
end
