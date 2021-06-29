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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;

public class BulkOffset {
  private static final Logger log = LoggerFactory.getLogger(JdbcSourceTask.class);
  static final String BULK_FIELD = "bulk";
  static final String EVENT_PUSHED = "event_pushed";

  private final Long bulkOffset;
  private final AtomicBoolean snsEventPushed = new AtomicBoolean(false);

  /**
   * @param bulkOffset the bulk offset.
   *                   If null, {@link #getBulkOffset()} will return 0.
   */
  public BulkOffset(Long bulkOffset, Boolean snsEventPushed) {
    this.bulkOffset = bulkOffset;
    this.snsEventPushed.set(snsEventPushed);
  }

  public long getBulkOffset() {
    return bulkOffset == null ? 0 : bulkOffset;
  }

  public boolean isSnsEventPushed() {
    return snsEventPushed.get();
  }

  public void setEventPushed() {
    this.snsEventPushed.set(true);
  }

  public Map<String, Object> toMap() {
    Map<String, Object> map = new HashMap<>(3);
    if (bulkOffset != null) {
      map.put(BULK_FIELD, bulkOffset);
      map.put(EVENT_PUSHED, snsEventPushed);
    }
    return map;
  }

  public static BulkOffset fromMap(Map<String, ?> map) {
    if (map == null || map.isEmpty()) {
      return new BulkOffset(null, false);
    }

    Long incr = (Long) map.get(BULK_FIELD);
    Boolean snsEventPushed = (Boolean) map.get(EVENT_PUSHED);
    return new BulkOffset(incr, snsEventPushed);
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
