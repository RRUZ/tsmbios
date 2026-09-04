const fs = require('node:fs');
const path = require('node:path');
if (!process.argv[2]) throw Error('Usage: node extract-fixture.cjs <output.bin>');
const source = fs.readFileSync(path.resolve(__dirname, '../../testing/LoadSMBIOSDump.dpr'), 'utf8');
const block = source.match(/SMBIOS_Sample_3_2_Base64: string =([\s\S]*?);/)[1];
const encoded = [...block.matchAll(/'([^']*)'/g)].map(m => m[1]).join('');
fs.writeFileSync(process.argv[2], Buffer.from(encoded, 'base64'));
