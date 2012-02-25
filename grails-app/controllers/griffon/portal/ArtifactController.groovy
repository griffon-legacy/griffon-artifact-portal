/*
 * Copyright 2011-2012 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package griffon.portal

import com.naleid.grails.MarkdownService
import grails.converters.JSON
import griffon.portal.auth.User
import griffon.portal.stats.DownloadTotal
import griffon.portal.values.ArtifactTab
import griffon.portal.values.Category

/**
 * @author Andres Almiray
 */
class ArtifactController {
    MarkdownService markdownService
    NotifyService notifyService

    def watch() {
        User user = session.user ? User.get(session.user.id) : null
        Artifact artifact = Artifact.get(params.id)
        Watcher watcher = Watcher.findByArtifact(artifact) ?: new Watcher(artifact: artifact)

        if (watcher.users?.contains(user)) {
            watcher.removeFromUsers(user)
            if (watcher.users.isEmpty()) {
                watcher.delete(flush: true)
            } else {
                watcher.save(flush: true)
            }
            render([status: false] as JSON)
        } else {
            watcher.addToUsers(user)
            watcher.save(flush: true)
            render([status: true] as JSON)
        }
    }

    def tag() {
        Artifact artifact = Artifact.get(params.id)
        if (params.tags) {
            artifact.setTags(params.tags.split(',')*.trim())
        } else if (artifact.tags) {
            artifact.setTags([])
        }

        if (!artifact.save(flush: true)) {
            render([code: 'ERROR'] as JSON)
        } else {
            render([code: 'OK', tags: artifact.tags.sort().join(', ')] as JSON)
        }
    }

    def preview_comment() {
        try {
            render([
                    code: 'OK',
                    html: markdownService.markdown(params.commentPreview)
            ] as JSON)
        } catch (Exception e) {
            render([
                    code: 'ERROR'
            ] as JSON)
        }
    }

    def post_comment() {
        String html = markdownService.markdown(params.commentSource)
        Artifact artifact = null
        switch (params.type) {
            case 'plugin':
                artifact = Plugin.findByName(params.name)
                break
            case 'archetype':
                artifact = Archetype.findByName(params.name)
                break
        }
        artifact.addComment(session.user, html)

        notifyService.notifyOnNewComment(artifact, session.user)

        redirect(controller: artifact.type, action: 'show', params: [name: params.name, tab: ArtifactTab.COMMENTS.name])
    }

    // --== CATEGORIES == --

    def all() {
        Map args = [sort: 'name', order: 'asc']
        List<Artifact> artifacts = []        
        switch (params.type) {
            case 'plugin':
                artifacts = Plugin.list(args)
                break
            case 'archetype':
                artifacts = Archetype.list(args)
                break
        }

        Map artifactMap = [:]
        artifacts.each {Artifact artifact ->
            String firstChar = artifact.name[0].toUpperCase()
            List list = artifactMap.get(firstChar, [])
            list << artifact
        }

        artifacts = params.character ? artifacts.findAll { it.name[0].equalsIgnoreCase(params.character) } : artifacts
        def total = artifacts.size()
        def max = params.max?.toInteger() ?: 10
        def offset = params.offset?.toInteger() ?: 0
        def end = Math.min(offset+max, artifacts.size())

        [
                artifactMap: artifactMap,
                artifacts: artifacts[offset..<end],
                artifactTotal: total,
                categoryType: Category.findByName(params.action),
                character: params.character
        ]
    }

    def recently_updated() {
        Date now = (new Date()).clearTime()
        List<Artifact> artifacts = []

        Map queryParams = [
                sort: 'name',
                order: 'asc',
        ]

        switch (params.type) {
            case 'plugin':
                artifacts = Plugin.findAllByLastUpdatedBetween(now - 14, now + 1, queryParams)
                break
            case 'archetype':
                artifacts = Archetype.findAllByLastUpdatedBetween(now - 14, now + 1, queryParams)
                break
        }

        def max = params.max?.toInteger() ?: 5
        def offset = params.offset?.toInteger() ?: 0
        def end = Math.min(offset+max, artifacts.size())

        render(view: 'list',
                model: [
                        hasDownloads: false,
                        artifactList: artifacts[offset..<end],
                        artifactTotal: artifacts.size(),
                        categoryType: Category.findByName(params.action)
                ])
    }

