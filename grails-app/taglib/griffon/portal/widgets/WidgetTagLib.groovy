/*
 * Copyright 2011 the original author or authors.
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

package griffon.portal.widgets

/**
 * @author Andres Almiray
 */
class WidgetTagLib {
    static namespace = 'widget'

    /**
     * Outputs a Twitter widget
     *
     * @attr username REQUIRED the twitter user to track
     * @emptyTag
     */
    def twitter = { attr, body ->
        if (!attr.username) throw new IllegalArgumentException('Property [username] must be set!')

        out << """
			<script>
			new TWTR.Widget({
			  version: 2,
			  type: 'profile',
			  rpp: 6,
			  interval: 30000,
			  width: 250,
			  height: 350,
			  theme: {
			    shell: {
			      background: '#333333',
			      color: '#ffffff'
			    },
			    tweets: {
			      background: '#000000',
			      color: '#ffffff',
			      links: '#eb0707'
			    }
			  },
			  features: {
			    scrollbar: true,
			    loop: true,
			    live: true,
			    behavior: 'default'
			  }
			}).render().setUser('$attr.username').start();
			</script>
        """
    }
}
