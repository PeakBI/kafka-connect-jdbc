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

package io.confluent.connect.jdbc.util;

import java.time.Duration;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import org.apache.kafka.clients.consumer.Consumer;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.apache.kafka.common.serialization.StringSerializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class EventBackingStore {
  private final Logger log = LoggerFactory.getLogger(EventBackingStore.class);
  public static final String EVENT_BACKING_STORE_TOPIC = "__event_status";
  
  private Producer<String, String> producer;
  private Consumer<String, String> consumer;
  private Map<String, String> eventStatus;

  private void readTillEnd() {
    ConsumerRecords<String, String> records = this.consumer.poll(Duration.ofMillis(10000));
    while (records.count() > 0) {
      for (ConsumerRecord<String, String> record: records) {
        this.eventStatus.put(record.key(), record.value());
      }
      this.consumer.commitAsync();
      records = this.consumer.poll(Duration.ofMillis(10000));
    }
  }

  public EventBackingStore(String brokerUrl) {
    // Initialize producer
    Properties producerProperties = new Properties();
    producerProperties.put("bootstrap.servers", brokerUrl);
    producerProperties.put("key.serializer", StringSerializer.class);
    producerProperties.put("value.serializer", StringSerializer.class);
    this.producer = new KafkaProducer<String, String>(producerProperties);

    // Initialize consumer
    Properties consumerProperties = new Properties();
    consumerProperties.put("bootstrap.servers", brokerUrl);
    consumerProperties.put("key.deserializer", StringDeserializer.class);
    consumerProperties.put("value.deserializer", StringDeserializer.class);
    consumerProperties.put("group.id", "events-" + UUID.randomUUID().toString());
    consumerProperties.put("auto.offset.reset", "earliest");
    this.consumer = new KafkaConsumer<String, String>(consumerProperties);
    this.consumer.subscribe(Collections.singleton(EVENT_BACKING_STORE_TOPIC));

    this.eventStatus = new HashMap<String, String>();
    this.readTillEnd();
    log.info("Event backing store initialized with {} records", this.eventStatus.size());
  }

  public String get(String key) {
    this.readTillEnd();
    return eventStatus.get(key);
  }

  public void set(String key, String value) {
    if (this.eventStatus.get(key) == null) {
      this.eventStatus.put(key, value);
      this.producer.send(new ProducerRecord<String, String>(EVENT_BACKING_STORE_TOPIC, key, value));
    }
  }

  public void close() {
    this.producer.close();
    this.consumer.close();
  }
}