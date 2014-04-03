# require 'evertrue'
require 'itunes-search-api'
require 'net/http'

class EvertrueAppAssets
  def app(oid)
    @app = @app || find_app_by_oid(oid)
  end

  def self.get_download_link(oid, platform)
    if platform.to_s == 'ios'
      get_ios_download_link(oid)
    elsif platform.to_s == 'android'
      "https://play.google.com/store/apps/details?id=com.evertrue.#{oid}"
    end
  end

  def self.get_ios_screenshots(oid)
    app = app(oid)
    if app && (app.size == 1)
      app['screenshotUrls']
    else
      nil
    end
  end

  def self.get_premium_status(oid)
    uri       = URI.parse('https://api.evertrue.com/1.0/global/product&access_key=46ac686ed6b55f1fd347b8138a0f357f&status=(live)')
    request   = Net::HTTP.get(uri)
    code      = YAML.load(request)['meta']['code']
    response  = YAML.load(request)['response']['data']

    if code == 200
      premium = response.any? { |app| (app['oid'] == oid) && (app['type'] == 'COMMUNITY') && (app['is_premium'] == '1') }
    end

    premium
  end

  def self.get_ios_id(oid)
    if app(oid) && !app(oid).empty? && app(oid).size == 1
      app(oid)[0]['trackId']
    elsif app(oid) && !app(oid).empty?
      app(oid)[0]['trackId']
    else
      nil
    end
  end

  def self.get_ios_download_link(oid)
    if app(oid) && !app(oid).empty?
      app(oid)['trackViewUrl']
    else
      nil
    end
  end

  def self.get_bundle_id(oid)
    EverTrue.legacy_api.dna(oid, 'ET.App(oid).Ios.BundleId')
  end

  def self.find_app_by_oid(oid)
    # Find bundle_id in DNA
    bundle_id = get_bundle_id(oid)

    # Use bundle_id to lookup app(oid) in iTunes
    if bundle_id
      @app = ITunesSearchAPI.lookup(bundleId: bundle_id)
    end

    # Return if we found the app(oid), otherwise search iTunes by oid
    if @app
      return @app
    else
      @app = search_for_app_by_oid(oid)
      return @app
    end
  end

  # Find app(oid) without knowing its bundleId
  def self.search_for_app_by_oid(oid)
    results = ITunesSearchAPI.search(term: oid, media: 'software')

    if results && (results.size == 1)
      return results[0]
    elsif results && !results.empty?
      # Find result with bundleId containing 'evertrue'
      return results.select { |res| (res['bundleId'] =~ /evertrue/) }
    else
      return nil
    end
  end
end
