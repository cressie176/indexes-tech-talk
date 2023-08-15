const { ok } = require('assert');

const { Client } = require('pg');
const format = require('pg-format');

const client = new Client();

describe('Query Performance', () => {

  before(async () => {
    await client.connect();        
  })

  after(async () => {
    await client.end();
  })

  it('get 50+ employees by location', async () => {
    const template = `
      EXPLAIN (ANALYZE TRUE, FORMAT JSON) 
      SELECT name, age 
      FROM employee
      WHERE location = %L 
        AND age >= %L 
        AND end_date IS NULL 
      ORDER BY name 
      LIMIT %L 
      OFFSET %L;
    `;
    const sql = format(template, 'Sydney', 50, 100, 20000);    
    const result = await client.query(sql);
    const plan = result.rows[0]['QUERY PLAN'][0]['Plan'];
    const cost = plan['Total Cost'];
    ok(cost < 1500);
  })
})

