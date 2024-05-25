import http from 'k6/http';
import { sleep } from 'k6';
export const options = {
    vus: 5,
    duration: '1m',
    thresholds: {
        http_req_failed: [{
            threshold: 'rate<=0.00',
            abortOnFail: true,
        }],
        http_req_duration: ['p(100)<=100'],
    },
};


export default () => {
    const urlRes = http.get('https://game-over-mobile-app.web.app/');
    sleep(1);
};