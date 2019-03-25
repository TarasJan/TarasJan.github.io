---
layout: default
title: Blog
permalink: /blog/
---

<ul class="blog-content">
  {% for post in site.posts %}
    <li>
      {% include post_title.html date=post.date url=post.url title=post.title %}
      <p>{{ post.excerpt | strip_html | truncatewords: 40 }}</p>
    </li>
  {% endfor %}
</ul>