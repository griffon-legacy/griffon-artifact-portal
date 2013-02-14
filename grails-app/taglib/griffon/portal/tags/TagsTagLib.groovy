/*
 * Copyright 2009-2013 the original author or authors.
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

package griffon.portal.tags

/**
 * This is a carbon copy of the TagsTagLib included in Taggable.
 * Reproduced here so that tag links could be customized further.
 *
 * @author Graeme Rocher (taggable)
 * @author Andres Almiray
 */
class TagsTagLib {
    static namespace = 'gtags'
    static defaultCssClasses = ['smallest', 'small', 'medium', 'large', 'largest']

    def grailsApplication

    /**
     * Generates a tag cloud using CSS styles to identify the relative importance
     * of each tag. These CSS styles can be configured via a 'grails.taggable.css.classes'
     * runtime config setting.
     */
    def tagCloud = { attrs ->
        if (!attrs.action) throwTagError("Required attribute [action] is missing")
        if (!attrs.tags) throwTagError("Required attribute [tags] is missing")
        if (!(attrs instanceof Map)) throwTagError("Required attribute [tags] must be a map of tag names to tag counts")

        def classes = grailsApplication.config.grails.taggable.css.classes ?: defaultCssClasses

        // The named arguments for the 'link' GSP tag used to display each tag.
        def idProperty = attrs?.idProperty ?: "id"
        def paramsMap = [:]
        if (attrs.params) paramsMap += attrs.params
        def linkArgs = [action: attrs.action, params: paramsMap]
        if (attrs.mapping) linkArgs.mapping = attrs.mapping

        // If a controller name is specified, we use that. Otherwise, we leave it
        // to the 'link' GSP tag to decide which controller to use.
        if (attrs.controller) linkArgs["controller"] = attrs.controller

        // How many times has the most used tag been applied?
        def maxCount = attrs.tags.values().max()
        out << "<ol class=\"tagCloud\">"
        for (t in attrs.tags) {
            def tagRanking
            if (t.value == maxCount) {
                tagRanking = classes.size() - 1
            } else {
                // This calculation only works if t.value != maxCount, otherwise
                // we end up with an array index that is equal to the length of
                // the 'classes' list.
                tagRanking = (classes.size() * t.value).intdiv(maxCount)
            }

            tagRanking = tagRanking?.toInteger()
            out << "<li class=\"${classes[tagRanking]}\">"

            paramsMap[idProperty] = t.key
            out << g.link(linkArgs.clone(), t.key)
            out << "</li>"
        }
        out << "</ol>"
    }
}
