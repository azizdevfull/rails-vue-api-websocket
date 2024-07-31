<template>
    <div>
      <ul>
        <li v-for="(alert, index) in alerts" :key="index">{{ alert }}</li>
      </ul>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted, onUnmounted } from 'vue';
  
  const alerts = ref([]);
  let socket;
  
  function createSocket() {
    const socket_url = "ws://localhost:3000/cable";
    socket = new WebSocket(socket_url);
  
    socket.onopen = (event) => {
      console.log("Connected to server");
      const msg = {
        command: "subscribe",
        identifier: JSON.stringify({
          id: 1,
          channel: "NotificationsChannel"
        }),
      }
      socket.send(JSON.stringify(msg));
    };
  
    socket.onmessage = (event) => {
      const data = JSON.parse(event.data);
      if (data.type === "ping") {
        return;
      }
      if (data.message) {
        alerts.value.push(data.message);
      }
    };
  
    socket.onclose = function (event) {
      console.log("Socket closed");
    };
  
    socket.onerror = function (event) {
      console.log("Socket error", event);
    };
  }
  
  onMounted(() => {
    createSocket();
  });
  
  onUnmounted(() => {
    if (socket) {
      socket.close();
    }
  });
  </script>
  