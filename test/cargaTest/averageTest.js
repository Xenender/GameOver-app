import http from 'k6/http';
import { sleep } from 'k6';

export let options = {
    stages: [
        { duration: '3m', target: 3000 }, // Rampa de subida a 10,000 VUs en 3 minutos
        { duration: '3m', target: 3000 }, // Mantener 10,000 VUs durante 3 minutos
        { duration: '2m', target: 0 },     // Rampa de bajada a 0 VUs en 2 minutos
    ],
    thresholds: {
        http_req_failed: [{
            threshold: 'rate<0.01',
            abortOnFail: true,
        }],
    },
};
export default () => {
    const urlRes = http.get('https://game-over-mobile-app.web.app/');
    sleep(1);
};

