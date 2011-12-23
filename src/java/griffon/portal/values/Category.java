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

package griffon.portal.values;

import java.util.Arrays;
import java.util.List;

/**
 * @author Andres Almiray
 */
public enum Category {
    ALL("All"),
    HIGHEST_VOTED("Highest Voted"),
    RECENTLY_UPDATED("Recently Updated"),
    MOST_DOWNLOADED("Most Downloaded"),
    NEWEST("Newest");
    private final String capitalizedName;

    private Category(String capitalizedName) {
        this.capitalizedName = capitalizedName;
    }

    public String getName() {
        return name().toLowerCase();
    }

    public String getCapitalizedName() {
        return capitalizedName;
    }

    private static String[] NAMES;
    private static String[] CAPITALIZED_NAMES;

    public static Category findByName(String name) {
        for (Category category : values()) {
            if (category.getName().equals(name)) {
                return category;
            }
        }
        throw new IllegalArgumentException("No category matches name '" + name + "'");
    }

    static {
        Category[] values = Category.values();
        NAMES = new String[values.length];
        CAPITALIZED_NAMES = new String[values.length];

        int i = 0;
        for (Category category : Category.values()) {
            NAMES[i] = category.getName();
            CAPITALIZED_NAMES[i++] = category.getCapitalizedName();
        }
    }

    public static List<String> getNamesAsList() {
        return Arrays.asList(NAMES);
    }

    public static List<String> getCapitalizedNamesAsList() {
        return Arrays.asList(CAPITALIZED_NAMES);
    }

    public static List<Category> asList() {
        return Arrays.asList(values());
    }
}
