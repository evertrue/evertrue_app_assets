require 'itunes-search-api'
require 'net/http'

class EvertrueAppAssets

  def self.get_download_link(oid, platform)
    if platform.to_s == 'ios'
      get_ios_download_link(oid)
    elsif platform.to_s == 'android'
      "https://play.google.com/store/apps/details?id=com.evertrue.#{oid}"
    end
  end

  def self.get_ios_screenshots(oid)
    app = find_app_by_oid(oid)

    if app && !app.empty?
      app['screenshotUrls']
    else
      nil
    end
  end

  private

  def self.get_ios_download_link(oid)
    app = find_app_by_oid(oid)

    if app && !app.empty?
      app['trackViewUrl']
    else
      nil
    end
  end

  def self.get_bundle_id(oid)
    uri = URI.parse("https://api.evertrue.com/1.0/#{oid}/dna/ET.App.Ios.BundleId")
    request = Net::HTTP.get(uri)
    response = YAML.load(request)['response'] if request
    bundle_id = response['data'] if response

    bundle_id
  end

  def self.find_app_by_oid(oid)
    bundle_id = get_bundle_id(oid)

    if bundle_id
      app = ITunesSearchAPI.lookup(bundleId: bundle_id)
    else
      app = search_for_app_by_oid(oid)
    end

    app
  end

  # Find app without knowing its bundleId
  def self.search_for_app_by_oid(oid)
    results = ITunesSearchAPI.search(term: oid, media: 'software')

    if results && (results.size == 1)
      results
    elsif results && !results.empty?
      # Find result with bundleId containing 'evertrue'
      results.select { |res| (res['bundleId'] =~ /evertrue/) }
    else
      nil
    end
  end
end
