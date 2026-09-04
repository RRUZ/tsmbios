'use strict';

const $ = (selector, root = document) => root.querySelector(selector);
const $$ = (selector, root = document) => [...root.querySelectorAll(selector)];
const escapeHTML = value => String(value ?? '').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const groups = {
  system: {name:'System + firmware', count:13, title:'The identity behind the hardware.', text:'BIOS capabilities, system and chassis identity, firmware components, versions and state.', type:45},
  processor: {name:'Processor + cache', count:3, title:'Follow the processor into its caches.', text:'Sockets, core and thread counts, cache capacity and the handles connecting the records.', type:4},
  memory: {name:'Memory', count:9, title:'From a DIMM to its physical array.', text:'Explore capacity, locators, memory technology, speed and the structures that connect them.', type:17},
  expansion: {name:'Expansion + onboard', count:5, title:'See where devices meet the system.', text:'Slot designators, bus widths, connector types and onboard-device addressing information.', type:9},
  management: {name:'Management + sensors', count:11, title:'Read the system’s management layer.', text:'IPMI interfaces, event logs, controller protocols and firmware-reported probe properties.', type:38},
  security: {name:'Security + power', count:6, title:'Identify the trust and power components.', text:'TPM vendor and version, hardware security, batteries, power supplies and reset information.', type:43}
};

function highlightPascal(element) {
  const text = element.textContent;
  const tokens = /('[^']*(?:''[^']*)*'|\/\/[^\n]*|\{[^}]*\}|\b(?:program|procedure|function|uses|var|begin|end|try|finally|if|then|else|for|in|do|and|or|not|const)\b|\bT[A-Z]\w*\b)/gi;
  let result = '', last = 0;
  for (const match of text.matchAll(tokens)) {
    result += escapeHTML(text.slice(last, match.index));
    const token = match[0];
    const kind = token.startsWith("'") ? 'string' : token.startsWith('//') || token.startsWith('{') ? 'comment' : /^T[A-Z]/.test(token) ? 'type' : 'keyword';
    result += `<span class="tok-${kind}">${escapeHTML(token)}</span>`;
    last = match.index + token.length;
  }
  element.innerHTML = result + escapeHTML(text.slice(last));
}

function bindTabs(root, callback) {
  root.addEventListener('keydown', event => {
    if (!['ArrowLeft','ArrowRight','Home','End'].includes(event.key)) return;
    const tabs = $$('[role="tab"]', root);
    const current = tabs.indexOf(document.activeElement);
    if (current < 0) return;
    event.preventDefault();
    const index = event.key === 'Home' ? 0 : event.key === 'End' ? tabs.length - 1 : (current + (event.key === 'ArrowRight' ? 1 : -1) + tabs.length) % tabs.length;
    tabs[index].focus();
    callback(tabs[index]);
  });
  root.addEventListener('click', event => {
    const tab = event.target.closest('[role="tab"]');
    if (tab) callback(tab);
  });
}

document.addEventListener('click', async event => {
  const button = event.target.closest('[data-copy]');
  if (!button) return;
  const code = document.getElementById(button.dataset.copy);
  if (!code) return;
  try {
    await navigator.clipboard.writeText(code.textContent);
    button.textContent = 'Copied';
    $('#copy-status').textContent = 'Code copied to clipboard.';
    setTimeout(() => { if (button.isConnected) button.textContent = 'Copy code'; }, 1800);
  } catch {
    $('#copy-status').textContent = 'Copy is unavailable. Select the code and copy it manually.';
    button.textContent = 'Select code to copy';
    const selection = window.getSelection();
    const range = document.createRange();
    range.selectNodeContents(code);
    selection.removeAllRanges();
    selection.addRange(range);
  }
});
$$('pre code').forEach(highlightPascal);

function initAtlas() {
  function selectComponent(key) {
    const component = groups[key];
    if (!component) return;
    $$('[data-component]').forEach(button => button.setAttribute('aria-pressed', String(button.dataset.component === key)));
    $$('[data-board-part]').forEach(part => part.classList.toggle('selected', part.dataset.boardPart === key));
    $('#atlas-insight').innerHTML = `<div><span class="eyebrow">${escapeHTML(component.name.toUpperCase())} / ${component.count} STRUCTURE TYPES</span><h2>${escapeHTML(component.title)}</h2><p>${escapeHTML(component.text)}</p></div><a class="round-link" href="./explorer.html?group=${key}&type=${component.type}" aria-label="Explore ${escapeHTML(component.name)} structures">↗</a>`;
  }
  $$('[data-component]').forEach(button => button.addEventListener('click', () => selectComponent(button.dataset.component)));
  $$('[data-board-part]').forEach(part => part.addEventListener('click', () => selectComponent(part.dataset.boardPart)));
}

