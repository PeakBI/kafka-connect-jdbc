/*
 * Copyright 2018 Confluent Inc.
 *
 * Licensed under the Confluent Community License (the "License"); you may not use
 * this file except in compliance with the License.  You may obtain a copy of the
 * License at
 *
 * http://www.confluent.io/confluent-community-license
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OF ANY KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations under the License.
 */

package io.confluent.connect.jdbc.source;

import java.util.HashMap;
import java.util.Map;

public class BulkOffset {
  static final String BULK_FIELD = "bulk";

  private final Long bulkOffset;

  /**
   * @param bulkOffset the bulk offset.
   *                   If null, {@link #getBulkOffset()} will return 0.
   */
  public BulkOffset(Long bulkOffset) {
    this.bulkOffset = bulkOffset;
  }

  public long getBulkOffset() {
    return bulkOffset == null ? 0 : bulkOffset;
  }

  public Map<String, Object> toMap() {
    Map<String, Object> map = new HashMap<>(1);
    if (bulkOffset != null) {
      map.put(BULK_FIELD, bulkOffset);
    }
    return map;
  }

  public static BulkOffset fromMap(Map<String, ?> map) {
    if (map == null || map.isEmpty()) {
      return new BulkOffset(null);
    }

    Long offset = (Long) map.get(BULK_FIELD);
    return new BulkOffset(offset);
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }

    BulkOffset that = (BulkOffset) o;

    return bulkOffset != null
        ? bulkOffset.equals(that.bulkOffset)
        : that.bulkOffset == null;
  }

  @Override
  public int hashCode() {
    int result = bulkOffset != null ? bulkOffset.hashCode() : 0;
    return result;
  }
}
