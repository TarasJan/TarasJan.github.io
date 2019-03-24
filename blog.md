---
layout: default
title: Blog
permalink: /blog/
---

<ul class="blog-list">
  {% for post in site.posts %}
    <li>
      <p>{{ post.excerpt }}</p>
    </li>
  {% endfor %}
</ul>