async function initMemory() {
  let data;
  try {
    const response = await fetch('./assets/memory-sample.json');
    if (!response.ok) throw Error('Sample unavailable');
    data = await response.json();
    if (!Array.isArray(data.memory) || data.memory.length !== 4) throw Error('Invalid sample');
  } catch {
    const note = document.createElement('p');
    note.className = 'error-message';
    note.textContent = 'The interactive sample could not load. The static example above is still available; reload to try again.';
    $('.memory-map').append(note);
    $$('[data-module], [data-memory-view], #array-node').forEach(button => { button.disabled = true; });
    return;
  }
  let index = 0;
  let view = 'fields';
  const number = n => Number(n).toLocaleString('en-US');
  const row = (name, value, extra = '') => `<div${extra ? ' class="highlight"' : ''}><dt>${escapeHTML(name)}</dt><dd>${escapeHTML(value)}</dd></div>`;
  function render() {
    const item = data.memory[index];
    $('#memory-heading').textContent = `${item.locator} / HANDLE ${item.handle}`;
    $('#dimm-label').textContent = item.locator;
    $$('[data-module]').forEach(button => button.setAttribute('aria-pressed', String(Number(button.dataset.module) === index)));
    $$('[data-memory-view]').forEach(button => {
      const selected = button.dataset.memoryView === view;
      button.setAttribute('aria-selected', String(selected));
      button.tabIndex = selected ? 0 : -1;
    });
    const panel = $('#memory-panel');
    panel.setAttribute('aria-labelledby', `memory-tab-${view}`);
    if (view === 'fields') {
      panel.innerHTML = `<dl class="field-list">${row('Capacity', `${number(item.sizeMB)} MB`, true)}${row('Memory type',item.type)}${row('Reported speed',`${number(item.speed)} MT/s`)}${row('Configured speed',item.configuredSpeed ? `${number(item.configuredSpeed)} MT/s` : 'Unknown (reported as 0)')}${row('Device / bank',`${item.locator} / ${item.bank}`)}${row('Manufacturer',item.manufacturer || 'Not reported')}${row('Part number',item.partNumber || 'Not reported')}${row('Parent array',`Type 16 · handle ${item.arrayHandle}`,true)}</dl>`;
    } else if (view === 'array') {
      panel.innerHTML = `<h3>One array. Multiple devices.</h3><dl class="field-list">${row('Structure','Type 16 · Physical Memory Array')}${row('Handle', item.arrayHandle,true)}${row('Location',item.arrayLocation)}${row('Use',item.arrayUse)}${row('Error correction',item.errorCorrection)}${row('Devices reported by array',item.arrayDevices)}${row('Device records in fixture',data.memory.length)}</dl><p><code>Memory.PhysicalMemoryArray</code> resolves the module’s parent array. The sample’s four records share the same handle.</p><p><a class="text-link small" href="./explorer.html?type=16">Inspect Type 16 fields →</a></p>`;
    } else {
      const code = `// Within a TSMBios try/finally block.\n// Memory: TMemoryDeviceInformation;\nif SMBios.HasMemoryDeviceInfo then\n  for Memory in SMBios.MemoryDeviceInfo do\n    if Memory.GetDeviceLocatorStr = '${item.locator}' then\n    begin\n      WriteLn(Memory.GetSize, ' MB');\n      WriteLn(Memory.GetMemoryTypeStr);\n      WriteLn(Memory.GetSpeed, ' MT/s');\n      if Assigned(Memory.PhysicalMemoryArray) then\n        WriteLn(\n          Memory.PhysicalMemoryArray.GetLocationStr);\n    end;`;
      panel.innerHTML = `<div class="code-tools"><button type="button" class="copy-button" data-copy="memory-code">Copy code</button></div><pre><code id="memory-code">${escapeHTML(code)}</code></pre><p>This selects the ${escapeHTML(item.locator)} record in the example. Actual locator strings are provided by the firmware.</p>`;
      highlightPascal($('#memory-code'));
    }
  }
  $$('[data-module]').forEach(button => button.addEventListener('click', () => { index = Number(button.dataset.module); render(); }));
  bindTabs($('.memory-inspector .tab-bar'), button => { view = button.dataset.memoryView; render(); });
  $('#array-node').addEventListener('click', () => { view = 'array'; render(); $('#memory-tab-array').focus(); });
  render();
}

