import http from 'k6/http';
import { sleep } from 'k6';

export let options = {
    stages: [
        { duration: '1m', target: 2400 },
        { duration: '1m', target: 0 },
    ],
    thresholds: {
        http_req_failed: [{
            threshold: 'rate<=0.005',
            abortOnFail: true,
        }],
    },
};
export default () => {
    const urlRes = http.get('https://game-over-mobile-app.web.app/');
    sleep(1);
};

