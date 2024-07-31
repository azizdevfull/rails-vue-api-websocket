<template>
    <div>
      <ul>
        <li v-for="notification in notifications" :key="notification">{{ notification }}</li>
      </ul>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted, onUnmounted } from 'vue';
  import { createConsumer } from '@rails/actioncable';
  
  const notifications = ref([]);
  const consumer = createConsumer('ws://localhost:3000/cable');
  let channel;
  
  const subscribeToNotifications = () => {
    channel = consumer.subscriptions.create("NotificationsChannel", {
      received(data) {
        notifications.value.push(data.message);
      }
    });
  };
  
  onMounted(() => {
    subscribeToNotifications();
  });
  
  onUnmounted(() => {
    if (channel) {
      channel.unsubscribe();
    }
  });
  </script>
  