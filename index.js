const { Client } = require('pg');
const format = require('pg-format');
const Chance = require('chance');
const ProgressBar = require('progress');

const client = new Client();
const chance = new Chance();
const numEmployees = process.argv[2] ? Number(process.argv[2]) : 200000;
const bar = new ProgressBar(':bar :percent', { total: numEmployees });

const positions = [
  'Accountant',
  'Chief Executive Officier (CEO)',
  'Chief Operating Officer (COO)',
  'Customer Support',  
  'JavaScript Developer',  
  'Junior Technical Author',
  'Integration Specialist',  
  'Personnel Lead',  
  'Pre-Sales Support',
  'Regional Director',  
  'Sales Assistant',
  'Senior JavaScript Developer',
  'Software Engineer',
  'Support Engineer',
];

const locations = [
  'Edinburgh',
  'New York',  
  'London',
  'Sydney',  
  'San Francisco',  
  'Tokyo',  
];


(async () => {
	await client.connect();
	try {
		await client.query('DROP TABLE IF EXISTS employee');
		await client.query(`CREATE TABLE employee (
	      id SERIAL PRIMARY KEY,
	      name TEXT NOT NULL,
	      position TEXT NOT NULL,
	      location TEXT NOT NULL,
	      age INTEGER NOT NULL,
	      start_date DATE NOT NULL,
	      salary INTEGER NOT NULL,
	      end_date DATE
		)`)

		const employees = new Array(numEmployees).fill(null).map((_, index) => {
		  const name = chance.name();
		  const position = chance.pickone(positions);
		  const location = chance.pickone(locations);
		  const age = chance.age();
		  const startYear = Number(chance.year({ min: 1960, max: 2018 }));  
		  const startDate = chance.date({ year: startYear });
		  const salary = chance.natural({ max: 200000 });
		  const endYear = Number(chance.year({ min: startYear + 1, max: 2020 }));
		  const endDate = index % 10 === 0 ? chance.date({ year: endYear }) : null;
		  bar.tick();	  
		  return [name, position, location, age, startDate, salary, endDate]
		});

		console.log(`Inserting ${numEmployees} employees`);
		const sql = format(`INSERT INTO employee (name, position, location, age, start_date, salary, end_date) VALUES %L`, employees);
  	await client.query(sql);

  	console.log('Running VACUUM ANALYZE');
  	await client.query('VACUUM ANALYZE');

    console.log('Done');
  } finally {
	  await client.end();
  }

})();
