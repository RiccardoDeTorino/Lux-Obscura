---
layout: single
title: "All Tags"
permalink: /tags/
author_profile: false
---

<div class="tag-cloud">
  <h2>{{ site.data.ui-text[site.locale].tags_label | default: "Tags" }}</h2>
  
  <ul class="tag-list">
    {% for tag in site.tags %}
      <li>
        <a href="/tags/{{ tag[0] | slugify }}/">{{ tag[0] }}</a> ({{ tag[1].size }})
      </li>
    {% endfor %}
  </ul>
</div>

<style>
.tag-cloud {
  max-width: 800px;
}
.tag-list {
  list-style: none;
  padding: 0;
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}
.tag-list li {
  background: #1a2a1a;
  border: 1px solid #003311;
  border-radius: 4px;
  padding: 0.25rem 0.75rem;
}
.tag-list a {
  color: #00ff41;
  text-decoration: none;
}
.tag-list a:hover {
  text-decoration: underline;
}
.tag-list li::after {
  content: " (" attr(data-count) ")";
  color: #00661a;
  font-size: 0.85em;
}
</style>