---
layout: default
title: Blog
permalink: /blog/
---

<ul class="blog-content">
  {% for post in site.posts %}
    <li>
      <hr/>
      {% include post_title.html date=post.date url=post.url title=post.title %}
      <p class="post-excrept">{{ post.excerpt | strip_html | truncatewords: 40 }}</p>
    </li>
  {% endfor %}
</ul>