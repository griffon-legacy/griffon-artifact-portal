package griffon.portal.stats

import grails.converters.JSON

class UsageController {
    static defaultAction = 'usage'

    def usage() {
        String usageStatsVersion = request.getHeader('x-griffon-usage-stats')
        if (!usageStatsVersion) {
            response.status = 401
            render([output: 'Unauthorized'] as JSON)
            return
        }

        new Usage(
            ipAddress: request.remoteAddr,
            griffonVersion: params.gv,
            javaVersion: params.jv,
            javaVendor: params.ve,
            javaVmVersion: params.vm,
            osName: params.on,
            osArch: params.oa,
            osVersion: params.ov,
            commandName: params.cn,
            scriptName: params.sn,
            username: params.un
        ).save()

        render([output: 'OK'] as JSON)
    }
}