    def newest() {
        Date now = (new Date()).clearTime()
        List<Artifact> artifacts = []

        Map queryParams = [
                sort: 'name',
                order: 'asc',
        ]

        switch (params.type) {
            case 'plugin':
                artifacts = Plugin.findAllByDateCreatedBetween(now - 14, now + 1, queryParams)
                break
            case 'archetype':
                artifacts = Archetype.findAllByDateCreatedBetween(now - 14, now + 1, queryParams)
                break
        }

        def max = params.max?.toInteger() ?: 5
        def offset = params.offset?.toInteger() ?: 0
        def end = Math.min(offset+max, artifacts.size())

        render(view: 'list',
                model: [
                        hasDownloads: false,
                        artifactList: artifacts[offset..<end],
                        artifactTotal: artifacts.size(),
                        categoryType: Category.findByName(params.action)
                ])
    }

    def highest_voted() {
        List<Artifact> artifacts = []

        switch (params.type) {
            case 'plugin':
                artifacts = Plugin.listOrderByAverageRating()
                break
            case 'archetype':
                artifacts = Archetype.listOrderByAverageRating()
                break
        }

        def max = params.max?.toInteger() ?: 5
        def offset = params.offset?.toInteger() ?: 0
        def end = Math.min(offset+max, artifacts.size())

        render(view: 'list',
                model: [
                        hasDownloads: false,
                        artifactList: artifacts[offset..<end],
                        artifactTotal: artifacts.size(),
                        categoryType: Category.findByName(params.action)
                ])
    }

    def most_downloaded() {
        Map queryParams = [
                sort: 'total',
                order: 'desc',
        ]

        List<DownloadTotal> downloadList = DownloadTotal.withCriteria(queryParams) {
            eq('type', params.type)
        }

        def max = params.max?.toInteger() ?: 5
        def offset = params.offset?.toInteger() ?: 0
        def end = Math.min(offset+max, downloadList.size())

        render(view: 'list',
                model: [
                        hasDownloads: true,
                        artifactList: downloadList[offset..<end],
                        artifactTotal: downloadList.size(),
                        categoryType: Category.findByName(params.action)
                ])
    }

    def tagged() {
        Map tagMap = [:]

        switch (params.type) {
            case 'plugin':
                Plugin.getAllTags().inject(tagMap) { map, tag ->
                    map[tag] = Plugin.countByTag(tag)
                    map
                }
                break
            case 'archetype':
                Archetype.getAllTags().inject(tagMap) { map, tag ->
                    map[tag] = Archetype.countByTag(tag)
                    map
                }
                break
        }

        [
                tagMap: tagMap,
                categoryType: Category.findByName(params.action)
        ]
    }

    def list_tagged() {
        List<Artifact> artifacts = []

        Map queryParams = [
                sort: 'name',
                order: 'asc',
        ]

        switch (params.type) {
            case 'plugin':
                artifacts = Plugin.findAllByTag(params.tagName, queryParams)
                break
            case 'archetype':
                artifacts = Archetype.findAllByTag(params.tagName, queryParams)
                break
        }

        def max = params.max?.toInteger() ?: 5
        def offset = params.offset?.toInteger() ?: 0
        def end = Math.min(offset+max, artifacts.size())


        render(view: 'list',
                model: [
                        hasDownloads: false,
                        artifactList: artifacts[offset..<end],
                        artifactTotal: artifacts.size(),
                        categoryType: Category.TAGGED
                ])
    }
}