async function initExplorer() {
  const detail = $('#structure-detail');
  let catalog;
  try {
    const response = await fetch('./assets/catalog.json');
    if (!response.ok) throw Error('Reference unavailable');
    catalog = await response.json();
    if (!Array.isArray(catalog) || catalog.length !== 47) throw Error('Invalid reference');
  } catch {
    $('#result-count').textContent = 'Reference unavailable';
    detail.innerHTML = '<div class="empty-state"><h2>The reference could not load.</h2><p>Reload this page to try again, or <a href="https://github.com/RRUZ/tsmbios#smbios-tables-supported">browse the complete table index on GitHub</a>.</p></div>';
    return;
  }
  let selected = 17;
  let activeTab = 'fields';
  function readLocation() {
    const params = new URLSearchParams(location.search);
    selected = /^\d+$/.test(params.get('type') || '') && Number(params.get('type')) < 47 ? Number(params.get('type')) : 17;
    $('#group-filter').value = groups[params.get('group')] ? params.get('group') : 'all';
    $('#structure-search').value = params.get('q') || '';
  }
  function updateLocation(push = false) {
    const url = new URL(location.href);
    url.search = '';
    const group = $('#group-filter').value;
    if (group !== 'all') url.searchParams.set('group',group);
    if ($('#structure-search').value.trim()) url.searchParams.set('q',$('#structure-search').value.trim());
    url.searchParams.set('type',selected);
    history[push ? 'pushState' : 'replaceState']({},'',url);
  }
  const relationshipLink = (id, description) => {
    const target = catalog.find(item => item.id === id);
    return `<a href="./explorer.html?type=${id}"><span>TYPE ${id}</span><div><strong>${escapeHTML(target.name)}</strong><small>${escapeHTML(description)}</small></div><span class="relation-arrow" aria-hidden="true">→</span></a>`;
  };
  function renderDetail() {
    const item = catalog[selected];
    detail.innerHTML = `<div class="detail-heading"><span class="eyebrow">TYPE ${item.id} / ${escapeHTML(groups[item.group].name.toUpperCase())}</span><h2>${escapeHTML(item.name)}</h2><p>${escapeHTML(item.brief)}</p><div class="detail-meta"><code>${escapeHTML(item.className)}</code><span>${item.fields.length} declared fields</span><span>${item.methods.length} helpers</span>${item.legacy ? '<span class="legacy-badge">LEGACY STRUCTURE</span>' : ''}</div></div><div class="tab-bar" role="tablist" aria-label="Structure reference">${[['fields','Fields'],['api','Pascal API'],['relations','Relationships']].map(([key,label]) => `<button type="button" role="tab" id="detail-tab-${key}" data-detail-tab="${key}" aria-controls="detail-panel" aria-selected="${key === activeTab}" tabindex="${key === activeTab ? 0 : -1}">${label}</button>`).join('')}</div><div class="detail-content" id="detail-panel" role="tabpanel" aria-labelledby="detail-tab-${activeTab}" tabindex="0"></div><div class="detail-footer"><span>Sample projects</span>${item.samples.map(sample => `<a href="${escapeHTML(sample.url)}">${escapeHTML(sample.label)} ↗</a>`).join('')}<a href="${escapeHTML(item.source)}">Library source ↗</a></div>`;
    renderDetailPanel(item);
    bindTabs($('.tab-bar',detail), button => {
      activeTab = button.dataset.detailTab;
      $$('[data-detail-tab]',detail).forEach(tab => { const chosen = tab.dataset.detailTab === activeTab; tab.setAttribute('aria-selected',String(chosen)); tab.tabIndex = chosen ? 0 : -1; });
      $('#detail-panel').setAttribute('aria-labelledby',`detail-tab-${activeTab}`);
      renderDetailPanel(item);
    });
  }
  function renderDetailPanel(item) {
    const panel = $('#detail-panel');
    if (activeTab === 'fields') {
      const terms = $('#structure-search').value.trim().toLowerCase().split(/\s+/).filter(Boolean);
      const matches = terms.length ? item.fields.filter(field => terms.every(term => `${field.name} ${field.description}`.toLowerCase().includes(term))) : [];
      const jumpLinks = matches.length ? `<div class="field-matches"><span>Matching fields</span>${matches.map(field=>`<a href="#field-${escapeHTML(field.name)}">${escapeHTML(field.name)} ↓</a>`).join('')}</div>` : '';
      panel.innerHTML = `<p class="detail-callout">Declared fields from <a href="${escapeHTML(item.source)}">uSMBIOS.pas</a>. Types describe the raw layout; use Pascal helpers for decoded strings, units and extended values. The common structure header is omitted below.</p>${item.id === 17 ? '<p class="detail-callout"><a href="./#memory">See these fields in the interactive memory example →</a></p>' : ''}${jumpLinks}<div class="table-wrapper"><table class="reference-table"><thead><tr><th scope="col">Field</th><th scope="col">Raw type</th><th scope="col">Meaning</th></tr></thead><tbody>${item.fields.map(field => `<tr id="field-${escapeHTML(field.name)}"><td><code>${escapeHTML(field.name)}</code></td><td><code>${escapeHTML(field.type)}</code></td><td>${escapeHTML(field.description || 'Raw structure field; see the linked source for interpretation.')}${field.version ? `<small>Source version note: ${escapeHTML(field.version)}</small>` : ''}</td></tr>`).join('')}</tbody></table></div>${!item.fields.length ? '<p>The structure is described through its helper API. See the Pascal API tab and the source.</p>' : ''}`;
    } else if (activeTab === 'api') {
      const code = `// Add uSMBIOS to your uses clause.\n// SMBios: TSMBios;\nSMBios := TSMBios.Create;\ntry\n  WriteLn('Structures found: ',\n    SMBios.GetSMBiosTableEntries(${item.enumName}));\n  // Typed access: SMBios.${item.property}\nfinally\n  SMBios.Free;\nend;`;
      panel.innerHTML = `<p class="detail-callout">Access this structure through the property below. Check structure and field availability before reading optional values. The linked sample projects show table-specific usage.</p><div class="api-signature">SMBios.${escapeHTML(item.property)}<br><span class="muted">${escapeHTML(item.className)}${item.id > 1 ? ' (collection)' : ''}</span></div><h3>Find the structures</h3><div class="code-tools"><button type="button" class="copy-button" data-copy="explorer-code">Copy code</button></div><pre><code id="explorer-code">${escapeHTML(code)}</code></pre><h3>Helper signatures</h3><ul class="method-list">${item.methods.map(method=>`<li><code>${escapeHTML(method)};</code></li>`).join('')}</ul>${!item.methods.length ? '<p>Use the raw structure and table-specific sample for this type.</p>' : ''}`;
      highlightPascal($('#explorer-code'));
    } else {
      let content = item.relations.length ? `<div class="relation-list">${item.relations.map(([id,description])=>relationshipLink(id,description)).join('')}</div>` : '<p>This guide does not define a fixed relationship for this type. The structure may still be referenced by other records.</p>';
      if (item.id === 45) content += '<p>Associated component handles can reference different structure types. Use <code>GetAssociatedComponentHandle</code> to read each handle; Type 46 is one possible incoming reference, not a fixed child list.</p>';
      if (item.id === 46) content += '<p><code>ParentHandle</code> identifies the target structure. It is not restricted to Type 45.</p>';
      if (item.id === 14) content += '<p>A group can contain different structure types. Item type and handle identify each member; the link above opens the group format itself.</p>';
      panel.innerHTML = `<p class="detail-callout">Follow a structure’s references to understand the related hardware. Handle references are logical links reported by firmware; they do not establish physical placement.</p>${content}`;
    }
  }
  function renderList(save = true) {
    const query = $('#structure-search').value.trim().toLowerCase();
    const group = $('#group-filter').value;
    const terms = query.split(/\s+/).filter(Boolean);
    const filtered = catalog.filter(item => {
      if (group !== 'all' && item.group !== group) return false;
      if (/^(?:type\s*)?\d+$/.test(query)) return item.id === Number(query.replace('type','').trim());
      const text = `${item.name} ${item.brief} ${item.className} ${item.property} type ${item.id} ${groups[item.group].name} ${item.fields.map(field=>`${field.name} ${field.description}`).join(' ')} ${item.methods.join(' ')}`.toLowerCase();
      return terms.every(term=>text.includes(term));
    });
    $('#result-count').textContent = `${filtered.length} of 47 structures`;
    if (!filtered.length) {
      $('#structure-list').innerHTML = '<div class="empty-state"><p>No matching structures.</p></div>';
      detail.innerHTML = '<div class="empty-state"><h2>No structures match these filters.</h2><p>Try a component name, field, helper or type number. Reset to browse all 47 types.</p><button type="button" class="text-link" id="empty-reset">Reset filters →</button></div>';
      $('#empty-reset').addEventListener('click',resetFilters);
    } else {
      if (!filtered.some(item=>item.id === selected)) selected = filtered[0].id;
      $('#structure-list').innerHTML = filtered.map(item=>`<button type="button" data-type="${item.id}" aria-current="${item.id === selected}"><span>${String(item.id).padStart(2,'0')}</span><span>${escapeHTML(item.name)}</span></button>`).join('');
      $$('[data-type]').forEach(button=>button.addEventListener('click',()=>{selected = Number(button.dataset.type);activeTab='fields';updateLocation(true);renderList(false);}));
      renderDetail();
    }
    if (save) updateLocation();
  }
  function resetFilters(){ $('#structure-search').value='';$('#group-filter').value='all';renderList();$('#structure-search').focus(); }
  readLocation();
  $('#structure-search').addEventListener('input',()=>renderList());
  $('#group-filter').addEventListener('change',()=>renderList());
  $('#clear-filters').addEventListener('click',resetFilters);
  window.addEventListener('popstate',()=>{readLocation();activeTab='fields';renderList(false);});
  renderList();
}

if (document.body.dataset.page === 'home') { initAtlas(); initMemory(); }
if (document.body.dataset.page === 'explorer') initExplorer();
