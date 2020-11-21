---
layout: default
title: Blog
permalink: /blog/
---

<ul class="blog-content">
  {% for post in site.posts %}
    <hr/>
    <a href="{{ post.url }}">{{ post.title }}</a>
    <span>{{ post.date | date: '%d %b %Y' }}</span><br>
    <span><img src="/assets/img/{{ post.date | date: '%Y-%m-%d' }}.png" alt="Post Image"></span>
    <p class="post-excrept">{{ post.excerpt | strip_html | truncatewords: 40 }}</p>
  {% endfor %}
</ul>