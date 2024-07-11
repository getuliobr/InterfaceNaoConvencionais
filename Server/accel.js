let lastReading = {x: 0, y: 0,z: 0};

let hasListener = false;

// Enviar para o servidor HTTP
const send = async (data) => {
  await fetch('/', {
    method: 'POST',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(data)
  });
}

// Função que recebe os eventos de movimento do celular
const parseEvent = async (event) => {
  // { x: leftToRight, y: frontToBack, z: rotateDegrees  };
  const { alpha: z, beta: y, gamma: x } = event;

  if (Math.abs(x - lastReading.x) > .5 || Math.abs(y - lastReading.y) > .5 || Math.abs(z - lastReading.z) > .5)
    send({x, y, z});
  lastReading = {x, y, z};
}


const askPerms = async () => {
  const response = await DeviceMotionEvent.requestPermission();
  if(response != 'granted') return;
  document.getElementById('perms').innerHTML = "Funcionando"
  if (hasListener) return;
  hasListener = true;
  addEventListener('deviceorientation', (event) => parseEvent(event));
}

