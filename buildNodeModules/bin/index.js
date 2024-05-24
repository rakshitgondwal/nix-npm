#!/usr/bin/env node

const { program } = require('commander');
const axios = require('axios');
const _ = require('lodash');
const winston = require('winston');

// Set up logging with winston
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.colorize(),
    winston.format.simple()
  ),
  transports: [
    new winston.transports.Console()
  ]
});

// Function to print a greeting message
function hello(name = 'World') {
  const message = `Hello, ${name}!`;
  logger.info(message);
}

// Function to print a farewell message
function goodbye(name = 'World') {
  const message = `Goodbye, ${name}!`;
  logger.info(message);
}

// Function to print the current date and time
function showDateTime() {
  const now = new Date();
  logger.info(`Current date and time: ${now.toString()}`);
}

// Function to fetch a random joke from an API
async function fetchJoke() {
  try {
    const response = await axios.get('https://official-joke-api.appspot.com/random_joke');
    const joke = response.data;
    logger.info(`${joke.setup} - ${joke.punchline}`);
  } catch (error) {
    logger.error('Failed to fetch joke:', error);
  }
}

// Function to generate a random number between a range
function generateRandomNumber(min = 0, max = 100) {
  const randomNumber = _.random(min, max);
  logger.info(`Random number between ${min} and ${max}: ${randomNumber}`);
}

// Set up the command and options using commander
program
  .version('1.0.0')
  .description('A complex CLI tool with various functionalities');

program
  .command('hello')
  .description('Print a greeting message')
  .option('-n, --name <name>', 'Specify the name to greet', 'World')
  .action((options) => {
    hello(options.name);
  });

program
  .command('goodbye')
  .description('Print a farewell message')
  .option('-n, --name <name>', 'Specify the name to say goodbye to', 'World')
  .action((options) => {
    goodbye(options.name);
  });

program
  .command('datetime')
  .description('Show the current date and time')
  .action(() => {
    showDateTime();
  });

program
  .command('joke')
  .description('Fetch a random joke from the internet')
  .action(async () => {
    await fetchJoke();
  });

program
  .command('random')
  .description('Generate a random number between a range')
  .option('-min, --min <number>', 'Specify the minimum number', '0')
  .option('-max, --max <number>', 'Specify the maximum number', '100')
  .action((options) => {
    const min = parseInt(options.min, 10);
    const max = parseInt(options.max, 10);
    generateRandomNumber(min, max);
  });

// Parse the command line arguments
program.parse(process.argv);
