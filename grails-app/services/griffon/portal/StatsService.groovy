package griffon.portal

import griffon.portal.stats.*
import griffon.portal.util.MD5
import griffon.portal.values.PreferenceKey
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.grails.geoip.service.GeoIpService

class StatsService {
    GeoIpService geoIpService
    GrailsApplication grailsApplication
    PreferencesService preferencesService

    void download(Map params) {
        // preferencesService.getValueOf(PreferenceKey.USER_AGENT_FILTERS)

        Download download = new Download(
            username: MD5.encode(params.username),
            release: params.release,
            type: params.type,
            userAgent: params.userAgent,
            ipAddress: params.ipAddress,
            osName: params.osName,
            osArch: params.osArch,
            osVersion: params.osVersion,
            javaVersion: params.javaVersion,
            javaVmVersion: params.javaVmVersion,
            javaVmName: params.javaVmName,
            griffonVersion: params.griffonVersion
        ).save()

        DownloadTotal total = DownloadTotal.findOrCreateWhere(release: params.release, type: params.type)
        total.total += 1
        total.save()

        def location = geoIpService.getLocation(download.ipAddress)
        String country = location?.countryName ?: 'Unresolved'
        if (location?.latitude == -20.0 && location?.longitude == 47.0) country = 'Unresolved'

        DownloadByCountry downloadByCountry = DownloadByCountry.findOrCreateWhere(artifact: download.release.artifact, country: country)
        downloadByCountry.total += 1
        downloadByCountry.save()

        DownloadTotalByCountry totalByCountry = DownloadTotalByCountry.findOrCreateWhere(country: country)
        totalByCountry.total += 1
        totalByCountry.save()
    }

    void upload(Map params) {
        Upload upload = new Upload(
            username: MD5.encode(params.username),
            release: params.release,
            type: params.type
        ).save()

        UploadTotal total = UploadTotal.findOrCreateWhere(release: upload.release, type: upload.type)
        total.total += 1
        total.save()
    }
}
